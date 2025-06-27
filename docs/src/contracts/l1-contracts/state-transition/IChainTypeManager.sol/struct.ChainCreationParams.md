# ChainCreationParams
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/IChainTypeManager.sol)

The struct that contains the fields that define how a new chain should be created
within this CTM.


```solidity
struct ChainCreationParams {
  address genesisUpgrade;
  bytes32 genesisBatchHash;
  uint64 genesisIndexRepeatedStorageChanges;
  bytes32 genesisBatchCommitment;
  Diamond.DiamondCutData diamondCut;
  bytes forceDeploymentsData;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`genesisUpgrade`|`address`|The address that is used in the diamond cut initialize address on chain creation|
|`genesisBatchHash`|`bytes32`|Batch hash of the genesis (initial) batch|
|`genesisIndexRepeatedStorageChanges`|`uint64`|The serial number of the shortcut storage key for the genesis batch|
|`genesisBatchCommitment`|`bytes32`|The zk-proof commitment for the genesis batch|
|`diamondCut`|`Diamond.DiamondCutData`|The diamond cut for the first upgrade transaction on the newly deployed chain|
|`forceDeploymentsData`|`bytes`||

