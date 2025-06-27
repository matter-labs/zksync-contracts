# IL1Nullifier
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/interfaces/IL1Nullifier.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### isWithdrawalFinalized


```solidity
function isWithdrawalFinalized(
  uint256 _chainId,
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex
) external view returns (bool);
```

### claimFailedDepositLegacyErc20Bridge


```solidity
function claimFailedDepositLegacyErc20Bridge(
  address _depositSender,
  address _l1Token,
  uint256 _amount,
  bytes32 _l2TxHash,
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBatch,
  bytes32[] calldata _merkleProof
) external;
```

### claimFailedDeposit


```solidity
function claimFailedDeposit(
  uint256 _chainId,
  address _depositSender,
  address _l1Token,
  uint256 _amount,
  bytes32 _l2TxHash,
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBatch,
  bytes32[] calldata _merkleProof
) external;
```

### finalizeDeposit


```solidity
function finalizeDeposit(
  FinalizeL1DepositParams calldata _finalizeWithdrawalParams
) external;
```

### BRIDGE_HUB


```solidity
function BRIDGE_HUB() external view returns (IBridgehub);
```

### legacyBridge


```solidity
function legacyBridge() external view returns (IL1ERC20Bridge);
```

### depositHappened


```solidity
function depositHappened(uint256 _chainId, bytes32 _l2TxHash)
  external
  view
  returns (bytes32);
```

### bridgehubConfirmL2TransactionForwarded


```solidity
function bridgehubConfirmL2TransactionForwarded(
  uint256 _chainId,
  bytes32 _txDataHash,
  bytes32 _txHash
) external;
```

### l1NativeTokenVault


```solidity
function l1NativeTokenVault() external view returns (IL1NativeTokenVault);
```

### setL1NativeTokenVault


```solidity
function setL1NativeTokenVault(IL1NativeTokenVault _nativeTokenVault) external;
```

### setL1AssetRouter


```solidity
function setL1AssetRouter(address _l1AssetRouter) external;
```

### chainBalance


```solidity
function chainBalance(uint256 _chainId, address _token)
  external
  view
  returns (uint256);
```

### l2BridgeAddress


```solidity
function l2BridgeAddress(uint256 _chainId) external view returns (address);
```

### transferTokenToNTV


```solidity
function transferTokenToNTV(address _token) external;
```

### nullifyChainBalanceByNTV


```solidity
function nullifyChainBalanceByNTV(uint256 _chainId, address _token) external;
```

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


### finalizeWithdrawal

Legacy function to finalize withdrawal via the same
interface as the old L1SharedBridge.

*Note, that we need to keep this interface, since the `L2AssetRouter`
will continue returning the previous address as the `l1SharedBridge`. The value
returned by it is used in the SDK for finalizing withdrawals.*


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


## Events
### BridgehubDepositFinalized

```solidity
event BridgehubDepositFinalized(
  uint256 indexed chainId,
  bytes32 indexed txDataHash,
  bytes32 indexed l2DepositTxHash
);
```

