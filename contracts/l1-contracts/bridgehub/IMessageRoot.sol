// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IBridgehub } from "./IBridgehub.sol";
import { ProofData } from "../common/Messaging.sol";

/**
 * @author Matter Labs
 * @notice MessageRoot contract is responsible for storing and aggregating the roots of the batches from different chains into the MessageRoot.
 * @custom:security-contact security@matterlabs.dev
 */
interface IMessageRoot {
  function BRIDGE_HUB() external view returns (IBridgehub);

  function addNewChain(uint256 _chainId) external;

  function addChainBatchRoot(
    uint256 _chainId,
    uint256 _batchNumber,
    bytes32 _chainBatchRoot
  ) external;

  function historicalRoot(uint256 _blockNumber) external view returns (bytes32);

  /// @dev Used to parse the merkle proof data.
  function getProofData(
    uint256 _chainId,
    uint256 _batchNumber,
    uint256 _leafProofMask,
    bytes32 _leaf,
    bytes32[] calldata _proof
  ) external pure returns (ProofData memory);
}
