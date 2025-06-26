# Transaction
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l2-contracts/L2ContractHelper.sol)

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

