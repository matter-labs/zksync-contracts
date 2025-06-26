# IL2DAValidator
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IL2DAValidator.sol)


## Functions
### validatePubdata


```solidity
function validatePubdata(
  bytes32 _chainedLogsHash,
  bytes32 _logsRootHash,
  bytes32 _chainedMessagesHash,
  bytes32 _chainedBytecodesHash,
  bytes calldata _totalL2ToL1PubdataAndStateDiffs
) external returns (bytes32 outputHash);
```

