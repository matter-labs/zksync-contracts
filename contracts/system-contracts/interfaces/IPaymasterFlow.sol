// SPDX-License-Identifier: MIT
// We use a floating point pragma here so it can be used within other projects that interact with the ZKsync ecosystem without using our exact pragma version.
pragma solidity ^0.8.0;

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @dev The interface that is used for encoding/decoding of
 * different types of paymaster flows.
 * @notice This is NOT an interface to be implemented
 * by contracts. It is just used for encoding.
 */
interface IPaymasterFlow {
  function general(bytes calldata input) external;

  function approvalBased(
    address _token,
    uint256 _minAllowance,
    bytes calldata _innerInput
  ) external;
}
