# IGetters
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-interfaces/IGetters.sol)

**Inherits:**
[IZKChainBase](/contracts/l1-contracts/state-transition/chain-interfaces/IZKChainBase.sol/interface.IZKChainBase.md)

**Author:**
Matter Labs

*Most of the methods simply return the values that correspond to the current diamond proxy and possibly
not to the ZK Chain as a whole. For example, if the chain is migrated to another settlement layer, the values returned
by this facet will correspond to the values stored on this chain and possilbly not the canonical state of the chain.*

**Note:**
security-contact: security@matterlabs.dev


## Functions
### getVerifier


```solidity
function getVerifier() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the verifier smart contract|


### getAdmin


```solidity
function getAdmin() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the current admin|


### getPendingAdmin


```solidity
function getPendingAdmin() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the pending admin|


### getBridgehub


```solidity
function getBridgehub() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the bridgehub|


### getChainTypeManager


```solidity
function getChainTypeManager() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the state transition|


### getChainId


```solidity
function getChainId() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The chain ID|


### getBaseToken


```solidity
function getBaseToken() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the base token|


### getBaseTokenAssetId


```solidity
function getBaseTokenAssetId() external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The address of the base token|


### getTotalBatchesCommitted


```solidity
function getTotalBatchesCommitted() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of batches that were committed|


### getTotalBatchesVerified


```solidity
function getTotalBatchesVerified() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of batches that were committed & verified|


### getTotalBatchesExecuted


```solidity
function getTotalBatchesExecuted() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of batches that were committed & verified & executed|


### getTransactionFilterer


```solidity
function getTransactionFilterer() external view returns (address);
```

### getTotalPriorityTxs


```solidity
function getTotalPriorityTxs() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of priority operations that were added to the priority queue, including all processed ones|


### getPriorityTreeStartIndex


```solidity
function getPriorityTreeStartIndex() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The start index of the priority tree, i.e. the index of the first priority operation that was included into the priority tree.|


### getPriorityTreeRoot


```solidity
function getPriorityTreeRoot() external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The root hash of the priority tree|


### isPriorityQueueActive


```solidity
function isPriorityQueueActive() external view returns (bool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the priority queue is active, i.e. whether new priority operations are appended to it. Once the chain processes all the transaction that were present in the priority queue, all the L1->L2 related operations will start to get done using the priority tree.|


### getFirstUnprocessedPriorityTx

The function that returns the first unprocessed priority transaction.

*Returns zero if and only if no operations were processed from the queue.*

*If all the transactions were processed, it will return the last processed index, so
in case exactly *unprocessed* transactions are needed, one should check that getPriorityQueueSize() is greater than 0.*


```solidity
function getFirstUnprocessedPriorityTx() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Index of the oldest priority operation that wasn't processed yet|


### getPriorityQueueSize


