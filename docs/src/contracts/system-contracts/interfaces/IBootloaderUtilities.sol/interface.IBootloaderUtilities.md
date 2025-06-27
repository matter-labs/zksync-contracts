# IBootloaderUtilities
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IBootloaderUtilities.sol)


## Functions
### getTransactionHashes


```solidity
function getTransactionHashes(Transaction calldata _transaction)
  external
  view
  returns (bytes32 txHash, bytes32 signedTxHash);
```

