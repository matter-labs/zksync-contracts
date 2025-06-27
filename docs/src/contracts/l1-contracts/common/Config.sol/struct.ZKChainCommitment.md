# ZKChainCommitment
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/common/Config.sol)


```solidity
struct ZKChainCommitment {
  uint256 totalBatchesExecuted;
  uint256 totalBatchesVerified;
  uint256 totalBatchesCommitted;
  bytes32 l2SystemContractsUpgradeTxHash;
  uint256 l2SystemContractsUpgradeBatchNumber;
  bytes32[] batchHashes;
  PriorityTreeCommitment priorityTree;
  bool isPermanentRollup;
}
```

