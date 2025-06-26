# ILegacyGetters
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/ILegacyGetters.sol)

**Inherits:**
[IZKChainBase](/contracts/l1-contracts/state-transition/chain-interfaces/IZKChainBase.sol/interface.IZKChainBase.md)

**Author:**
Matter Labs

*This interface contains getters for the ZKsync contract that should not be used,
but still are kept for backward compatibility.*

**Note:**
security-contact: security@matterlabs.dev


## Functions
### getTotalBlocksCommitted

*It is a *deprecated* method, please use `getTotalBatchesCommitted` instead*


```solidity
function getTotalBlocksCommitted() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of batches that were committed|


### getTotalBlocksVerified

*It is a *deprecated* method, please use `getTotalBatchesVerified` instead.*


```solidity
function getTotalBlocksVerified() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of batches that were committed & verified|


### getTotalBlocksExecuted

*It is a *deprecated* method, please use `getTotalBatchesExecuted` instead.*


```solidity
function getTotalBlocksExecuted() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of batches that were committed & verified & executed|


### storedBlockHash

For unfinalized (non executed) batches may change

*It is a *deprecated* method, please use `storedBatchHash` instead.*

*returns zero for non-committed batches*


```solidity
function storedBlockHash(uint256 _batchNumber) external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The hash of committed L2 batch.|


### getL2SystemContractsUpgradeBlockNumber

*It is a *deprecated* method, please use `getL2SystemContractsUpgradeBatchNumber` instead.*

*It is equal to 0 in the following two cases:
- No upgrade transaction has ever been processed.
- The upgrade transaction has been processed and the batch with such transaction has been
executed (i.e. finalized).*


```solidity
function getL2SystemContractsUpgradeBlockNumber()
  external
  view
  returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The L2 batch number in which the upgrade transaction was processed.|


