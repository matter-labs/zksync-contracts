# IL2SharedBridgeLegacy
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IL2SharedBridgeLegacy.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### l2TokenBeacon


```solidity
function l2TokenBeacon() external view returns (UpgradeableBeacon);
```

### withdraw


```solidity
function withdraw(address _l1Receiver, address _l2Token, uint256 _amount)
  external;
```

### l1TokenAddress


```solidity
function l1TokenAddress(address _l2Token) external view returns (address);
```

### l2TokenAddress


```solidity
function l2TokenAddress(address _l1Token) external view returns (address);
```

### l1Bridge


```solidity
function l1Bridge() external view returns (address);
```

### l1SharedBridge


```solidity
function l1SharedBridge() external view returns (address);
```

### deployBeaconProxy


```solidity
function deployBeaconProxy(bytes32 _salt) external returns (address);
```

### sendMessageToL1


```solidity
function sendMessageToL1(bytes calldata _message) external;
```

## Events
### FinalizeDeposit

```solidity
event FinalizeDeposit(
  address indexed l1Sender,
  address indexed l2Receiver,
  address indexed l2Token,
  uint256 amount
);
```

