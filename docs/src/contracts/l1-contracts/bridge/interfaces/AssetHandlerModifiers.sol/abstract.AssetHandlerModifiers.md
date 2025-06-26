# AssetHandlerModifiers
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/AssetHandlerModifiers.sol)


## Functions
### requireZeroValue

Modifier that ensures that a certain value is zero.

*This should be used in bridgeBurn-like functions to ensure that users
do not accidentally provide value there.*


```solidity
modifier requireZeroValue(uint256 _value);
```

