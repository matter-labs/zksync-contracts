# UpgradeState
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-deps/ZKChainStorage.sol)

Indicates whether an upgrade is initiated and if yes what type


```solidity
enum UpgradeState {
  None,
  Transparent,
  Shadow
}
```

