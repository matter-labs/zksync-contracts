# Transaction
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/libraries/TransactionHelper.sol)

Structure used to represent a ZKsync transaction.


```solidity
struct Transaction {
  uint256 txType;
  uint256 from;
  uint256 to;
  uint256 gasLimit;
  uint256 gasPerPubdataByteLimit;
  uint256 maxFeePerGas;
  uint256 maxPriorityFeePerGas;
  uint256 paymaster;
  uint256 nonce;
  uint256 value;
  uint256[4] reserved;
  bytes data;
  bytes signature;
  bytes32[] factoryDeps;
  bytes paymasterInput;
  bytes reservedDynamic;
}
```

