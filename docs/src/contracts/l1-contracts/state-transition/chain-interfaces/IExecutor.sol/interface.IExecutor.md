# IExecutor
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IExecutor.sol)

**Inherits:**
[IZKChainBase](/contracts/l1-contracts/state-transition/chain-interfaces/IZKChainBase.sol/interface.IZKChainBase.md)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### commitBatchesSharedBridge

Function called by the operator to commit new batches. It is responsible for:
- Verifying the correctness of their timestamps.
- Processing their L2->L1 logs.
- Storing batch commitments.


```solidity
function commitBatchesSharedBridge(
  uint256 _chainId,
  uint256 _processFrom,
  uint256 _processTo,
  bytes calldata _commitData
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|Chain ID of the chain.|
|`_processFrom`|`uint256`|The batch number from which the processing starts.|
|`_processTo`|`uint256`|The batch number at which the processing ends.|
|`_commitData`|`bytes`|The encoded data of the new batches to be committed.|


### proveBatchesSharedBridge

Batches commitment verification.

*Only verifies batch commitments without any other processing.*


```solidity
function proveBatchesSharedBridge(
  uint256 _chainId,
  uint256 _processBatchFrom,
  uint256 _processBatchTo,
  bytes calldata _proofData
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|Chain ID of the chain.|
|`_processBatchFrom`|`uint256`|The batch number from which the verification starts.|
|`_processBatchTo`|`uint256`|The batch number at which the verification ends.|
|`_proofData`|`bytes`|The encoded data of the new batches to be verified.|


### executeBatchesSharedBridge

The function called by the operator to finalize (execute) batches. It is responsible for:
- Processing all pending operations (commpleting priority requests).
- Finalizing this batch (i.e. allowing to withdraw funds from the system)


```solidity
function executeBatchesSharedBridge(
  uint256 _chainId,
  uint256 _processFrom,
  uint256 _processTo,
  bytes calldata _executeData
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|Chain ID of the chain.|
|`_processFrom`|`uint256`|The batch number from which the execution starts.|
|`_processTo`|`uint256`|The batch number at which the execution ends.|
|`_executeData`|`bytes`|The encoded data of the new batches to be executed.|


### revertBatchesSharedBridge

Reverts unexecuted batches


```solidity
function revertBatchesSharedBridge(uint256 _chainId, uint256 _newLastBatch)
  external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|Chain ID of the chain|
|`_newLastBatch`|`uint256`|batch number after which batches should be reverted NOTE: Doesn't delete the stored data about batches, but only decreases counters that are responsible for the number of batches|


## Events
### BlockCommit
Event emitted when a batch is committed

*It has the name "BlockCommit" and not "BatchCommit" due to backward compatibility considerations*


```solidity
event BlockCommit(
  uint256 indexed batchNumber,
  bytes32 indexed batchHash,
  bytes32 indexed commitment
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`batchNumber`|`uint256`|Number of the batch committed|
|`batchHash`|`bytes32`|Hash of the L2 batch|
|`commitment`|`bytes32`|Calculated input for the ZKsync circuit|

### BlocksVerification
Event emitted when batches are verified

*It has the name "BlocksVerification" and not "BatchesVerification" due to backward compatibility considerations*


```solidity
event BlocksVerification(
  uint256 indexed previousLastVerifiedBatch,
  uint256 indexed currentLastVerifiedBatch
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`previousLastVerifiedBatch`|`uint256`|Batch number of the previous last verified batch|
|`currentLastVerifiedBatch`|`uint256`|Batch number of the current last verified batch|

### BlockExecution
Event emitted when a batch is executed

*It has the name "BlockExecution" and not "BatchExecution" due to backward compatibility considerations*


```solidity
event BlockExecution(
  uint256 indexed batchNumber,
  bytes32 indexed batchHash,
  bytes32 indexed commitment
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`batchNumber`|`uint256`|Number of the batch executed|
|`batchHash`|`bytes32`|Hash of the L2 batch|
|`commitment`|`bytes32`|Verified input for the ZKsync circuit|

### BlocksRevert
Event emitted when batches are reverted

*It has the name "BlocksRevert" and not "BatchesRevert" due to backward compatibility considerations*


```solidity
event BlocksRevert(
  uint256 totalBatchesCommitted,
  uint256 totalBatchesVerified,
  uint256 totalBatchesExecuted
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`totalBatchesCommitted`|`uint256`|Total number of committed batches after the revert|
|`totalBatchesVerified`|`uint256`|Total number of verified batches after the revert|
|`totalBatchesExecuted`|`uint256`|Total number of executed batches|

## Structs
### StoredBatchInfo
Rollup batch stored data


```solidity
struct StoredBatchInfo {
  uint64 batchNumber;
  bytes32 batchHash;
  uint64 indexRepeatedStorageChanges;
  uint256 numberOfLayer1Txs;
  bytes32 priorityOperationsHash;
  bytes32 l2LogsTreeRoot;
  uint256 timestamp;
  bytes32 commitment;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`batchNumber`|`uint64`|Rollup batch number|
|`batchHash`|`bytes32`|Hash of L2 batch|
|`indexRepeatedStorageChanges`|`uint64`|The serial number of the shortcut index that's used as a unique identifier for storage keys that were used twice or more|
|`numberOfLayer1Txs`|`uint256`|Number of priority operations to be processed|
|`priorityOperationsHash`|`bytes32`|Hash of all priority operations from this batch|
|`l2LogsTreeRoot`|`bytes32`|Root hash of tree that contains L2 -> L1 messages from this batch|
|`timestamp`|`uint256`|Rollup batch timestamp, have the same format as Ethereum batch constant|
|`commitment`|`bytes32`|Verified input for the ZKsync circuit|

### CommitBatchInfo
Data needed to commit new batch

*pubdataCommitments format: This will always start with a 1 byte pubdataSource flag. Current allowed values are 0 (calldata) or 1 (blobs)
kzg: list of: opening point (16 bytes) || claimed value (32 bytes) || commitment (48 bytes) || proof (48 bytes) = 144 bytes
calldata: pubdataCommitments.length - 1 - 32 bytes of pubdata
and 32 bytes appended to serve as the blob commitment part for the aux output part of the batch commitment*

*For 2 blobs we will be sending 288 bytes of calldata instead of the full amount for pubdata.*

*When using calldata, we only need to send one blob commitment since the max number of bytes in calldata fits in a single blob and we can pull the
linear hash from the system logs*


```solidity
struct CommitBatchInfo {
  uint64 batchNumber;
  uint64 timestamp;
  uint64 indexRepeatedStorageChanges;
  bytes32 newStateRoot;
  uint256 numberOfLayer1Txs;
  bytes32 priorityOperationsHash;
  bytes32 bootloaderHeapInitialContentsHash;
  bytes32 eventsQueueStateHash;
  bytes systemLogs;
  bytes operatorDAInput;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`batchNumber`|`uint64`|Number of the committed batch|
|`timestamp`|`uint64`|Unix timestamp denoting the start of the batch execution|
|`indexRepeatedStorageChanges`|`uint64`|The serial number of the shortcut index that's used as a unique identifier for storage keys that were used twice or more|
|`newStateRoot`|`bytes32`|The state root of the full state tree|
|`numberOfLayer1Txs`|`uint256`|Number of priority operations to be processed|
|`priorityOperationsHash`|`bytes32`|Hash of all priority operations from this batch|
|`bootloaderHeapInitialContentsHash`|`bytes32`|Hash of the initial contents of the bootloader heap. In practice it serves as the commitment to the transactions in the batch.|
|`eventsQueueStateHash`|`bytes32`|Hash of the events queue state. In practice it serves as the commitment to the events in the batch.|
|`systemLogs`|`bytes`|concatenation of all L2 -> L1 system logs in the batch|
|`operatorDAInput`|`bytes`|Packed pubdata commitments/data.|

