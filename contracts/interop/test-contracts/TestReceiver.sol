// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title TestReceiver
 * @notice Simple contract that implements IERC7786Recipient to receive interop messages
 * @dev Used as a target for sendBundle and sendL2ToL2Call tests.
 *      Must be deployed separately on the destination chain.
 */
contract TestReceiver {
  // InteropHandler addresses differ between Era and OS modes:
  // - Era mode: 0x1000E
  // - OS mode:  0x1000d
  address public immutable interopHandler;

  bytes public lastPayload;
  bytes public lastSender;
  uint256 public messageCount;

  /// @param _interopHandler The InteropHandler address for this chain
  ///        Era mode: 0x000000000000000000000000000000000001000E
  ///        OS mode:  0x000000000000000000000000000000000001000d
  constructor(address _interopHandler) {
    interopHandler = _interopHandler;
  }

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
    require(msg.sender == interopHandler, "must come from interop handler");

    lastPayload = payload;
    lastSender = sender;
    messageCount++;

    // Return the function selector to acknowledge receipt
    return this.receiveMessage.selector;
  }
}
