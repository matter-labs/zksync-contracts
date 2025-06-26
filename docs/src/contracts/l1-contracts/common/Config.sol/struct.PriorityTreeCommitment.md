# PriorityTreeCommitment
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/common/Config.sol)


```solidity
struct PriorityTreeCommitment {
  uint256 nextLeafIndex;
  uint256 startIndex;
  uint256 unprocessedIndex;
  bytes32[] sides;
}
```

