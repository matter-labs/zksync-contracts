// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// solhint-disable no-console, gas-custom-errors

import { Test, console2 as console } from "forge-std/Test.sol";

import {
  IL2NativeTokenVault
} from "../../l1-contracts/bridge/ntv/IL2NativeTokenVault.sol";

import {
  L2_NATIVE_TOKEN_VAULT_ADDR
} from "../../l1-contracts/common/l2-helpers/L2ContractAddresses.sol";
import {
  BundleStatus,
  IInteropHandler
} from "../../l1-contracts/interop/IInteropHandler.sol";
import { InteropScripts } from "../scripts/InteropCommands.s.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title InteropIntegrationTest
 * @notice Integration tests for L2-to-L2 interop functionality
 * @dev These tests require:
 *      - Local L2A running on http://localhost:3050 (chain ID 6565)
 *      - Local L2B running on http://localhost:3051 (chain ID 6566)
 *      - PRIVATE_KEY env var set to a funded account
 *      - FFI enabled in foundry.toml
 *
 * Run with: PRIVATE_KEY=0x... forge test --match-contract InteropIntegrationTest -vvv --ffi
 */
contract InteropIntegrationTest is Test {
  InteropScripts public interop;

  // Chain configuration
  // Era (source) -> Gateway (settlement) -> Validium (destination)
  string constant L2A_RPC = "http://localhost:3050"; // Era (source chain)
  string constant GATEWAY_RPC = "http://localhost:3150"; // Gateway (settlement layer)
  string constant L2B_RPC = "http://localhost:3250"; // Validium (destination chain)
  uint256 constant L2A_CHAIN_ID = 271; // Era chain ID
  uint256 constant GATEWAY_CHAIN_ID = 506; // Gateway chain ID
  uint256 constant L2B_CHAIN_ID = 260; // Validium chain ID

  // Test token on L2A
  address constant TEST_TOKEN = 0xb006D023F4cCaEAa2813f0DbBbFf9c8e511F1f55;

  // Test account (rich account from local setup)
  address constant TEST_ACCOUNT = 0x36615Cf349d7F6344891B1e7CA7C72883F5dc049;

  // Pre-deployed TestReceiver on L2B for native token tests (Era mode)
  // Must implement IERC7786Recipient to receive ETH via InteropHandler
  // Deployed with constructor arg: ERA_INTEROP_HANDLER (0x1000E)
  // For OS mode, deploy with OS_INTEROP_HANDLER (0x1000d) and update this address
  address constant TEST_RECEIVER_L2B =
    0x4B5DF730c2e6b28E17013A1485E5d9BC41Efe021;

  // Use era mode by default (for local testing with zksync-era draft-v31)
  // Set to false for zksync-os mode
  bool constant USE_ERA_MODE = true;

  function setUp() public {
    interop = new InteropScripts();
    // Set the mode (era vs zksync-os) - affects contract addresses and proof handling
    interop.setMode(USE_ERA_MODE);
    // Set the Gateway RPC URL for era mode
    interop.setGatewayRpcUrl(GATEWAY_RPC);
    // Make the interop contract persistent across fork switches
    vm.makePersistent(address(interop));
  }

  /// @notice Get the InteropHandler address based on current mode
  function getInteropHandler() internal view returns (address) {
    return interop.getInteropHandler();
  }

  /*//////////////////////////////////////////////////////////////
                            SEND NATIVE TOKEN TEST
    //////////////////////////////////////////////////////////////*/

  /// @notice Test sending native token (ETH) from L2A to L2B
  /// @dev Flow: send -> get bundle hash -> verify (waits for interop root) -> execute -> check balance
  ///      The recipient must implement IERC7786Recipient because InteropHandler calls receiveMessage()
  function test_sendNativeToken_executedOnDestination() public {
    uint256 amount = 0.001 ether;

    // Step 1: Send native tokens from L2A (Era) to L2B
    // Note: recipient must implement IERC7786Recipient - InteropHandler calls receiveMessage{value: amount}()
    console.log("Step 1: Sending native tokens from L2A to L2B...");
    bytes32 txHash = interop.sendNativeToL2(
      L2A_RPC,
      TEST_RECEIVER_L2B, // recipient - must be contract implementing IERC7786Recipient
      TEST_ACCOUNT, // unbundler
      amount,
      L2B_CHAIN_ID
    );
    console.log("sendNativeToL2 tx hash:");
    console.logBytes32(txHash);
    assertTrue(txHash != bytes32(0), "Transaction hash should not be zero");

    // Step 2: Get bundle hash from the transaction
    console.log("Step 2: Getting bundle hash...");
    bytes32 bundleHash = interop.getBundleHash(L2A_RPC, txHash);
    console.log("Bundle hash:");
    console.logBytes32(bundleHash);
    assertTrue(bundleHash != bytes32(0), "Bundle hash should not be zero");

    // Step 3: Verify bundle (this waits for interop root to be available)
    console.log("Step 3: Verifying bundle (waiting for interop root)...");
    interop.verifyInteropBundle(L2B_RPC, L2A_RPC, txHash, getInteropHandler());
    console.log("Bundle verified!");

    // Step 4: Execute the bundle on destination chain
    console.log("Step 4: Executing bundle on destination...");
    interop.executeInteropBundle(L2B_RPC, L2A_RPC, txHash, getInteropHandler());

    // Step 5: Check bundle status via FFI (to get fresh state from chain)
    console.log("Step 5: Checking bundle status...");
    vm.sleep(2000); // Wait for transaction to be processed
    BundleStatus status = _getBundleStatusFFI(L2B_RPC, bundleHash);
    console.log("Bundle status:", uint8(status));
    assertEq(
      uint8(status),
      uint8(BundleStatus.FullyExecuted),
      "Bundle should be fully executed"
    );
  }

  /*//////////////////////////////////////////////////////////////
                            SEND TOKEN TEST
    //////////////////////////////////////////////////////////////*/

  /// @notice Test sending ERC20 tokens from L2A to L2B
  /// @dev Flow: send -> get bundle hash -> verify (waits for interop root) -> execute -> check status
  function test_sendToken_executedOnDestination() public {
    uint256 amount = 10;

    // Step 1: Send tokens from L2A to L2B
    console.log("Step 1: Sending tokens from L2A to L2B...");
    bytes32 txHash = interop.sendToken(
      L2A_RPC, TEST_TOKEN, TEST_ACCOUNT, amount, L2B_CHAIN_ID
    );
    console.log("sendToken tx hash:");
    console.logBytes32(txHash);
    assertTrue(txHash != bytes32(0), "Transaction hash should not be zero");

    // Step 2: Get bundle hash from the transaction
    console.log("Step 2: Getting bundle hash...");
    bytes32 bundleHash = interop.getBundleHash(L2A_RPC, txHash);
    console.log("Bundle hash:");
    console.logBytes32(bundleHash);
    assertTrue(bundleHash != bytes32(0), "Bundle hash should not be zero");

    // Step 3: Verify bundle (this waits for interop root to be available)
    console.log("Step 3: Verifying bundle (waiting for interop root)...");
    interop.verifyInteropBundle(L2B_RPC, L2A_RPC, txHash, getInteropHandler());
    console.log("Bundle verified!");

    // Step 4: Execute the bundle on destination chain
    console.log("Step 4: Executing bundle on destination...");
    interop.executeInteropBundle(L2B_RPC, L2A_RPC, txHash, getInteropHandler());

    // Step 5: Check bundle status via FFI (to get fresh state from chain)
    console.log("Step 5: Checking bundle status...");
    vm.sleep(2000); // Wait for transaction to be processed
    BundleStatus status = _getBundleStatusFFI(L2B_RPC, bundleHash);
    console.log("Bundle status:", uint8(status));
    assertEq(
      uint8(status),
      uint8(BundleStatus.FullyExecuted),
      "Bundle should be fully executed"
    );
  }

  /*//////////////////////////////////////////////////////////////
                            SEND MESSAGE TEST
    //////////////////////////////////////////////////////////////*/

  /// @notice Test sending a message and verifying it was delivered on destination chain
  /// @dev Flow: send -> wait for proof -> wait for interop root -> verify inclusion
  function test_sendMessage_verifiedOnDestination() public {
    bytes memory message = "Hello from L2A to L2B!";

    // Step 1: Send the message from L2A
    console.log("Step 1: Sending message from L2A...");
    bytes32 txHash = interop.sendMessage(L2A_RPC, message);
    console.log("sendMessage tx hash:");
    console.logBytes32(txHash);
    assertTrue(txHash != bytes32(0), "Transaction hash should not be zero");

    // Step 2: Verify message delivery on destination chain
    // This waits for proof and interop root, then calls proveL2MessageInclusionShared
    console.log("Step 2: Verifying message delivery on destination...");
    bool verified = interop.verifyMessageDelivery(L2A_RPC, L2B_RPC, txHash);
    assertTrue(verified, "Message should be verified on destination chain");
  }

  /*//////////////////////////////////////////////////////////////
                            SEND BUNDLE TEST
    //////////////////////////////////////////////////////////////*/

  /// @notice Test sending a bundle and executing it on destination
  /// @dev Flow: deploy receiver -> send -> get bundle hash -> verify -> execute -> check status
  ///      The target must be a contract implementing receiveMessage (IERC7786Recipient)
  function test_sendBundle_executedOnDestination() public {
    // Step 0: Deploy TestReceiver contract on L2B (destination chain)
    console.log("Step 0: Deploying TestReceiver on destination chain...");
    address receiverAddr = _deployTestReceiverFFI(L2B_RPC);
    console.log("TestReceiver deployed at:", receiverAddr);
    require(receiverAddr != address(0), "Failed to deploy TestReceiver");

    address[] memory targets = new address[](1);
    targets[0] = receiverAddr;

    // Encode a test payload for the receiver
    bytes[] memory calldatas = new bytes[](1);
    calldatas[0] = abi.encode("Hello from bundle!");

    // Step 1: Send bundle from L2A to L2B
    // Use a unique unbundler address to ensure unique bundle hash each run
    console.log("Step 1: Sending bundle from L2A to L2B...");
    address uniqueUnbundler = address(
      uint160(
        uint256(keccak256(abi.encode(block.timestamp, block.number, gasleft())))
      )
    );
    bytes32 txHash = interop.sendBundle(
      L2A_RPC,
      L2B_CHAIN_ID,
      targets,
      calldatas,
      address(0), // permissionless execution
      uniqueUnbundler // unique unbundler to make bundle hash unique
    );
    console.log("sendBundle tx hash:");
    console.logBytes32(txHash);
    assertTrue(txHash != bytes32(0), "Transaction hash should not be zero");

    // Step 2: Get bundle hash
    console.log("Step 2: Getting bundle hash...");
    bytes32 bundleHash = interop.getBundleHash(L2A_RPC, txHash);
    console.log("Bundle hash:");
    console.logBytes32(bundleHash);
    assertTrue(bundleHash != bytes32(0), "Bundle hash should not be zero");

    // Step 3: Verify bundle (waits for interop root)
    console.log("Step 3: Verifying bundle...");
    interop.verifyInteropBundle(L2B_RPC, L2A_RPC, txHash, getInteropHandler());
    console.log("Bundle verified!");

    // Step 4: Execute bundle on destination
    console.log("Step 4: Executing bundle...");
    interop.executeInteropBundle(L2B_RPC, L2A_RPC, txHash, getInteropHandler());

    // Step 5: Verify bundle was executed via FFI
    console.log("Step 5: Checking bundle status...");
    vm.sleep(2000);
    BundleStatus status = _getBundleStatusFFI(L2B_RPC, bundleHash);
    console.log("Bundle status:", uint8(status));
    assertEq(
      uint8(status),
      uint8(BundleStatus.FullyExecuted),
      "Bundle should be fully executed"
    );

    // Step 6: Verify receiver got the message
    console.log("Step 6: Verifying receiver got the message...");
    uint256 messageCount = _getReceiverMessageCountFFI(L2B_RPC, receiverAddr);
    console.log("Receiver message count:", messageCount);
    assertEq(
      messageCount, 1, "Receiver should have received exactly one message"
    );
  }

  /*//////////////////////////////////////////////////////////////
                            SEND L2-TO-L2 CALL TEST
    //////////////////////////////////////////////////////////////*/

  /// @notice Test sending a direct L2-to-L2 call and executing it on destination
  /// @dev Flow: deploy receiver -> send call -> get bundle hash -> verify -> execute -> check status
  ///      Uses sendL2ToL2Call which wraps sendMessage on InteropCenter
  ///      The target must be a contract implementing receiveMessage (IERC7786Recipient)
  function test_sendL2ToL2Call_executedOnDestination() public {
    // Step 0: Deploy TestReceiver contract on L2B (destination chain)
    console.log("Step 0: Deploying TestReceiver on destination chain...");
    address receiverAddr = _deployTestReceiverFFI(L2B_RPC);
    console.log("TestReceiver deployed at:", receiverAddr);
    require(receiverAddr != address(0), "Failed to deploy TestReceiver");

    // Encode a test payload for the receiver
    bytes memory callData = abi.encode("Hello from L2ToL2Call!");

    // Step 1: Send L2-to-L2 call from L2A to L2B
    console.log("Step 1: Sending L2-to-L2 call from L2A to L2B...");
    bytes32 txHash = interop.sendL2ToL2Call(
      L2A_RPC,
      L2B_CHAIN_ID,
      receiverAddr,
      callData,
      address(0), // permissionless execution
      address(0) // default unbundler (sender)
    );
    console.log("sendL2ToL2Call tx hash:");
    console.logBytes32(txHash);
    assertTrue(txHash != bytes32(0), "Transaction hash should not be zero");

    // Step 2: Get bundle hash
    console.log("Step 2: Getting bundle hash...");
    bytes32 bundleHash = interop.getBundleHash(L2A_RPC, txHash);
    console.log("Bundle hash:");
    console.logBytes32(bundleHash);
    assertTrue(bundleHash != bytes32(0), "Bundle hash should not be zero");

    // Step 3: Verify bundle (waits for interop root)
    console.log("Step 3: Verifying bundle...");
    interop.verifyInteropBundle(L2B_RPC, L2A_RPC, txHash, getInteropHandler());
    console.log("Bundle verified!");

    // Step 4: Execute bundle on destination
    console.log("Step 4: Executing bundle...");
    interop.executeInteropBundle(L2B_RPC, L2A_RPC, txHash, getInteropHandler());

    // Step 5: Verify bundle was executed via FFI
    console.log("Step 5: Checking bundle status...");
    vm.sleep(2000);
    BundleStatus status = _getBundleStatusFFI(L2B_RPC, bundleHash);
    console.log("Bundle status:", uint8(status));
    assertEq(
      uint8(status),
      uint8(BundleStatus.FullyExecuted),
      "Bundle should be fully executed"
    );

    // Step 6: Verify receiver got the message
    console.log("Step 6: Verifying receiver got the message...");
    uint256 messageCount = _getReceiverMessageCountFFI(L2B_RPC, receiverAddr);
    console.log("Receiver message count:", messageCount);
    assertEq(
      messageCount, 1, "Receiver should have received exactly one message"
    );
  }

  /*//////////////////////////////////////////////////////////////
                            HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

  /// @dev Get bundle status via FFI to read fresh state from chain
  function _getBundleStatusFFI(string memory rpcUrl, bytes32 bundleHash)
    internal
    returns (BundleStatus)
  {
    string[] memory cmd = new string[](7);
    cmd[0] = "cast";
    cmd[1] = "call";
    cmd[2] = vm.toString(getInteropHandler());
    cmd[3] = "bundleStatus(bytes32)(uint8)";
    cmd[4] = vm.toString(bundleHash);
    cmd[5] = "--rpc-url";
    cmd[6] = rpcUrl;

    bytes memory result = vm.ffi(cmd);
    // Result is ASCII string like "0" or "2", parse it
    uint8 status = uint8(vm.parseUint(string(result)));
    return BundleStatus(status);
  }

  function _getAssetId(string memory rpcUrl, address token)
    internal
    returns (bytes32)
  {
    vm.createSelectFork(rpcUrl);
    return IL2NativeTokenVault(L2_NATIVE_TOKEN_VAULT_ADDR).assetId(token);
  }

  /// @dev Deploy TestReceiver contract on destination chain via FFI
  /// @param rpcUrl RPC URL of the destination chain
  /// @return deployedAddr Address of the deployed TestReceiver contract
  function _deployTestReceiverFFI(string memory rpcUrl)
    internal
    returns (address)
  {
    string memory privateKey = vm.envString("PRIVATE_KEY");

    // Use forge create to deploy the contract with constructor args
    // TestReceiver(address _interopHandler) - pass the correct InteropHandler address
    string[] memory cmd = new string[](11);
    cmd[0] = "forge";
    cmd[1] = "create";
    cmd[2] = "contracts/interop/test-contracts/TestReceiver.sol:TestReceiver";
    cmd[3] = "--rpc-url";
    cmd[4] = rpcUrl;
    cmd[5] = "--private-key";
    cmd[6] = privateKey;
    cmd[7] = "--json";
    cmd[8] = "--broadcast";
    cmd[9] = "--constructor-args";
    cmd[10] = vm.toString(getInteropHandler()); // Pass InteropHandler address based on mode

    bytes memory result = vm.ffi(cmd);
    string memory resultStr = string(result);

    // Parse deployed address from JSON output
    // Format: {"deployer":"0x...","deployedTo":"0x...","transactionHash":"0x..."}
    address deployedAddr = vm.parseJsonAddress(resultStr, ".deployedTo");
    return deployedAddr;
  }

  /// @dev Get message count from TestReceiver via FFI
  function _getReceiverMessageCountFFI(string memory rpcUrl, address receiver)
    internal
    returns (uint256)
  {
    string[] memory cmd = new string[](5);
    cmd[0] = "cast";
    cmd[1] = "call";
    cmd[2] = vm.toString(receiver);
    cmd[3] = "messageCount()(uint256)";
    cmd[4] = "--rpc-url";

    // Need to add rpc-url value separately
    string[] memory fullCmd = new string[](6);
    fullCmd[0] = "cast";
    fullCmd[1] = "call";
    fullCmd[2] = vm.toString(receiver);
    fullCmd[3] = "messageCount()(uint256)";
    fullCmd[4] = "--rpc-url";
    fullCmd[5] = rpcUrl;

    bytes memory result = vm.ffi(fullCmd);
    // Result is ASCII string like "0" or "1", parse it
    return vm.parseUint(string(result));
  }
}
