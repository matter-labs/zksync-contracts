# IL2StandardToken
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IL2StandardToken.sol)


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

### l2Bridge


```solidity
function l2Bridge() external view returns (address);
```

## Events
### BridgeMint

```solidity
event BridgeMint(address indexed _account, uint256 _amount);
```

### BridgeBurn

```solidity
event BridgeBurn(address indexed _account, uint256 _amount);
```

