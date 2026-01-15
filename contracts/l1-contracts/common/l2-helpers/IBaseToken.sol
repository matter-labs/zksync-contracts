// SPDX-License-Identifier: MIT
// We use a floating point pragma here so it can be used within other projects that interact with the ZKsync ecosystem without using our exact pragma version.
pragma solidity ^0.8.0;

/// @author Matter Labs
/// @custom:security-contact security@matterlabs.dev
/// @notice Interface for the L2 Base Token system contract.
interface IBaseToken {
    /// @notice Withdraws base token to L1.
    /// @param _l1Receiver The address on L1 to receive the tokens.
    function withdraw(address _l1Receiver) external payable;

    /// @notice Withdraws base token to L1 with additional message data.
    /// @param _l1Receiver The address on L1 to receive the tokens.
    /// @param _additionalData Additional data to send with the withdrawal.
    function withdrawWithMessage(address _l1Receiver, bytes calldata _additionalData) external payable;

    /// @notice Mints tokens to the specified address.
    /// @param _account The address to mint tokens to.
    /// @param _amount The amount of tokens to mint.
    function mint(address _account, uint256 _amount) external;

    /// @notice Returns the balance of the specified account.
    /// @param _account The address to query.
    /// @return The balance of the account.
    function balanceOf(address _account) external view returns (uint256);
}
