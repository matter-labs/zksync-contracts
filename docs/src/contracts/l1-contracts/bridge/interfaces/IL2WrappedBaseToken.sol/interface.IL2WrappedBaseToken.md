# IL2WrappedBaseToken
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/IL2WrappedBaseToken.sol)


## Functions
### deposit


```solidity
function deposit() external payable;
```

### withdraw


```solidity
function withdraw(uint256 _amount) external;
```

### depositTo


```solidity
function depositTo(address _to) external payable;
```

### withdrawTo


```solidity
function withdrawTo(address _to, uint256 _amount) external;
```

## Events
### Initialize

```solidity
event Initialize(string name, string symbol, uint8 decimals);
```

