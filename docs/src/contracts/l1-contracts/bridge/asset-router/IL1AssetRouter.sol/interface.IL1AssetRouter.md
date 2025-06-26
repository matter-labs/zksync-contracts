# IL1AssetRouter
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/asset-router/IL1AssetRouter.sol)

**Inherits:**
[IAssetRouterBase](/contracts/l1-contracts/bridge/asset-router/IAssetRouterBase.sol/interface.IAssetRouterBase.md), [IL1SharedBridgeLegacy](/contracts/l1-contracts/bridge/interfaces/IL1SharedBridgeLegacy.sol/interface.IL1SharedBridgeLegacy.md)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### depositLegacyErc20Bridge

Initiates a deposit by locking funds on the contract and sending the request
of processing an L2 transaction where tokens would be minted.

*If the token is bridged for the first time, the L2 token contract will be deployed. Note however, that the
newly-deployed token does not support any custom logic, i.e. rebase tokens' functionality is not supported.*

*If the L2 deposit finalization transaction fails, the `_refundRecipient` will receive the `_l2Value`.
Please note, the contract may change the refund recipient's address to eliminate sending funds to addresses
out of control.
- If `_refundRecipient` is a contract on L1, the refund will be sent to the aliased `_refundRecipient`.
- If `_refundRecipient` is set to `address(0)` and the sender has NO deployed bytecode on L1, the refund will
be sent to the `msg.sender` address.
- If `_refundRecipient` is set to `address(0)` and the sender has deployed bytecode on L1, the refund will be
sent to the aliased `msg.sender` address.*

*The address aliasing of L1 contracts as refund recipient on L2 is necessary to guarantee that the funds
are controllable through the Mailbox, since the Mailbox applies address aliasing to the from address for the
L2 tx if the L1 msg.sender is a contract. Without address aliasing for L1 contracts as refund recipients they
would not be able to make proper L2 tx requests through the Mailbox to use or withdraw the funds from L2, and
the funds would be lost.*


```solidity
function depositLegacyErc20Bridge(
  address _originalCaller,
  address _l2Receiver,
  address _l1Token,
  uint256 _amount,
  uint256 _l2TxGasLimit,
  uint256 _l2TxGasPerPubdataByte,
  address _refundRecipient
) external payable returns (bytes32 txHash);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_originalCaller`|`address`|The `msg.sender` address from the external call that initiated current one.|
|`_l2Receiver`|`address`|The account address that should receive funds on L2.|
|`_l1Token`|`address`|The L1 token address which is deposited.|
|`_amount`|`uint256`|The total amount of tokens to be bridged.|
|`_l2TxGasLimit`|`uint256`|The L2 gas limit to be used in the corresponding L2 transaction.|
|`_l2TxGasPerPubdataByte`|`uint256`|The gasPerPubdataByteLimit to be used in the corresponding L2 transaction.|
|`_refundRecipient`|`address`|The address on L2 that will receive the refund for the transaction.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`txHash`|`bytes32`|The L2 transaction hash of deposit finalization.|


### L1_NULLIFIER


```solidity
function L1_NULLIFIER() external view returns (IL1Nullifier);
```

### L1_WETH_TOKEN


```solidity
function L1_WETH_TOKEN() external view returns (address);
```

### nativeTokenVault


```solidity
function nativeTokenVault() external view returns (INativeTokenVault);
```

### setAssetDeploymentTracker


```solidity
function setAssetDeploymentTracker(
  bytes32 _assetRegistrationData,
  address _assetDeploymentTracker
) external;
```

### setNativeTokenVault


```solidity
function setNativeTokenVault(INativeTokenVault _nativeTokenVault) external;
```

### bridgeRecoverFailedTransfer

Withdraw funds from the initiated deposit, that failed when finalizing on L2.

*Processes claims of failed deposit, whether they originated from the legacy bridge or the current system.*


