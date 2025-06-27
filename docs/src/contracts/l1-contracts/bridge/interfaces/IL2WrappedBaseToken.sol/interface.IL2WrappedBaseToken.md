# IL2WrappedBaseToken
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/interfaces/IL2WrappedBaseToken.sol)


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

