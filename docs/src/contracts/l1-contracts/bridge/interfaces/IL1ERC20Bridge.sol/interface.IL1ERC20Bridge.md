# IL1ERC20Bridge
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/IL1ERC20Bridge.sol)

**Author:**
Matter Labs

Legacy Bridge interface before ZK chain migration, used for backward compatibility with ZKsync Era

**Note:**
security-contact: security@matterlabs.dev


## Functions
### isWithdrawalFinalized


```solidity
function isWithdrawalFinalized(uint256 _l2BatchNumber, uint256 _l2MessageIndex)
  external
  view
  returns (bool);
```

### deposit


```solidity
function deposit(
  address _l2Receiver,
  address _l1Token,
  uint256 _amount,
  uint256 _l2TxGasLimit,
  uint256 _l2TxGasPerPubdataByte,
  address _refundRecipient
) external payable returns (bytes32 txHash);
```

### deposit


```solidity
function deposit(
  address _l2Receiver,
  address _l1Token,
  uint256 _amount,
  uint256 _l2TxGasLimit,
  uint256 _l2TxGasPerPubdataByte
) external payable returns (bytes32 txHash);
```

### claimFailedDeposit


```solidity
function claimFailedDeposit(
  address _depositSender,
  address _l1Token,
  bytes32 _l2TxHash,
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBatch,
  bytes32[] calldata _merkleProof
) external;
```

### finalizeWithdrawal


```solidity
function finalizeWithdrawal(
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBatch,
  bytes calldata _message,
  bytes32[] calldata _merkleProof
) external;
```

### l2TokenAddress


```solidity
function l2TokenAddress(address _l1Token) external view returns (address);
```

### L1_NULLIFIER


```solidity
function L1_NULLIFIER() external view returns (IL1Nullifier);
```

### L1_ASSET_ROUTER


```solidity
function L1_ASSET_ROUTER() external view returns (IL1AssetRouter);
```

### L1_NATIVE_TOKEN_VAULT


```solidity
function L1_NATIVE_TOKEN_VAULT() external view returns (IL1NativeTokenVault);
```

### l2TokenBeacon


```solidity
function l2TokenBeacon() external view returns (address);
```

### l2Bridge


```solidity
function l2Bridge() external view returns (address);
```

### depositAmount


```solidity
function depositAmount(
  address _account,
  address _l1Token,
  bytes32 _depositL2TxHash
) external view returns (uint256 amount);
```

## Events
### DepositInitiated

```solidity
event DepositInitiated(
  bytes32 indexed l2DepositTxHash,
  address indexed from,
  address indexed to,
  address l1Token,
  uint256 amount
);
```

### WithdrawalFinalized

```solidity
event WithdrawalFinalized(
  address indexed to, address indexed l1Token, uint256 amount
);
```

### ClaimedFailedDeposit

```solidity
event ClaimedFailedDeposit(
  address indexed to, address indexed l1Token, uint256 amount
);
```

