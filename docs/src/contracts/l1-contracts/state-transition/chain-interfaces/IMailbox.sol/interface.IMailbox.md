# IMailbox
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-interfaces/IMailbox.sol)

**Inherits:**
[IZKChainBase](/contracts/l1-contracts/state-transition/chain-interfaces/IZKChainBase.sol/interface.IZKChainBase.md)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### proveL2MessageInclusion

Prove that a specific arbitrary-length message was sent in a specific L2 batch number


```solidity
function proveL2MessageInclusion(
  uint256 _batchNumber,
  uint256 _index,
  L2Message calldata _message,
  bytes32[] calldata _proof
) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_batchNumber`|`uint256`|The executed L2 batch number in which the message appeared|
|`_index`|`uint256`|The position in the L2 logs Merkle tree of the l2Log that was sent with the message|
|`_message`|`L2Message`|Information about the sent message: sender address, the message itself, tx index in the L2 batch where the message was sent|
|`_proof`|`bytes32[]`|Merkle proof for inclusion of L2 log that was sent with the message|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the proof is valid|


### proveL2LogInclusion

Prove that a specific L2 log was sent in a specific L2 batch


```solidity
function proveL2LogInclusion(
  uint256 _batchNumber,
  uint256 _index,
  L2Log memory _log,
  bytes32[] calldata _proof
) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_batchNumber`|`uint256`|The executed L2 batch number in which the log appeared|
|`_index`|`uint256`|The position of the l2log in the L2 logs Merkle tree|
|`_log`|`L2Log`|Information about the sent log|
|`_proof`|`bytes32[]`|Merkle proof for inclusion of the L2 log|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the proof is correct and L2 log is included in batch|


### proveL1ToL2TransactionStatus

Prove that the L1 -> L2 transaction was processed with the specified status.


```solidity
function proveL1ToL2TransactionStatus(
  bytes32 _l2TxHash,
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBatch,
  bytes32[] calldata _merkleProof,
  TxStatus _status
) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_l2TxHash`|`bytes32`|The L2 canonical transaction hash|
|`_l2BatchNumber`|`uint256`|The L2 batch number where the transaction was processed|
|`_l2MessageIndex`|`uint256`|The position in the L2 logs Merkle tree of the l2Log that was sent with the message|
|`_l2TxNumberInBatch`|`uint16`|The L2 transaction number in the batch, in which the log was sent|
|`_merkleProof`|`bytes32[]`|The Merkle proof of the processing L1 -> L2 transaction|
|`_status`|`TxStatus`|The execution status of the L1 -> L2 transaction (true - success & 0 - fail)|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the proof is correct and the transaction was actually executed with provided status NOTE: It may return `false` for incorrect proof, but it doesn't mean that the L1 -> L2 transaction has an opposite status!|


### finalizeEthWithdrawal

Finalize the withdrawal and release funds


```solidity
function finalizeEthWithdrawal(
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBatch,
  bytes calldata _message,
  bytes32[] calldata _merkleProof
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_l2BatchNumber`|`uint256`|The L2 batch number where the withdrawal was processed|
|`_l2MessageIndex`|`uint256`|The position in the L2 logs Merkle tree of the l2Log that was sent with the message|
|`_l2TxNumberInBatch`|`uint16`|The L2 transaction number in a batch, in which the log was sent|
|`_message`|`bytes`|The L2 withdraw data, stored in an L2 -> L1 message|
|`_merkleProof`|`bytes32[]`|The Merkle proof of the inclusion L2 -> L1 message about withdrawal initialization|


### requestL2Transaction

Request execution of L2 transaction from L1.

*If the L2 deposit finalization transaction fails, the `_refundRecipient` will receive the `_l2Value`.
Please note, the contract may change the refund recipient's address to eliminate sending funds to addresses out of control.
- If `_refundRecipient` is a contract on L1, the refund will be sent to the aliased `_refundRecipient`.
- If `_refundRecipient` is set to `address(0)` and the sender has NO deployed bytecode on L1, the refund will be sent to the `msg.sender` address.
- If `_refundRecipient` is set to `address(0)` and the sender has deployed bytecode on L1, the refund will be sent to the aliased `msg.sender` address.*

*The address aliasing of L1 contracts as refund recipient on L2 is necessary to guarantee that the funds are controllable,
since address aliasing to the from address for the L2 tx will be applied if the L1 `msg.sender` is a contract.
Without address aliasing for L1 contracts as refund recipients they would not be able to make proper L2 tx requests
through the Mailbox to use or withdraw the funds from L2, and the funds would be lost.*


