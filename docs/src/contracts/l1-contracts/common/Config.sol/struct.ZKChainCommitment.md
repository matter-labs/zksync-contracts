# ZKChainCommitment
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/common/Config.sol)


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

