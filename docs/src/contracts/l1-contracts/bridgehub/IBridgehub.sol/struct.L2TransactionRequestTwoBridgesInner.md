# L2TransactionRequestTwoBridgesInner
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridgehub/IBridgehub.sol)


```solidity
struct L2TransactionRequestTwoBridgesInner {
  bytes32 magicValue;
  address l2Contract;
  bytes l2Calldata;
  bytes[] factoryDeps;
  bytes32 txDataHash;
}
```

