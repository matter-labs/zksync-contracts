# PubdataPricingMode
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-deps/ZKChainStorage.sol)

The struct that describes whether users will be charged for pubdata for L1->L2 transactions.


```solidity
enum PubdataPricingMode {
  Rollup,
  Validium
}
```

