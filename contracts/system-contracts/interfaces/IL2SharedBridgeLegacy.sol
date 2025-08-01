// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { UpgradeableBeacon } from
  "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

/// @author Matter Labs
/// @custom:security-contact security@matterlabs.dev
interface IL2SharedBridgeLegacy {
  event FinalizeDeposit(
    address indexed l1Sender,
    address indexed l2Receiver,
    address indexed l2Token,
    uint256 amount
  );

  function l2TokenBeacon() external view returns (UpgradeableBeacon);

  function withdraw(address _l1Receiver, address _l2Token, uint256 _amount)
    external;

  function l1TokenAddress(address _l2Token) external view returns (address);

  function l2TokenAddress(address _l1Token) external view returns (address);

  function l1Bridge() external view returns (address);

  function l1SharedBridge() external view returns (address);

  function deployBeaconProxy(bytes32 _salt) external returns (address);

  function sendMessageToL1(bytes calldata _message) external;
}
