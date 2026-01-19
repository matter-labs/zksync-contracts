// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// solhint-disable no-console, gas-custom-errors

import {Script, console2 as console} from "forge-std/Script.sol";

import {InteropLibrary} from "../InteropLibrary.sol";
import {ZKSProvider} from "../provider/ZKSProvider.s.sol";
import {InteropBundle, InteropCallStarter, L2Message} from "../../l1-contracts/common/Messaging.sol";
import {IInteropCenter} from "../../l1-contracts/interop/IInteropCenter.sol";
import {IInteropHandler, BundleStatus, CallStatus} from "../../l1-contracts/interop/IInteropHandler.sol";
import {InteroperableAddress} from "../../l1-contracts/vendor/draft-InteroperableAddress.sol";
import {L2ToL1LogProof, TransactionReceipt} from "../provider/ReceipTypes.sol";
import {
    L2_BASE_TOKEN_SYSTEM_CONTRACT_ADDR,
    L2_TO_L1_MESSENGER_SYSTEM_CONTRACT_ADDR,
    L2_NATIVE_TOKEN_VAULT_ADDR,
    L2_ASSET_ROUTER_ADDR
} from "../../l1-contracts/common/l2-helpers/L2ContractAddresses.sol";
import {IL2ToL1Messenger} from "../../l1-contracts/common/l2-helpers/IL2ToL1Messenger.sol";
import {IBaseToken} from "../../l1-contracts/common/l2-helpers/IBaseToken.sol";
import {IL2NativeTokenVault} from "../../l1-contracts/bridge/ntv/IL2NativeTokenVault.sol";
import {INativeTokenVault} from "../../l1-contracts/bridge/ntv/INativeTokenVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC7786GatewaySource} from "../../l1-contracts/interop/IERC7786GatewaySource.sol";

