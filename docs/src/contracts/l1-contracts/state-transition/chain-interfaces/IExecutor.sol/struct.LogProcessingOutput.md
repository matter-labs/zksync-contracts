# LogProcessingOutput
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-interfaces/IExecutor.sol)


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