```solidity
function requestL2Transaction(
  address _contractL2,
  uint256 _l2Value,
  bytes calldata _calldata,
  uint256 _l2GasLimit,
  uint256 _l2GasPerPubdataByteLimit,
  bytes[] calldata _factoryDeps,
  address _refundRecipient
) external payable returns (bytes32 canonicalTxHash);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_contractL2`|`address`|The L2 receiver address|
|`_l2Value`|`uint256`|`msg.value` of L2 transaction|
|`_calldata`|`bytes`|The input of the L2 transaction|
|`_l2GasLimit`|`uint256`|Maximum amount of L2 gas that transaction can consume during execution on L2|
|`_l2GasPerPubdataByteLimit`|`uint256`|The maximum amount L2 gas that the operator may charge the user for single byte of pubdata.|
|`_factoryDeps`|`bytes[]`|An array of L2 bytecodes that will be marked as known on L2|
|`_refundRecipient`|`address`|The address on L2 that will receive the refund for the transaction.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`canonicalTxHash`|`bytes32`|The hash of the requested L2 transaction. This hash can be used to follow the transaction status|


### bridgehubRequestL2Transaction

when requesting transactions through the bridgehub


```solidity
function bridgehubRequestL2Transaction(
  BridgehubL2TransactionRequest calldata _request
) external returns (bytes32 canonicalTxHash);
```

### bridgehubRequestL2TransactionOnGateway

*On the Gateway the chain's mailbox receives the tx from the bridgehub.*


```solidity
function bridgehubRequestL2TransactionOnGateway(
  bytes32 _canonicalTxHash,
  uint64 _expirationTimestamp
) external;
```

### requestL2TransactionToGatewayMailbox

*On L1 we have to forward to the Gateway's mailbox which sends to the Bridgehub on the Gw*


```solidity
function requestL2TransactionToGatewayMailbox(
  uint256 _chainId,
  bytes32 _canonicalTxHash,
  uint64 _expirationTimestamp
) external returns (bytes32 canonicalTxHash);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|the chainId of the chain|
|`_canonicalTxHash`|`bytes32`|the canonical transaction hash|
|`_expirationTimestamp`|`uint64`|the expiration timestamp|


### l2TransactionBaseCost

Estimates the cost in Ether of requesting execution of an L2 transaction from L1


```solidity
function l2TransactionBaseCost(
  uint256 _gasPrice,
  uint256 _l2GasLimit,
  uint256 _l2GasPerPubdataByteLimit
) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_gasPrice`|`uint256`|expected L1 gas price at which the user requests the transaction execution|
|`_l2GasLimit`|`uint256`|Maximum amount of L2 gas that transaction can consume during execution on L2|
|`_l2GasPerPubdataByteLimit`|`uint256`|The maximum amount of L2 gas that the operator may charge the user for a single byte of pubdata.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The estimated ETH spent on L2 gas for the transaction|


### proveL2LeafInclusion

Proves that a certain leaf was included as part of the log merkle tree.


```solidity
function proveL2LeafInclusion(
  uint256 _batchNumber,
  uint256 _batchRootMask,
  bytes32 _leaf,
  bytes32[] calldata _proof
) external view returns (bool);
```

## Events
### NewPriorityRequest
transfer Eth to shared bridge as part of migration process

New priority request event. Emitted when a request is placed into the priority queue


```solidity
event NewPriorityRequest(
  uint256 txId,
  bytes32 txHash,
  uint64 expirationTimestamp,
  L2CanonicalTransaction transaction,
  bytes[] factoryDeps
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`txId`|`uint256`|Serial number of the priority operation|
|`txHash`|`bytes32`|keccak256 hash of encoded transaction representation|
|`expirationTimestamp`|`uint64`|Timestamp up to which priority request should be processed|
|`transaction`|`L2CanonicalTransaction`|The whole transaction structure that is requested to be executed on L2|
|`factoryDeps`|`bytes[]`|An array of bytecodes that were shown in the L1 public data. Will be marked as known bytecodes in L2|

### NewRelayedPriorityTransaction
New relayed priority request event. It is emitted on a chain that is deployed
on top of the gateway when it receives a request relayed via the Bridgehub.

*IMPORTANT: this event most likely will be removed in the future, so
no one should rely on it for indexing purposes.*


```solidity
event NewRelayedPriorityTransaction(
  uint256 txId, bytes32 txHash, uint64 expirationTimestamp
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`txId`|`uint256`|Serial number of the priority operation|
|`txHash`|`bytes32`|keccak256 hash of encoded transaction representation|
|`expirationTimestamp`|`uint64`|Timestamp up to which priority request should be processed|

