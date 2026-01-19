// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

bytes1 constant NEW_ENCODING_VERSION = 0x01;

/**
 * @author Matter Labs
 * @custom:security-contact security@matterlabs.dev
 * @notice Helper library for transfer data encoding and decoding to reduce possibility of errors.
 */
library DataEncoding {
  /// @notice Abi.encodes the data required for bridgeBurn for NativeTokenVault.
  /// @param _amount The amount of token to be transferred.
  /// @param _remoteReceiver The address which to receive tokens on remote chain.
  /// @param _maybeTokenAddress The helper field that should be either equal to 0 (in this case
  /// it is assumed that the token has been registered within NativeTokenVault already) or it
  /// can be equal to the address of the token on the current chain.
  /// @return The encoded bridgeBurn data
  function encodeBridgeBurnData(
    uint256 _amount,
    address _remoteReceiver,
    address _maybeTokenAddress
  ) internal pure returns (bytes memory) {
    return abi.encode(_amount, _remoteReceiver, _maybeTokenAddress);
  }

  function encodeAssetRouterBridgehubDepositData(
    bytes32 _assetId,
    bytes memory _transferData
  ) internal pure returns (bytes memory) {
    return
      bytes.concat(NEW_ENCODING_VERSION, abi.encode(_assetId, _transferData));
  }
}
