// SPDX-License-Identifier: MIT
// We use a floating point pragma here so it can be used within other projects that interact with the ZKsync ecosystem without using our exact pragma version.
pragma solidity ^0.8.0;

import {L2Message} from "../common/Messaging.sol";

/// @dev Bundle status enum for InteropHandler
enum BundleStatus {
    Unreceived,
    Verified,
    FullyExecuted,
    Unbundled
}

/// @dev Call status enum for InteropHandler
enum CallStatus {
    Unprocessed,
    Executed,
    Cancelled
}

/// @author Matter Labs
/// @custom:security-contact security@matterlabs.dev
/// @notice Interface for the InteropHandler contract that executes, verifies, and unbundles interop bundles.
interface IInteropHandler {
    /// @notice Proof structure for verifying message inclusion
    struct InteropMessageProof {
        uint256 chainId;
        uint256 l1BatchNumber;
        uint256 l2MessageIndex;
        L2Message message;
        bytes32[] proof;
    }

    event BundleVerified(bytes32 indexed bundleHash);
    event BundleExecuted(bytes32 indexed bundleHash);
    event BundleUnbundled(bytes32 indexed bundleHash);
    event CallProcessed(bytes32 indexed bundleHash, uint256 indexed callIndex, CallStatus status);

    /// @notice Executes a full bundle atomically.
    /// @param _bundle ABI-encoded InteropBundle to execute.
    /// @param _proof Inclusion proof for the bundle message.
    function executeBundle(bytes memory _bundle, InteropMessageProof memory _proof) external;

    /// @notice Verifies receipt of a bundle without executing calls.
    /// @param _bundle ABI-encoded InteropBundle to verify.
    /// @param _proof Inclusion proof for the bundle message.
    function verifyBundle(bytes memory _bundle, InteropMessageProof memory _proof) external;

    /// @notice Unbundles a bundle, allowing partial execution or cancellation of calls.
    /// @param _sourceChainId Originating chain ID of the bundle.
    /// @param _bundle ABI-encoded InteropBundle to unbundle.
    /// @param _providedCallStatus Array of desired statuses per call.
    function unbundleBundle(
        uint256 _sourceChainId,
        bytes memory _bundle,
        CallStatus[] calldata _providedCallStatus
    ) external;

    /// @notice Returns the status of a bundle.
    /// @param bundleHash The hash of the bundle.
    /// @return The current BundleStatus.
    function bundleStatus(bytes32 bundleHash) external view returns (BundleStatus);

    /// @notice Returns the status of a specific call within a bundle.
    /// @param bundleHash The hash of the bundle.
    /// @param callIndex The index of the call.
    /// @return The current CallStatus.
    function callStatus(bytes32 bundleHash, uint256 callIndex) external view returns (CallStatus);
}