```solidity
function bridgeRecoverFailedTransfer(
  uint256 _chainId,
  address _depositSender,
  bytes32 _assetId,
  bytes calldata _assetData
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|The ZK chain id to which the deposit was initiated.|
|`_depositSender`|`address`|The address of the entity that initiated the deposit.|
|`_assetId`|`bytes32`|The unique identifier of the deposited L1 token.|
|`_assetData`|`bytes`|The encoded transfer data, which includes both the deposit amount and the address of the L2 receiver. Might include extra information.|


### bridgeRecoverFailedTransfer

*Withdraw funds from the initiated deposit, that failed when finalizing on L2.*

*Processes claims of failed deposit, whether they originated from the legacy bridge or the current system.*


```solidity
function bridgeRecoverFailedTransfer(
  uint256 _chainId,
  address _depositSender,
  bytes32 _assetId,
  bytes memory _assetData,
  bytes32 _l2TxHash,
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBatch,
  bytes32[] calldata _merkleProof
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|The ZK chain id to which deposit was initiated.|
|`_depositSender`|`address`|The address of the entity that initiated the deposit.|
|`_assetId`|`bytes32`|The unique identifier of the deposited L1 token.|
|`_assetData`|`bytes`|The encoded transfer data, which includes both the deposit amount and the address of the L2 receiver. Might include extra information.|
|`_l2TxHash`|`bytes32`|The L2 transaction hash of the failed deposit finalization.|
|`_l2BatchNumber`|`uint256`|The L2 batch number where the deposit finalization was processed.|
|`_l2MessageIndex`|`uint256`|The position in the L2 logs Merkle tree of the l2Log that was sent with the message.|
|`_l2TxNumberInBatch`|`uint16`|The L2 transaction number in a batch, in which the log was sent.|
|`_merkleProof`|`bytes32[]`|The Merkle proof of the processing L1 -> L2 transaction with deposit finalization.|


### transferFundsToNTV

Transfers funds to Native Token Vault, if the asset is registered with it. Does nothing for ETH or non-registered tokens.

*assetId is not the padded address, but the correct encoded id (NTV stores respective format for IDs)*


```solidity
function transferFundsToNTV(
  bytes32 _assetId,
  uint256 _amount,
  address _originalCaller
) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_assetId`|`bytes32`||
|`_amount`|`uint256`|The asset amount to be transferred to native token vault.|
|`_originalCaller`|`address`|The `msg.sender` address from the external call that initiated current one.|


### finalizeWithdrawal

Finalize the withdrawal and release funds


```solidity
function finalizeWithdrawal(
  uint256 _chainId,
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
|`_chainId`|`uint256`|The chain ID of the transaction to check|
|`_l2BatchNumber`|`uint256`|The L2 batch number where the withdrawal was processed|
|`_l2MessageIndex`|`uint256`|The position in the L2 logs Merkle tree of the l2Log that was sent with the message|
|`_l2TxNumberInBatch`|`uint16`|The L2 transaction number in the batch, in which the log was sent|
|`_message`|`bytes`|The L2 withdraw data, stored in an L2 -> L1 message|
|`_merkleProof`|`bytes32[]`|The Merkle proof of the inclusion L2 -> L1 message about withdrawal initialization|


### bridgehubDeposit

Initiates a transfer transaction within Bridgehub, used by `requestL2TransactionTwoBridges`.

*Data has the following abi encoding for legacy deposits:
address _l1Token,
uint256 _amount,
address _l2Receiver
for new deposits:
bytes32 _assetId,
bytes _transferData*


```solidity
function bridgehubDeposit(
  uint256 _chainId,
  address _originalCaller,
  uint256 _value,
  bytes calldata _data
) external payable returns (L2TransactionRequestTwoBridgesInner memory request);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|The chain ID of the ZK chain to which deposit.|
|`_originalCaller`|`address`|The `msg.sender` address from the external call that initiated current one.|
|`_value`|`uint256`|The `msg.value` on the target chain tx.|
|`_data`|`bytes`|The calldata for the second bridge deposit.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`request`|`L2TransactionRequestTwoBridgesInner`|The data used by the bridgehub to create L2 transaction request to specific ZK chain.|


### getDepositCalldata

Generates a calldata for calling the deposit finalization on the L2 native token contract.


```solidity
function getDepositCalldata(
  address _sender,
  bytes32 _assetId,
  bytes memory _assetData
) external view returns (bytes memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_sender`|`address`|The address of the deposit initiator.|
|`_assetId`|`bytes32`|The deposited asset ID.|
|`_assetData`|`bytes`|The encoded data, which is used by the asset handler to determine L2 recipient and amount. Might include extra information.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes`|Returns calldata used on ZK chain.|


### bridgehubDepositBaseToken

Allows bridgehub to acquire mintValue for L1->L2 transactions.

*If the corresponding L2 transaction fails, refunds are issued to a refund recipient on L2.*


```solidity
function bridgehubDepositBaseToken(
  uint256 _chainId,
  bytes32 _assetId,
  address _originalCaller,
  uint256 _amount
) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|The chain ID of the ZK chain to which deposit.|
|`_assetId`|`bytes32`|The deposited asset ID.|
|`_originalCaller`|`address`|The `msg.sender` address from the external call that initiated current one.|
|`_amount`|`uint256`|The total amount of tokens to be bridged.|


### bridgehubConfirmL2Transaction

Routes the confirmation to nullifier for backward compatibility.

Confirms the acceptance of a transaction by the Mailbox, as part of the L2 transaction process within Bridgehub.
This function is utilized by `requestL2TransactionTwoBridges` to validate the execution of a transaction.


```solidity
function bridgehubConfirmL2Transaction(
  uint256 _chainId,
  bytes32 _txDataHash,
  bytes32 _txHash
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|The chain ID of the ZK chain to which confirm the deposit.|
|`_txDataHash`|`bytes32`|The keccak256 hash of 0x01 || abi.encode(bytes32, bytes) to identify deposits.|
|`_txHash`|`bytes32`|The hash of the L1->L2 transaction to confirm the deposit.|


### isWithdrawalFinalized


```solidity
function isWithdrawalFinalized(
  uint256 _chainId,
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex
) external view returns (bool);
```

## Events
### BridgehubMintData

```solidity
event BridgehubMintData(bytes bridgeMintData);
```

### BridgehubDepositFinalized

```solidity
event BridgehubDepositFinalized(
  uint256 indexed chainId,
  bytes32 indexed txDataHash,
  bytes32 indexed l2DepositTxHash
);
```

### ClaimedFailedDepositAssetRouter

```solidity
event ClaimedFailedDepositAssetRouter(
  uint256 indexed chainId, bytes32 indexed assetId, bytes assetData
);
```

### AssetDeploymentTrackerSet

```solidity
event AssetDeploymentTrackerSet(
  bytes32 indexed assetId,
  address indexed assetDeploymentTracker,
  bytes32 indexed additionalData
);
```

### LegacyDepositInitiated

```solidity
event LegacyDepositInitiated(
  uint256 indexed chainId,
  bytes32 indexed l2DepositTxHash,
  address indexed from,
  address to,
  address l1Token,
  uint256 amount
);
```

