# L1DAValidatorOutput
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IL1DAValidator.sol)


```solidity
struct L1DAValidatorOutput {
  bytes32 stateDiffHash;
  bytes32[] blobsLinearHashes;
  bytes32[] blobsOpeningCommitments;
}
```

