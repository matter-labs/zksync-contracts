# PriorityTreeCommitment
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/common/Config.sol)


```solidity
struct PriorityTreeCommitment {
  uint256 nextLeafIndex;
  uint256 startIndex;
  uint256 unprocessedIndex;
  bytes32[] sides;
}
```

