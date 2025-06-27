# IL2DAValidator
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IL2DAValidator.sol)


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

