# AssetHandlerModifiers
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/interfaces/AssetHandlerModifiers.sol)


## Functions
### requireZeroValue

Modifier that ensures that a certain value is zero.

*This should be used in bridgeBurn-like functions to ensure that users
do not accidentally provide value there.*


```solidity
modifier requireZeroValue(uint256 _value);
```

