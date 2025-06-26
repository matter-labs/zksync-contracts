# IBootloaderUtilities
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IBootloaderUtilities.sol)


## Functions
### getTransactionHashes


```solidity
function getTransactionHashes(Transaction calldata _transaction)
  external
  view
  returns (bytes32 txHash, bytes32 signedTxHash);
```

