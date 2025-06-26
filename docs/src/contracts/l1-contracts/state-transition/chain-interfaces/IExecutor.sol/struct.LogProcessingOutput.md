# LogProcessingOutput
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IExecutor.sol)


```solidity
struct LogProcessingOutput {
  uint256 numberOfLayer1Txs;
  bytes32 chainedPriorityTxsHash;
  bytes32 previousBatchHash;
  bytes32 pubdataHash;
  bytes32 stateDiffHash;
  bytes32 l2LogsTreeRoot;
  uint256 packedBatchAndL2BlockTimestamp;
  bytes32 l2DAValidatorOutputHash;
}
```

