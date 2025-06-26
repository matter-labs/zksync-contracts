# PriorityQueue
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/libraries/PriorityQueue.sol)

**Author:**
Matter Labs

*The library provides the API to interact with the priority queue container*

*Order of processing operations from queue - FIFO (Fist in - first out)*

**Note:**
security-contact: security@matterlabs.dev


## Functions
### getFirstUnprocessedPriorityTx

Returns zero if and only if no operations were processed from the queue


```solidity
function getFirstUnprocessedPriorityTx(Queue storage _queue)
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
function getTotalPriorityTxs(Queue storage _queue)
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
function getSize(Queue storage _queue) internal view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total number of unprocessed priority operations in a priority queue|


### isEmpty


```solidity
function isEmpty(Queue storage _queue) internal view returns (bool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the priority queue contains no operations|


### pushBack

Add the priority operation to the end of the priority queue


```solidity
function pushBack(Queue storage _queue, PriorityOperation memory _operation)
  internal;
```

### front


```solidity
function front(Queue storage _queue)
  internal
  view
  returns (PriorityOperation memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`PriorityOperation`|The first unprocessed priority operation from the queue|


### popFront

Remove the first unprocessed priority operation from the queue


```solidity
function popFront(Queue storage _queue)
  internal
  returns (PriorityOperation memory priorityOperation);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`priorityOperation`|`PriorityOperation`|that was popped from the priority queue|


## Structs
### Queue
Container that stores priority operations


```solidity
struct Queue {
  mapping(uint256 priorityOpId => PriorityOperation priorityOp) data;
  uint256 tail;
  uint256 head;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`data`|`mapping(uint256 priorityOpId => PriorityOperation priorityOp)`|The inner mapping that saves priority operation by its index|
|`tail`|`uint256`|The pointer to the free slot|
|`head`|`uint256`|The pointer to the first unprocessed priority operation, equal to the tail if the queue is empty|

