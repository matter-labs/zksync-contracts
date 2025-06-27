# UpgradeState
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-deps/ZKChainStorage.sol)

Indicates whether an upgrade is initiated and if yes what type


```solidity
enum UpgradeState {
  None,
  Transparent,
  Shadow
}
```