contract InteropScripts is Script, ZKSProvider {
    /*//////////////////////////////////////////////////////////////
                            CONFIGURATION
    //////////////////////////////////////////////////////////////*/

    // System contract addresses (these are fixed across all zkSync chains)
    address public constant INTEROP_CENTER = 0x0000000000000000000000000000000000010010;
    address public constant INTEROP_HANDLER = 0x000000000000000000000000000000000001000d;
    address public constant INTEROP_ROOT_STORAGE = 0x0000000000000000000000000000000000010008;

    bytes1 private constant BUNDLE_IDENTIFIER = 0x01;

    bytes32 private constant INTEROP_BUNDLE_SENT_EVENT = keccak256(
        "InteropBundleSent(bytes32,bytes32,(bytes1,uint256,uint256,bytes32,(bytes1,bool,address,address,uint256,bytes)[],(bytes,bytes)))"
    );

    /*//////////////////////////////////////////////////////////////
                            L2 -> L2 MESSAGE (via shared interop)
    //////////////////////////////////////////////////////////////*/

    /// @notice Send a simple message from one L2 to another L2 via shared interop messaging.
    /// @dev Similar to interop.js - sends message via L2ToL1Messenger, verifiable on destination L2
    ///      using proveL2MessageInclusionShared after interop root propagates.
    /// @param l2RpcUrl The RPC URL for the source L2 chain
    /// @param message The message bytes to send
    /// @return txHash The transaction hash of the sendToL1 call
    function sendMessage(
        string memory l2RpcUrl,
        bytes memory message
    ) public returns (bytes32 txHash) {
        string memory privateKey = vm.envString("PRIVATE_KEY");

        // Build calldata for sendToL1(bytes)
        bytes memory callData = abi.encodeWithSelector(
            IL2ToL1Messenger.sendToL1.selector,
            message
        );

        txHash = _castSendRaw(l2RpcUrl, privateKey, L2_TO_L1_MESSENGER_SYSTEM_CONTRACT_ADDR, callData);
        console.log("L2->L2 message sent (verify on destination with proveL2MessageInclusionShared)");
        console.log("Transaction hash:");
        console.logBytes32(txHash);
    }

    /// @notice Send a string message from one L2 to another L2.
    /// @param l2RpcUrl The RPC URL for the source L2 chain
    /// @param message The string message to send
    function sendMessageString(
        string memory l2RpcUrl,
        string memory message
    ) public returns (bytes32 messageHash) {
        return sendMessage(l2RpcUrl, bytes(message));
    }

    /*//////////////////////////////////////////////////////////////
                            L2 -> L1 WITHDRAWAL
    //////////////////////////////////////////////////////////////*/

    /// @notice Withdraw base token from L2 to L1 using the traditional L2 base token system contract.
    /// @dev This uses the L2BaseToken.withdraw() which sends via L2-to-L1 messenger.
    /// @param l2RpcUrl The RPC URL for the L2 chain
    /// @param l1Receiver The address to receive tokens on L1
    /// @param amount The amount of tokens to withdraw
    /// @return txHash The transaction hash of the withdrawal
    function withdrawToL1(
        string memory l2RpcUrl,
        address l1Receiver,
        uint256 amount
    ) public returns (bytes32 txHash) {
        string memory privateKey = vm.envString("PRIVATE_KEY");

        // Build calldata for withdraw(address)
        bytes memory callData = abi.encodeWithSelector(
            IBaseToken.withdraw.selector,
            l1Receiver
        );

        txHash = _castSendRawWithValue(l2RpcUrl, privateKey, L2_BASE_TOKEN_SYSTEM_CONTRACT_ADDR, callData, amount);
        console.log("Withdrawal initiated to L1 receiver:", l1Receiver);
        console.log("Amount:", amount);
        console.log("Transaction hash:");
        console.logBytes32(txHash);
    }

    /// @notice Withdraw base token from L2 to L1 with additional message data.
    /// @param l2RpcUrl The RPC URL for the L2 chain
    /// @param l1Receiver The address to receive tokens on L1
    /// @param amount The amount of tokens to withdraw
    /// @param additionalData Additional data to send with the withdrawal
    /// @return txHash The transaction hash of the withdrawal
    function withdrawToL1WithMessage(
        string memory l2RpcUrl,
        address l1Receiver,
        uint256 amount,
        bytes memory additionalData
    ) public returns (bytes32 txHash) {
        string memory privateKey = vm.envString("PRIVATE_KEY");

        // Build calldata for withdrawWithMessage(address,bytes)
        bytes memory callData = abi.encodeWithSelector(
            IBaseToken.withdrawWithMessage.selector,
            l1Receiver,
            additionalData
        );

        txHash = _castSendRawWithValue(l2RpcUrl, privateKey, L2_BASE_TOKEN_SYSTEM_CONTRACT_ADDR, callData, amount);
        console.log("Withdrawal with message initiated to L1 receiver:", l1Receiver);
        console.log("Amount:", amount);
        console.log("Transaction hash:");
        console.logBytes32(txHash);
    }

    /*//////////////////////////////////////////////////////////////
                            L2 -> L2 INTEROP
    //////////////////////////////////////////////////////////////*/

    /// @notice Send base token from one L2 to another L2 using interop.
    /// @dev This uses InteropCenter.sendBundle() which only works for L2-to-L2 transfers.
    /// @param l2RpcUrl The RPC URL for the source L2 chain
    /// @param l2Receiver The address to receive tokens on the destination L2
    /// @param unbundlerAddress The address authorized to unbundle on the destination chain
    /// @param amount The amount of tokens to send
    /// @param destinationL2ChainId The chain ID of the destination L2
    /// @return txHash The transaction hash of the sendBundle call
    function sendNativeToL2(
        string memory l2RpcUrl,
        address l2Receiver,
        address unbundlerAddress,
        uint256 amount,
        uint256 destinationL2ChainId
    ) public returns (bytes32 txHash) {
        vm.createSelectFork(l2RpcUrl);
        string memory privateKey = vm.envString("PRIVATE_KEY");

        InteropCallStarter[] memory calls = new InteropCallStarter[](1);
        calls[0] = InteropLibrary.buildSendDestinationChainBaseTokenCall(destinationL2ChainId, l2Receiver, amount);
        bytes[] memory bundleAttributes = InteropLibrary.buildBundleAttributes(unbundlerAddress);

        bytes memory callData = abi.encodeWithSelector(
            IInteropCenter.sendBundle.selector,
            InteroperableAddress.formatEvmV1(destinationL2ChainId),
            calls,
            bundleAttributes
        );

        txHash = _castSendRawWithValue(l2RpcUrl, privateKey, INTEROP_CENTER, callData, amount);
        console.log("Native token bundle sent to chain:", destinationL2ChainId);
        console.log("Amount:", amount);
        console.log("Transaction hash:");
        console.logBytes32(txHash);
    }

    /// @notice Send a bundle with multiple calls to another L2.
    /// @dev Generic function to send arbitrary interop bundles with multiple calls.
    ///      Each call is a direct call (no indirectCall attribute).
    /// @param l2RpcUrl The RPC URL for the source L2 chain
    /// @param destinationChainId The chain ID of the destination L2
    /// @param targets Array of target contract addresses on destination chain
    /// @param calldatas Array of calldata for each target
    /// @param executionAddress Optional execution address (use address(0) for permissionless)
    /// @param unbundlerAddress The address authorized to unbundle on the destination chain
    /// @return txHash The transaction hash of the sendBundle call
    function sendBundle(
        string memory l2RpcUrl,
        uint256 destinationChainId,
        address[] memory targets,
        bytes[] memory calldatas,
        address executionAddress,
        address unbundlerAddress
    ) public returns (bytes32 txHash) {
        require(targets.length == calldatas.length, "Arrays length mismatch");
        require(targets.length > 0, "Empty calls array");

        string memory privateKey = vm.envString("PRIVATE_KEY");

        // Build the calls array - direct calls without indirectCall attribute
        InteropCallStarter[] memory calls = new InteropCallStarter[](targets.length);
        for (uint256 i = 0; i < targets.length; i++) {
            require(targets[i] != address(0), "Zero target address");
            calls[i] = _buildDirectCall(targets[i], calldatas[i]);
        }

        // Build bundle attributes
        bytes[] memory bundleAttributes = InteropLibrary.buildBundleAttributes(executionAddress, unbundlerAddress);

        // Encode the sendBundle call
        bytes memory callData = abi.encodeWithSelector(
            IInteropCenter.sendBundle.selector,
            InteroperableAddress.formatEvmV1(destinationChainId),
            calls,
            bundleAttributes
        );

        txHash = _castSendRaw(l2RpcUrl, privateKey, INTEROP_CENTER, callData);
        console.log("Bundle sent with", targets.length, "calls to chain:", destinationChainId);
        console.log("Transaction hash:");
        console.logBytes32(txHash);
    }

    /// @dev Build a direct call InteropCallStarter (no indirectCall attribute)
    function _buildDirectCall(
        address target,
        bytes memory data
    ) internal pure returns (InteropCallStarter memory) {
        // Empty call attributes for direct calls
        bytes[] memory callAttributes = new bytes[](0);

        // Use address-only format (no chain ID) since chain is specified at bundle level
        return InteropCallStarter({
            to: InteroperableAddress.formatEvmV1(target),
            data: data,
            callAttributes: callAttributes
        });
    }

    /// @notice Send ERC20 tokens from one L2 to another L2 using interop.
    /// @dev Uses cast send via FFI for all transactions to avoid nonce conflicts with vm.broadcast.
    /// @param l2RpcUrl The RPC URL for the source L2 chain
    /// @param tokenAddress The address of the ERC20 token to send
    /// @param recipient The address to receive tokens on the destination L2
    /// @param amount The amount of tokens to send
    /// @param destinationL2ChainId The chain ID of the destination L2
    function sendToken(
        string memory l2RpcUrl,
        address tokenAddress,
        address recipient,
        uint256 amount,
        uint256 destinationL2ChainId
    ) public returns (bytes32 bundleHash) {
        vm.createSelectFork(l2RpcUrl);
        string memory privateKey = vm.envString("PRIVATE_KEY");

        // Step 1: Check if token is registered in NTV, register if needed
        IL2NativeTokenVault ntv = IL2NativeTokenVault(L2_NATIVE_TOKEN_VAULT_ADDR);
        bytes32 assetId = ntv.assetId(tokenAddress);

        if (assetId == bytes32(0)) {
            console.log("Token not registered in NTV, registering...");
            _castSendRegisterToken(l2RpcUrl, privateKey, tokenAddress);
            // Re-fetch assetId after registration
            vm.createSelectFork(l2RpcUrl);
            assetId = ntv.assetId(tokenAddress);
            require(assetId != bytes32(0), "Token registration failed");
            console.log("Token registered successfully");
        }

        console.log("Token assetId:");
        console.logBytes32(assetId);

        // Step 2: Approve NTV to spend tokens
        console.log("Approving NTV to spend tokens...");
        _castSendApprove(l2RpcUrl, privateKey, tokenAddress, L2_NATIVE_TOKEN_VAULT_ADDR, amount);
        console.log("Approved NTV to spend tokens");

        // Step 3: Build and send the bundle
        console.log("Building and sending token bundle...");
        bytes memory sendBundleData = _buildSendBundleData(assetId, amount, recipient, destinationL2ChainId);

        bytes32 txHash = _castSendRaw(l2RpcUrl, privateKey, INTEROP_CENTER, sendBundleData);
        console.log("Transaction sent:");
        console.logBytes32(txHash);

        // Return txHash - use this with executeInteropBundle to complete the transfer
        bundleHash = txHash;
        console.log("Use this tx hash with executeInteropBundle to complete the transfer on destination chain");
    }

    /// @dev Build the sendBundle calldata
    function _buildSendBundleData(
        bytes32 assetId,
        uint256 amount,
        address recipient,
        uint256 destinationL2ChainId
    ) internal pure returns (bytes memory) {
        bytes memory secondBridgeCalldata = InteropLibrary.buildSecondBridgeCalldata(
            assetId, amount, recipient, address(0)
        );

        InteropCallStarter[] memory calls = new InteropCallStarter[](1);
        calls[0] = InteropLibrary.buildSecondBridgeCall(secondBridgeCalldata, L2_ASSET_ROUTER_ADDR);

        bytes[] memory bundleAttrs = InteropLibrary.buildBundleAttributes(recipient);

        return abi.encodeWithSelector(
            IInteropCenter.sendBundle.selector,
            InteroperableAddress.formatEvmV1(destinationL2ChainId),
            calls,
            bundleAttrs
        );
    }

    /// @dev Get bundle hash from transaction
    function _getBundleHashFromTx(string memory l2RpcUrl, bytes32 txHash) internal returns (bytes32) {
        TransactionReceipt memory receipt = getTransactionReceipt(l2RpcUrl, txHash);
        InteropBundle memory bundle = _getInteropBundle(receipt);
        return keccak256(abi.encode(bundle));
    }

    /// @dev Execute cast send to register token in NTV
    function _castSendRegisterToken(
        string memory rpcUrl,
        string memory privateKey,
        address tokenAddress
    ) internal {
        string[] memory cmd = new string[](10);
        cmd[0] = "cast";
        cmd[1] = "send";
        cmd[2] = "--legacy";
        cmd[3] = "--rpc-url";
        cmd[4] = rpcUrl;
        cmd[5] = "--private-key";
        cmd[6] = privateKey;
        cmd[7] = vm.toString(L2_NATIVE_TOKEN_VAULT_ADDR);
        cmd[8] = "registerToken(address)";
        cmd[9] = vm.toString(tokenAddress);

        vm.ffi(cmd);
    }

    /// @dev Execute cast send for approve
    function _castSendApprove(
        string memory rpcUrl,
        string memory privateKey,
        address tokenAddress,
        address spender,
        uint256 amount
    ) internal {
        string[] memory cmd = new string[](11);
        cmd[0] = "cast";
        cmd[1] = "send";
        cmd[2] = "--legacy";
        cmd[3] = "--rpc-url";
        cmd[4] = rpcUrl;
        cmd[5] = "--private-key";
        cmd[6] = privateKey;
        cmd[7] = vm.toString(tokenAddress);
        cmd[8] = "approve(address,uint256)";
        cmd[9] = vm.toString(spender);
        cmd[10] = vm.toString(amount);

        vm.ffi(cmd);
    }

    /// @dev Execute cast send with raw calldata and return tx hash
    function _castSendRaw(
        string memory rpcUrl,
        string memory privateKey,
        address target,
        bytes memory data
    ) internal returns (bytes32 txHash) {
        // Use --json flag to get structured output (must be after --private-key)
        string[] memory cmd = new string[](10);
        cmd[0] = "cast";
        cmd[1] = "send";
        cmd[2] = "--legacy";
        cmd[3] = "--rpc-url";
        cmd[4] = rpcUrl;
        cmd[5] = "--private-key";
        cmd[6] = privateKey;
        cmd[7] = "--json";
        cmd[8] = vm.toString(target);
        cmd[9] = vm.toString(data);

        bytes memory result = vm.ffi(cmd);
        // Parse JSON to get transactionHash - vm.parseJson returns bytes32 for 0x-prefixed 64-char hex
        txHash = abi.decode(vm.parseJson(string(result), ".transactionHash"), (bytes32));
    }

    /// @dev Execute cast send with raw calldata and value, return tx hash
    function _castSendRawWithValue(
        string memory rpcUrl,
        string memory privateKey,
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes32 txHash) {
        string[] memory cmd = new string[](12);
        cmd[0] = "cast";
        cmd[1] = "send";
        cmd[2] = "--legacy";
        cmd[3] = "--rpc-url";
        cmd[4] = rpcUrl;
        cmd[5] = "--private-key";
        cmd[6] = privateKey;
        cmd[7] = "--json";
        cmd[8] = "--value";
        cmd[9] = vm.toString(value);
        cmd[10] = vm.toString(target);
        cmd[11] = vm.toString(data);

        bytes memory result = vm.ffi(cmd);
        txHash = abi.decode(vm.parseJson(string(result), ".transactionHash"), (bytes32));
    }

    /// @notice Send an L2 -> L2 interop call using the InteropLibrary helpers.
    /// @dev Uses cast send via FFI to avoid issues with zkSync system contracts.
    /// @return txHash The transaction hash of the sendMessage call
    function sendL2ToL2Call(
        string memory l2RpcUrl,
        uint256 destinationChainId,
        address target,
        bytes memory data,
        address executionAddress,
        address unbundlerAddress
    ) public returns (bytes32 txHash) {
        string memory privateKey = vm.envString("PRIVATE_KEY");

        // Build the sendMessage calldata using InteropLibrary helpers
        bytes memory callData = _buildSendDirectCallData(
            destinationChainId,
            target,
            data,
            executionAddress,
            unbundlerAddress
        );

        txHash = _castSendRaw(l2RpcUrl, privateKey, INTEROP_CENTER, callData);
        console.log("L2->L2 call sent via InteropCenter.sendMessage");
        console.log("Transaction hash:");
        console.logBytes32(txHash);
    }

    /// @dev Build the sendMessage calldata for sendL2ToL2Call
    function _buildSendDirectCallData(
        uint256 destinationChainId,
        address target,
        bytes memory data,
        address executionAddress,
        address unbundlerAddress
    ) internal pure returns (bytes memory) {
        // Build call and bundle attributes using InteropLibrary
        (InteropCallStarter memory call, bytes[] memory bundleAttributes) = InteropLibrary.buildCall({
            destinationChainId: destinationChainId,
            target: target,
            executionAddress: executionAddress,
            unbundlerAddress: unbundlerAddress,
            data: data
        });

        // Merge call attributes with bundle attributes
        bytes[] memory mergedAttributes = new bytes[](call.callAttributes.length + bundleAttributes.length);
        for (uint256 i = 0; i < call.callAttributes.length; i++) {
            mergedAttributes[i] = call.callAttributes[i];
        }
        for (uint256 i = 0; i < bundleAttributes.length; i++) {
            mergedAttributes[call.callAttributes.length + i] = bundleAttributes[i];
        }

        // Encode the sendMessage call
        return abi.encodeWithSelector(
            IERC7786GatewaySource.sendMessage.selector,
            call.to,
            call.data,
            mergedAttributes
        );
    }

    /*//////////////////////////////////////////////////////////////
                            EXECUTE BUNDLE (on destination chain)
    //////////////////////////////////////////////////////////////*/

    /// @notice Execute a bundle on the destination chain to finalize an interop transfer.
    /// @dev This is the final step of the interop flow - call this on the destination L2 after:
    ///      1. Sending a bundle via sendToken/sendNativeToL2/sendL2ToL2Call
    ///      2. Waiting for the proof to be available (zks_getL2ToL1LogProof)
    ///      3. Waiting for the interop root to propagate to destination chain
    /// @param destL2RpcUrl The RPC URL for the destination L2 chain
    /// @param sourceL2RpcUrl The RPC URL for the source L2 chain (to fetch receipt and proof)
    /// @param sendBundleTxHash The transaction hash of the sendBundle call on source chain
    /// @param interopHandlerAddress The InteropHandler address on destination chain
    function executeInteropBundle(
        string memory destL2RpcUrl,
        string memory sourceL2RpcUrl,
        bytes32 sendBundleTxHash,
        address interopHandlerAddress
    ) public {
        // Step 1: Get the transaction receipt from source chain
        console.log("Step 1: Fetching transaction receipt from source chain...");
        TransactionReceipt memory receipt = getTransactionReceipt(sourceL2RpcUrl, sendBundleTxHash);
        console.log("Receipt obtained - block:", receipt.blockNumber);

        // Step 2: Get the L2ToL1 log proof from source chain (will wait if not ready)
        console.log("Step 2: Fetching L2ToL1 log proof (waiting for batch to be sealed)...");
        L2ToL1LogProof memory logProof = getL2ToL1LogProof(sourceL2RpcUrl, sendBundleTxHash, 0);
        console.log("Proof obtained - batchNumber:", logProof.batchNumber);
        console.log("Proof messageIndex:", logProof.id);

        // Step 3: Extract the raw L2ToL1 message data from the L2ToL1Messenger event
        // This is the actual message bytes sent via sendToL1(), NOT re-encoded bundle
        console.log("Step 3: Extracting L2ToL1 message data...");
        bytes memory l2ToL1Message = getL2ToL1MessageData(receipt, 0);
        console.log("Message data length:", l2ToL1Message.length);

        // Step 4: Extract the encoded bundle (message without the 0x01 prefix)
        // The message format is: BUNDLE_IDENTIFIER (1 byte) || abi.encode(InteropBundle)
        require(l2ToL1Message.length > 1, "Invalid message length");
        require(l2ToL1Message[0] == BUNDLE_IDENTIFIER, "Invalid bundle identifier");
        bytes memory encodedBundle = new bytes(l2ToL1Message.length - 1);
        for (uint256 i = 1; i < l2ToL1Message.length; i++) {
            encodedBundle[i - 1] = l2ToL1Message[i];
        }

        // Step 5: Extract source chain ID from the bundle for the proof
        // The bundle starts with: offset (32) + version (32 padded) + sourceChainId (32) + ...
        uint256 sourceChainId;
        assembly {
            // Skip offset (32 bytes) and version byte padding (32 bytes), read sourceChainId
            sourceChainId := mload(add(encodedBundle, 96))
        }
        console.log("Source chain ID:", sourceChainId);

        // Step 6: Wait for interop root to propagate to destination chain
        console.log("Step 4: Waiting for interop root on destination chain...");
        waitForInteropRoot(destL2RpcUrl, sourceChainId, logProof.batchNumber, bytes32(0), 300);

        // Step 7: Build the InteropMessageProof struct
        console.log("Step 5: Building proof struct...");
        IInteropHandler.InteropMessageProof memory proof = IInteropHandler.InteropMessageProof({
            chainId: sourceChainId,
            l1BatchNumber: logProof.batchNumber,
            l2MessageIndex: logProof.id,
            message: L2Message({
                txNumberInBatch: uint16(receipt.transactionIndex),
                sender: INTEROP_CENTER,
                data: l2ToL1Message
            }),
            proof: logProof.proof
        });

        // Step 8: Execute the bundle on destination chain via FFI (cast send)
        console.log("Step 6: Executing bundle on destination chain...");
        string memory privateKey = vm.envString("PRIVATE_KEY");

        // Build the executeBundle calldata
        bytes memory executeBundleCalldata = abi.encodeWithSelector(
            IInteropHandler.executeBundle.selector,
            encodedBundle,
            proof
        );

        bytes32 executeTxHash = _castSendRaw(destL2RpcUrl, privateKey, interopHandlerAddress, executeBundleCalldata);
        console.log("Bundle executed successfully! Tx hash:");
        console.logBytes32(executeTxHash);
    }

    /*//////////////////////////////////////////////////////////////
                            VERIFY BUNDLE (2-step flow)
    //////////////////////////////////////////////////////////////*/

    /// @notice Verify a bundle on the destination chain without executing it.
    /// @dev This is the first step of a 2-step flow where you verify first, then execute later.
    ///      Useful when you want to separate verification from execution or need retry logic.
    /// @param destL2RpcUrl The RPC URL for the destination L2 chain
    /// @param sourceL2RpcUrl The RPC URL for the source L2 chain (to fetch receipt and proof)
    /// @param sendBundleTxHash The transaction hash of the sendBundle call on source chain
    /// @param interopHandlerAddress The InteropHandler address on destination chain
    function verifyInteropBundle(
        string memory destL2RpcUrl,
        string memory sourceL2RpcUrl,
        bytes32 sendBundleTxHash,
        address interopHandlerAddress
    ) public {
        console.log("Verifying bundle (without execution)...");
        TransactionReceipt memory receipt = getTransactionReceipt(sourceL2RpcUrl, sendBundleTxHash);
        L2ToL1LogProof memory logProof = getL2ToL1LogProof(sourceL2RpcUrl, sendBundleTxHash, 0);
        bytes memory l2ToL1Message = getL2ToL1MessageData(receipt, 0);

        require(l2ToL1Message.length > 1, "Invalid message length");
        require(l2ToL1Message[0] == BUNDLE_IDENTIFIER, "Invalid bundle identifier");
        bytes memory encodedBundle = new bytes(l2ToL1Message.length - 1);
        for (uint256 i = 1; i < l2ToL1Message.length; i++) {
            encodedBundle[i - 1] = l2ToL1Message[i];
        }

        uint256 sourceChainId;
        assembly {
            sourceChainId := mload(add(encodedBundle, 96))
        }

        waitForInteropRoot(destL2RpcUrl, sourceChainId, logProof.batchNumber, bytes32(0), 300);

        IInteropHandler.InteropMessageProof memory proof = IInteropHandler.InteropMessageProof({
            chainId: sourceChainId,
            l1BatchNumber: logProof.batchNumber,
            l2MessageIndex: logProof.id,
            message: L2Message({
                txNumberInBatch: uint16(receipt.transactionIndex),
                sender: INTEROP_CENTER,
                data: l2ToL1Message
            }),
            proof: logProof.proof
        });

        vm.createSelectFork(destL2RpcUrl);
        IInteropHandler(interopHandlerAddress).verifyBundle(encodedBundle, proof);

        console.log("Bundle verified successfully!");
    }

    /*//////////////////////////////////////////////////////////////
                            BUNDLE HASH & STATUS
    //////////////////////////////////////////////////////////////*/

    /// @notice Get the bundle hash from a sendToken/sendBundle transaction hash.
    /// @dev The bundle hash is in the event data (not indexed) of InteropBundleSent event.
    ///      Event: InteropBundleSent(bytes32 l2l1MsgHash, bytes32 interopBundleHash, InteropBundle interopBundle)
    /// @param l2RpcUrl The RPC URL for the source L2 chain where the tx was sent
    /// @param txHash The transaction hash from sendToken or sendBundle
    /// @return bundleHash The bundle hash to use with getBundleStatus or executeInteropBundle
    function getBundleHash(
        string memory l2RpcUrl,
        bytes32 txHash
    ) public returns (bytes32 bundleHash) {
        TransactionReceipt memory receipt = getTransactionReceipt(l2RpcUrl, txHash);

        // Find the InteropBundleSent event from INTEROP_CENTER
        // Event: InteropBundleSent(bytes32 l2l1MsgHash, bytes32 interopBundleHash, InteropBundle bundle)
        // None of the params are indexed, so topics[0] is the event sig, data contains all params
        for (uint256 i = 0; i < receipt.logs.length; i++) {
            if (receipt.logs[i].addr == INTEROP_CENTER &&
                receipt.logs[i].topics.length > 0 &&
                receipt.logs[i].topics[0] == INTEROP_BUNDLE_SENT_EVENT) {
                // Data is ABI-encoded bytes, first decode to get raw event data
                bytes memory rawData = abi.decode(receipt.logs[i].data, (bytes));
                // The interopBundleHash is the second bytes32 (after l2l1MsgHash)
                // Skip first 32 bytes (l2l1MsgHash), read next 32 bytes (interopBundleHash)
                assembly {
                    bundleHash := mload(add(rawData, 64))
                }
                console.log("Bundle hash:");
                console.logBytes32(bundleHash);
                return bundleHash;
            }
        }
        revert("InteropBundleSent event not found in transaction");
    }

    /// @notice Check the status of a bundle on the destination chain.
    /// @param l2RpcUrl The RPC URL for the L2 chain to check
    /// @param bundleHash The hash of the bundle to check
    /// @return status The current status of the bundle
    function getBundleStatus(
        string memory l2RpcUrl,
        bytes32 bundleHash
    ) public returns (BundleStatus status) {
        vm.createSelectFork(l2RpcUrl);
        status = IInteropHandler(INTEROP_HANDLER).bundleStatus(bundleHash);

        string memory statusStr;
        if (status == BundleStatus.Unreceived) statusStr = "Unreceived";
        else if (status == BundleStatus.Verified) statusStr = "Verified";
        else if (status == BundleStatus.FullyExecuted) statusStr = "FullyExecuted";
        else if (status == BundleStatus.Unbundled) statusStr = "Unbundled";

        console.log("Bundle status:", statusStr);
    }

    /// @notice Check the status of a specific call within a bundle.
    /// @param l2RpcUrl The RPC URL for the L2 chain to check
    /// @param bundleHash The hash of the bundle
    /// @param callIndex The index of the call within the bundle
    /// @return status The current status of the call
    function getCallStatus(
        string memory l2RpcUrl,
        bytes32 bundleHash,
        uint256 callIndex
    ) public returns (CallStatus status) {
        vm.createSelectFork(l2RpcUrl);
        status = IInteropHandler(INTEROP_HANDLER).callStatus(bundleHash, callIndex);

        string memory statusStr;
        if (status == CallStatus.Unprocessed) statusStr = "Unprocessed";
        else if (status == CallStatus.Executed) statusStr = "Executed";
        else if (status == CallStatus.Cancelled) statusStr = "Cancelled";

        console.log("Call", callIndex, "status:", statusStr);
    }

    /*//////////////////////////////////////////////////////////////
                            TOKEN INFO & BALANCE
    //////////////////////////////////////////////////////////////*/

    /// @notice Get token info including assetId and wrapped token address on destination chain.
    /// @param sourceL2RpcUrl The RPC URL for the source L2 chain (where token is native)
    /// @param destL2RpcUrl The RPC URL for the destination L2 chain
    /// @param tokenAddress The token address on source chain
    function getTokenInfo(
        string memory sourceL2RpcUrl,
        string memory destL2RpcUrl,
        address tokenAddress
    ) public returns (bytes32 assetId, address wrappedTokenAddress) {
        // Get assetId from source chain
        vm.createSelectFork(sourceL2RpcUrl);
        assetId = IL2NativeTokenVault(L2_NATIVE_TOKEN_VAULT_ADDR).assetId(tokenAddress);

        uint256 sourceChainId = block.chainid;
        console.log("Source chain ID:", sourceChainId);
        console.log("Token address:", tokenAddress);
        console.log("Asset ID:");
        console.logBytes32(assetId);

        if (assetId == bytes32(0)) {
            console.log("Token not registered on source chain");
            return (assetId, address(0));
        }

        // Get wrapped token address from destination chain
        vm.createSelectFork(destL2RpcUrl);
        uint256 destChainId = block.chainid;
        console.log("Destination chain ID:", destChainId);

        // Query NTV on destination for the wrapped token
        wrappedTokenAddress = IL2NativeTokenVault(L2_NATIVE_TOKEN_VAULT_ADDR).tokenAddress(assetId);

        if (wrappedTokenAddress == address(0)) {
            console.log("Wrapped token not yet deployed on destination chain");
        } else {
            console.log("Wrapped token address:", wrappedTokenAddress);
        }
    }

    /// @notice Check token balance on destination chain.
    /// @param sourceL2RpcUrl The RPC URL for the source L2 chain (to get assetId)
    /// @param destL2RpcUrl The RPC URL for the destination L2 chain
    /// @param tokenAddress The token address on source chain
    /// @param account The account to check balance for
    function getTokenBalance(
        string memory sourceL2RpcUrl,
        string memory destL2RpcUrl,
        address tokenAddress,
        address account
    ) public returns (uint256 balance) {
        // Get assetId and wrapped token address
        (bytes32 assetId, address wrappedTokenAddress) = getTokenInfo(sourceL2RpcUrl, destL2RpcUrl, tokenAddress);

        if (wrappedTokenAddress == address(0)) {
            console.log("Cannot check balance - wrapped token not deployed");
            return 0;
        }

        // Already on destination chain from getTokenInfo
        balance = IERC20(wrappedTokenAddress).balanceOf(account);
        console.log("Balance:", balance);
    }

    /*//////////////////////////////////////////////////////////////
                            SEND SINGLE MESSAGE (ERC-7786)
    //////////////////////////////////////////////////////////////*/

    /// @notice Send a single ERC-7786 interop message to a contract on destination chain.
    /// @dev The destination contract must implement receiveMessage(bytes32, bytes, bytes).
    ///      This is different from sendL2ToL2Call which sends a direct call.
    ///      sendSingleMessage wraps the call in the ERC-7786 receiveMessage format.
    /// @param l2RpcUrl The RPC URL for the source L2 chain
    /// @param destinationChainId The chain ID of the destination L2
    /// @param target The target contract address on destination chain
    /// @param payload The payload to send (will be passed to receiveMessage)
    /// @param executionAddress Optional execution address (use address(0) for permissionless)
    /// @param unbundlerAddress The unbundler address
    function sendSingleMessage(
        string memory l2RpcUrl,
        uint256 destinationChainId,
        address target,
        bytes memory payload,
        address executionAddress,
        address unbundlerAddress
    ) public returns (bytes32 sendId) {
        vm.createSelectFork(l2RpcUrl);
        vm.startBroadcast();

        sendId = InteropLibrary.sendDirectCall(
            destinationChainId,
            target,
            payload,
            executionAddress,
            unbundlerAddress
        );

        vm.stopBroadcast();
        console.log("Message sent with ID:");
        console.logBytes32(sendId);
    }

    /*//////////////////////////////////////////////////////////////
                            MESSAGE VERIFICATION (L2 -> L2 via shared interop)
    //////////////////////////////////////////////////////////////*/

    /// @notice Verify a message was delivered from source chain to destination chain.
    /// @dev This verifies using proveL2MessageInclusionShared on the destination chain.
    ///      Similar to the JavaScript sendInteropMessage flow.
    /// @param sourceRpcUrl The RPC URL for the source L2 chain
    /// @param destRpcUrl The RPC URL for the destination L2 chain
    /// @param txHash The transaction hash of the sendMessage call on source chain
    /// @return verified True if the message was successfully verified on destination
    function verifyMessageDelivery(
        string memory sourceRpcUrl,
        string memory destRpcUrl,
        bytes32 txHash
    ) public returns (bool verified) {
        // Step 1: Get transaction receipt from source chain
        console.log("Verifying message delivery...");
        TransactionReceipt memory receipt = getTransactionReceipt(sourceRpcUrl, txHash);
        console.log("Receipt block:", receipt.blockNumber);

        // Step 2: Get L2ToL1 log proof from source chain
        L2ToL1LogProof memory logProof = getL2ToL1LogProof(sourceRpcUrl, txHash, 0);
        console.log("Proof batch:", logProof.batchNumber);
        console.log("Proof index:", logProof.id);

        // Step 3: Get message data from receipt
        bytes memory messageData = getL2ToL1MessageData(receipt, 0);

        // Step 4: Get source chain ID
        vm.createSelectFork(sourceRpcUrl);
        uint256 sourceChainId = block.chainid;
        address senderAddress = vm.addr(vm.envUint("PRIVATE_KEY"));
        console.log("Source chain ID:", sourceChainId);
        console.log("Sender:", senderAddress);

        // Step 5: Wait for interop root on destination chain
        waitForInteropRoot(destRpcUrl, sourceChainId, logProof.batchNumber, bytes32(0), 120);

        // Step 6: Verify on destination chain using proveL2MessageInclusionShared
        vm.createSelectFork(destRpcUrl);
        address MESSAGE_VERIFICATION = 0x0000000000000000000000000000000000010009;

        verified = _proveL2MessageInclusionShared(
            destRpcUrl,
            MESSAGE_VERIFICATION,
            sourceChainId,
            logProof.batchNumber,
            logProof.id,
            uint16(receipt.transactionIndex),
            senderAddress,
            messageData,
            logProof.proof
        );

        if (verified) {
            console.log("Message verified on destination chain!");
        } else {
            console.log("Message verification FAILED");
        }
    }

    /// @dev Call proveL2MessageInclusionShared via FFI to avoid fork caching issues
    function _proveL2MessageInclusionShared(
        string memory rpcUrl,
        address messageVerification,
        uint256 chainId,
        uint256 batchNumber,
        uint256 index,
        uint16 txNumberInBatch,
        address sender,
        bytes memory data,
        bytes32[] memory proof
    ) internal returns (bool) {
        // Build the calldata for proveL2MessageInclusionShared
        bytes memory callData = abi.encodeWithSignature(
            "proveL2MessageInclusionShared(uint256,uint256,uint256,(uint16,address,bytes),bytes32[])",
            chainId,
            batchNumber,
            index,
            L2Message({
                txNumberInBatch: txNumberInBatch,
                sender: sender,
                data: data
            }),
            proof
        );

        string[] memory cmd = new string[](6);
        cmd[0] = "cast";
        cmd[1] = "call";
        cmd[2] = vm.toString(messageVerification);
        cmd[3] = vm.toString(callData);
        cmd[4] = "--rpc-url";
        cmd[5] = rpcUrl;

        bytes memory result = vm.ffi(cmd);
        // Result is raw bytes (32 bytes), decode as uint256 and check if true (non-zero)
        if (result.length >= 32) {
            uint256 resultValue = abi.decode(result, (uint256));
            return resultValue > 0;
        }
        return false;
    }

    /*//////////////////////////////////////////////////////////////
                            ERC-7930 ENCODING HELPERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Encode an address as ERC-7930 interoperable address (chain + address).
    /// @param chainId The chain ID
    /// @param addr The address
    /// @return encoded The ERC-7930 encoded bytes
    function encodeERC7930(
        uint256 chainId,
        address addr
    ) public pure returns (bytes memory encoded) {
        encoded = InteroperableAddress.formatEvmV1(chainId, addr);
    }

    /// @notice Encode just an address as ERC-7930 (without chain ID).
    /// @param addr The address
    /// @return encoded The ERC-7930 encoded bytes
    function encodeERC7930Address(
        address addr
    ) public pure returns (bytes memory encoded) {
        encoded = InteroperableAddress.formatEvmV1(addr);
    }

    /// @notice Encode just a chain ID as ERC-7930.
    /// @param chainId The chain ID
    /// @return encoded The ERC-7930 encoded bytes
    function encodeERC7930ChainId(
        uint256 chainId
    ) public pure returns (bytes memory encoded) {
        encoded = InteroperableAddress.formatEvmV1(chainId);
    }

    /// @notice Compute the assetId for a token.
    /// @param l2RpcUrl The RPC URL for the L2 chain where the token exists
    /// @param tokenAddress The token address
    function computeAssetId(
        string memory l2RpcUrl,
        address tokenAddress
    ) public returns (bytes32 assetId) {
        vm.createSelectFork(l2RpcUrl);
        assetId = IL2NativeTokenVault(L2_NATIVE_TOKEN_VAULT_ADDR).assetId(tokenAddress);
        console.log("Asset ID for token", tokenAddress);
        console.logBytes32(assetId);
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL HELPERS
    //////////////////////////////////////////////////////////////*/

    function _getInteropBundle(TransactionReceipt memory receipt) internal view returns (InteropBundle memory bundle) {
        uint256 logsLen = receipt.logs.length;
        for (uint256 i = 0; i < logsLen; ++i) {
            if (receipt.logs[i].addr != INTEROP_CENTER) {
                continue;
            }
            if (receipt.logs[i].topics.length == 0 || receipt.logs[i].topics[0] != INTEROP_BUNDLE_SENT_EVENT) {
                continue;
            }
            (, , bundle) = abi.decode(receipt.logs[i].data, (bytes32, bytes32, InteropBundle));
            return bundle;
        }
        revert("Interop bundle event not found");
    }
}
