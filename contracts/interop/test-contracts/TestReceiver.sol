// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title TestReceiver
 * @notice Simple contract that implements IERC7786Recipient to receive interop messages
 * @dev Used as a target for sendBundle and sendL2ToL2Call tests.
 *      Must be deployed separately on the destination chain.
 */
contract TestReceiver {
    address constant INTEROP_HANDLER = 0x000000000000000000000000000000000001000d;

    bytes public lastPayload;
    bytes public lastSender;
    uint256 public messageCount;

    /// @notice ERC-7786 receiveMessage function
    /// @param sender The ERC-7930 interoperable address of the sender
    /// @param payload The message payload
    /// @return The function selector to acknowledge receipt
    function receiveMessage(
        bytes32, // receiveId
        bytes calldata sender,
        bytes calldata payload
    ) external payable returns (bytes4) {
        // Only accept messages from interop handler
        require(msg.sender == INTEROP_HANDLER, "must come from interop handler");

        lastPayload = payload;
        lastSender = sender;
        messageCount++;

        // Return the function selector to acknowledge receipt
        return this.receiveMessage.selector;
    }
}
