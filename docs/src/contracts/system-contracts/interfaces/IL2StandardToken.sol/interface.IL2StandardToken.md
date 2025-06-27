# IL2StandardToken
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IL2StandardToken.sol)


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

