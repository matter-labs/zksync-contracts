// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// solhint-disable no-console, gas-custom-errors

import {Script, console2 as console} from "forge-std/Script.sol";

import {InteropLibrary} from "../../InteropLibrary.sol";
import {ZKSProvider} from "../../provider/ZKSProvider.s.sol";
import {InteropBundle, InteropCallStarter, L2Message} from "../../../l1-contracts/common/Messaging.sol";
import {IInteropCenter} from "../../../l1-contracts/interop/IInteropCenter.sol";
import {IInteropHandler, BundleStatus, CallStatus} from "../../../l1-contracts/interop/IInteropHandler.sol";
import {InteroperableAddress} from "../../../l1-contracts/vendor/draft-InteroperableAddress.sol";
import {L2ToL1LogProof, TransactionReceipt} from "../../provider/ReceipTypes.sol";
import {
    L2_BASE_TOKEN_SYSTEM_CONTRACT_ADDR,
    L2_TO_L1_MESSENGER_SYSTEM_CONTRACT_ADDR,
    L2_NATIVE_TOKEN_VAULT_ADDR,
    L2_ASSET_ROUTER_ADDR
} from "../../../l1-contracts/common/l2-helpers/L2ContractAddresses.sol";
import {IL2ToL1Messenger} from "../../../l1-contracts/common/l2-helpers/IL2ToL1Messenger.sol";
import {IBaseToken} from "../../../l1-contracts/common/l2-helpers/IBaseToken.sol";
import {IL2NativeTokenVault} from "../../../l1-contracts/bridge/ntv/IL2NativeTokenVault.sol";
import {INativeTokenVault} from "../../../l1-contracts/bridge/ntv/INativeTokenVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteropDemo is Script, ZKSProvider {
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
    function sendMessage(
        string memory l2RpcUrl,
        bytes memory message
    ) public returns (bytes32 messageHash) {
        vm.createSelectFork(l2RpcUrl);
        vm.startBroadcast();
        messageHash = IL2ToL1Messenger(L2_TO_L1_MESSENGER_SYSTEM_CONTRACT_ADDR).sendToL1(message);
        vm.stopBroadcast();
        console.log("L2->L2 message sent (verify on destination with proveL2MessageInclusionShared)");
        console.logBytes32(messageHash);
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
    function withdrawToL1(
        string memory l2RpcUrl,
        address l1Receiver,
        uint256 amount
    ) public {
        vm.createSelectFork(l2RpcUrl);
        vm.startBroadcast();
        IBaseToken(L2_BASE_TOKEN_SYSTEM_CONTRACT_ADDR).withdraw{value: amount}(l1Receiver);
        vm.stopBroadcast();
        console.log("Withdrawal initiated to L1 receiver:", l1Receiver);
        console.log("Amount:", amount);
    }

    /// @notice Withdraw base token from L2 to L1 with additional message data.
    /// @param l2RpcUrl The RPC URL for the L2 chain
    /// @param l1Receiver The address to receive tokens on L1
    /// @param amount The amount of tokens to withdraw
    /// @param additionalData Additional data to send with the withdrawal
    function withdrawToL1WithMessage(
        string memory l2RpcUrl,
        address l1Receiver,
        uint256 amount,
        bytes memory additionalData
    ) public {
        vm.createSelectFork(l2RpcUrl);
        vm.startBroadcast();
        IBaseToken(L2_BASE_TOKEN_SYSTEM_CONTRACT_ADDR).withdrawWithMessage{value: amount}(l1Receiver, additionalData);
        vm.stopBroadcast();
        console.log("Withdrawal with message initiated to L1 receiver:", l1Receiver);
        console.log("Amount:", amount);
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
    function sendNativeToL2(
        string memory l2RpcUrl,
        address l2Receiver,
        address unbundlerAddress,
        uint256 amount,
        uint256 destinationL2ChainId
    ) public returns (bytes32 bundleHash) {
        vm.createSelectFork(l2RpcUrl);
        vm.startBroadcast();
        InteropCallStarter[] memory calls = new InteropCallStarter[](1);
        calls[0] = InteropLibrary.buildSendDestinationChainBaseTokenCall(destinationL2ChainId, l2Receiver, amount);
        bytes[] memory bundleAttributes = InteropLibrary.buildBundleAttributes(unbundlerAddress);
        bundleHash = IInteropCenter(INTEROP_CENTER).sendBundle{value: amount}(
            InteroperableAddress.formatEvmV1(destinationL2ChainId),
            calls,
            bundleAttributes
        );
        vm.stopBroadcast();
        console.logBytes32(bundleHash);
    }

    /// @notice Send ERC20 tokens from one L2 to another L2 using interop.
    /// @dev Similar to token-interop.js - registers token, approves, and sends via InteropCenter.
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
        vm.startBroadcast();

        // Step 1: Ensure token is registered in NTV
        IL2NativeTokenVault ntv = IL2NativeTokenVault(L2_NATIVE_TOKEN_VAULT_ADDR);
        bytes32 assetId = ntv.assetId(tokenAddress);
        if (assetId == bytes32(0)) {
            assetId = ntv.ensureTokenIsRegistered(tokenAddress);
            console.log("Token registered with assetId:");
            console.logBytes32(assetId);
        }

        // Step 2: Approve NTV to spend tokens
        IERC20(tokenAddress).approve(L2_NATIVE_TOKEN_VAULT_ADDR, amount);
        console.log("Approved NTV to spend tokens");

        // Step 3: Build the interop bundle
        bundleHash = InteropLibrary.sendToken(
            destinationL2ChainId,
            tokenAddress,
            amount,
            recipient,
            recipient // unbundler = recipient
        );

        vm.stopBroadcast();
        console.log("Token transfer bundle sent:");
        console.logBytes32(bundleHash);
    }

    /// @notice Send an L2 -> L2 interop call using the InteropLibrary helpers.
    function sendL2ToL2Call(
        string memory l2RpcUrl,
        uint256 destinationChainId,
        address target,
        bytes memory data,
        address executionAddress,
        address unbundlerAddress
    ) public returns (bytes32 bundleHash) {
        vm.createSelectFork(l2RpcUrl);
        vm.startBroadcast();
        bundleHash = InteropLibrary.sendDirectCall(
            destinationChainId,
            target,
            data,
            executionAddress,
            unbundlerAddress
        );
        vm.stopBroadcast();
        console.logBytes32(bundleHash);
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

        // Step 8: Execute the bundle on destination chain
        console.log("Step 6: Executing bundle on destination chain...");
        vm.createSelectFork(destL2RpcUrl);
        vm.startBroadcast();
        IInteropHandler(interopHandlerAddress).executeBundle(encodedBundle, proof);
        vm.stopBroadcast();

        console.log("Bundle executed successfully!");
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
        vm.startBroadcast();
        IInteropHandler(interopHandlerAddress).verifyBundle(encodedBundle, proof);
        vm.stopBroadcast();

        console.log("Bundle verified successfully!");
    }

    /*//////////////////////////////////////////////////////////////
                            BUNDLE STATUS
    //////////////////////////////////////////////////////////////*/

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