```solidity
function getPriorityQueueSize() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The number of priority operations currently in the queue|


### isValidator


```solidity
function isValidator(address _address) external view returns (bool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the address has a validator access|


### l2LogsRootHash


```solidity
function l2LogsRootHash(uint256 _batchNumber)
  external
  view
  returns (bytes32 merkleRoot);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`merkleRoot`|`bytes32`|Merkle root of the tree with L2 logs for the selected batch|


### storedBatchHash

For unfinalized (non executed) batches may change

*returns zero for non-committed batches*


```solidity
function storedBatchHash(uint256 _batchNumber) external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The hash of committed L2 batch.|


### getL2BootloaderBytecodeHash


```solidity
function getL2BootloaderBytecodeHash() external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|Bytecode hash of bootloader program.|


### getL2DefaultAccountBytecodeHash


```solidity
function getL2DefaultAccountBytecodeHash() external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|Bytecode hash of default account (bytecode for EOA).|


### getVerifierParams

*This function is deprecated and will soon be removed.*


```solidity
function getVerifierParams() external view returns (VerifierParams memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`VerifierParams`|Verifier parameters.|


### isDiamondStorageFrozen


```solidity
function isDiamondStorageFrozen() external view returns (bool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the diamond is frozen or not|


### getProtocolVersion


```solidity
function getProtocolVersion() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The current packed protocol version. To access human-readable version, use `getSemverProtocolVersion` function.|


### getSemverProtocolVersion


```solidity
function getSemverProtocolVersion()
  external
  view
  returns (uint32, uint32, uint32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint32`|The tuple of (major, minor, patch) protocol version.|
|`<none>`|`uint32`||
|`<none>`|`uint32`||


### getL2SystemContractsUpgradeTxHash


```solidity
function getL2SystemContractsUpgradeTxHash() external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The upgrade system contract transaction hash, 0 if the upgrade is not initialized|


### getL2SystemContractsUpgradeBatchNumber

*It is equal to 0 in the following two cases:
- No upgrade transaction has ever been processed.
- The upgrade transaction has been processed and the batch with such transaction has been
executed (i.e. finalized).*


```solidity
function getL2SystemContractsUpgradeBatchNumber()
  external
  view
  returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The L2 batch number in which the upgrade transaction was processed.|


### getPriorityTxMaxGasLimit


```solidity
function getPriorityTxMaxGasLimit() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The maximum number of L2 gas that a user can request for L1 -> L2 transactions|


### isEthWithdrawalFinalized


```solidity
function isEthWithdrawalFinalized(
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex
) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_l2BatchNumber`|`uint256`|The L2 batch number within which the withdrawal happened.|
|`_l2MessageIndex`|`uint256`|The index of the L2->L1 message denoting the withdrawal.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether a withdrawal has been finalized.|


### getPubdataPricingMode


```solidity
function getPubdataPricingMode() external view returns (PubdataPricingMode);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`PubdataPricingMode`|The pubdata pricing mode.|


### baseTokenGasPriceMultiplierNominator


```solidity
function baseTokenGasPriceMultiplierNominator() external view returns (uint128);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint128`|the baseTokenGasPriceMultiplierNominator, used to compare the baseTokenPrice to ether for L1->L2 transactions|


### baseTokenGasPriceMultiplierDenominator


```solidity
function baseTokenGasPriceMultiplierDenominator()
  external
  view
  returns (uint128);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint128`|the baseTokenGasPriceMultiplierDenominator, used to compare the baseTokenPrice to ether for L1->L2 transactions|


### facets


```solidity
function facets() external view returns (Facet[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Facet[]`|result All facet addresses and their function selectors|


### facetFunctionSelectors


```solidity
function facetFunctionSelectors(address _facet)
  external
  view
  returns (bytes4[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes4[]`|NON-sorted array with function selectors supported by a specific facet|


### facetAddresses


```solidity
function facetAddresses() external view returns (address[] memory facets);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`facets`|`address[]`|NON-sorted array of facet addresses supported on diamond|


### facetAddress


```solidity
function facetAddress(bytes4 _selector) external view returns (address facet);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`facet`|`address`|The facet address associated with a selector. Zero if the selector is not added to the diamond|


### isFunctionFreezable


```solidity
function isFunctionFreezable(bytes4 _selector) external view returns (bool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the selector can be frozen by the admin or always accessible|


### isFacetFreezable


```solidity
function isFacetFreezable(address _facet)
  external
  view
  returns (bool isFreezable);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isFreezable`|`bool`|Whether the facet can be frozen by the admin or always accessible|


### getSettlementLayer


```solidity
function getSettlementLayer() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the current settlement layer.|


## Structs
### Facet
Faсet structure compatible with the EIP-2535 diamond loupe


```solidity
struct Facet {
  address addr;
  bytes4[] selectors;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`addr`|`address`|The address of the facet contract|
|`selectors`|`bytes4[]`|The NON-sorted array with selectors associated with facet|

