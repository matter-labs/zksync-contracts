# PriorityTree
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/libraries/PriorityTree.sol)


## Functions
### getFirstUnprocessedPriorityTx

Returns zero if and only if no operations were processed from the tree


```solidity
function getFirstUnprocessedPriorityTx(Tree storage _tree)
  internal
  view
  returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Index of the oldest priority operation that wasn't processed yet|


### getTotalPriorityTxs


```solidity
function getTotalPriorityTxs(Tree storage _tree)
  internal
  view
  returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of priority operations that were added to the priority queue, including all processed ones|


### getSize


```solidity
function getSize(Tree storage _tree) internal view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of unprocessed priority operations in a priority queue|


### push

Add the priority operation to the end of the priority queue


```solidity
function push(Tree storage _tree, bytes32 _hash) internal;
```

### setup

Set up the tree


```solidity
function setup(Tree storage _tree, uint256 _startIndex) internal;
```

### getRoot


```solidity
function getRoot(Tree storage _tree) internal view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|Returns the tree root.|


### isHistoricalRoot


```solidity
function isHistoricalRoot(Tree storage _tree, bytes32 _root)
  internal
  view
  returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_tree`|`Tree`||
|`_root`|`bytes32`|The root to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Returns true if the root is a historical root.|


### processBatch

Process the priority operations of a batch.

*Note, that the function below only checks that a certain segment of items is present in the tree.
It does not check that e.g. there are no zero items inside the provided `itemHashes`, so in theory proofs
that include non-existing priority operations could be created. This function relies on the fact
that the `itemHashes` of `_priorityOpsData` are hashes of valid priority transactions.
This fact is ensures by the fact the rolling hash of those is sent to the Executor by the bootloader
and so assuming that zero knowledge proofs are correct, so is the structure of the `itemHashes`.*


```solidity
function processBatch(
  Tree storage _tree,
  PriorityOpsBatchInfo memory _priorityOpsData
) internal;
```

### skipUntil

Allows to skip a certain number of operations.

*It is used when the corresponding transactions have been processed by priority queue.*


```solidity
function skipUntil(Tree storage _tree, uint256 _lastUnprocessed) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_tree`|`Tree`||
|`_lastUnprocessed`|`uint256`|The new expected id of the unprocessed transaction.|


### initFromCommitment

Initialize a chain from a commitment.


```solidity
function initFromCommitment(
  Tree storage _tree,
  PriorityTreeCommitment memory _commitment
) internal;
```

### l1Reinit

Reinitialize the tree from a commitment on L1.


```solidity
function l1Reinit(Tree storage _tree, PriorityTreeCommitment memory _commitment)
  internal;
```

### checkGWReinit

Reinitialize the tree from a commitment on GW.


```solidity
function checkGWReinit(
  Tree storage _tree,
  PriorityTreeCommitment memory _commitment
) internal view;
```

### getCommitment

Returns the commitment to the priority tree.


```solidity
function getCommitment(Tree storage _tree)
  internal
  view
  returns (PriorityTreeCommitment memory commitment);
```

## Structs
### Tree

```solidity
struct Tree {
  uint256 startIndex;
  uint256 unprocessedIndex;
  mapping(bytes32 => bool) historicalRoots;
  DynamicIncrementalMerkle.Bytes32PushTree tree;
}
```

