# PubdataPricingMode
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-deps/ZKChainStorage.sol)

The struct that describes whether users will be charged for pubdata for L1->L2 transactions.


```solidity
enum PubdataPricingMode {
  Rollup,
  Validium
}
```

