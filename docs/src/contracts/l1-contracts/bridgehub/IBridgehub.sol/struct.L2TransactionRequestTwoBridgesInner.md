# L2TransactionRequestTwoBridgesInner
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridgehub/IBridgehub.sol)


```solidity
struct L2TransactionRequestTwoBridgesInner {
  bytes32 magicValue;
  address l2Contract;
  bytes l2Calldata;
  bytes[] factoryDeps;
  bytes32 txDataHash;
}
```

