# IBridgedStandardToken
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/IBridgedStandardToken.sol)


## Functions
### bridgeMint


```solidity
function bridgeMint(address _account, uint256 _amount) external;
```

### bridgeBurn


```solidity
function bridgeBurn(address _account, uint256 _amount) external;
```

### l1Address


```solidity
function l1Address() external view returns (address);
```

### originToken


```solidity
function originToken() external view returns (address);
```

### l2Bridge


```solidity
function l2Bridge() external view returns (address);
```

### assetId


```solidity
function assetId() external view returns (bytes32);
```

### nativeTokenVault


```solidity
function nativeTokenVault() external view returns (address);
```

## Events
### BridgeInitialize

```solidity
event BridgeInitialize(
  address indexed l1Token, string name, string symbol, uint8 decimals
);
```

### BridgeMint

```solidity
event BridgeMint(address indexed account, uint256 amount);
```

### BridgeBurn

```solidity
event BridgeBurn(address indexed account, uint256 amount);
```

