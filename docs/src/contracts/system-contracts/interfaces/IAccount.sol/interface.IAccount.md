# IAccount
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IAccount.sol)


## Functions
### validateTransaction

Called by the bootloader to validate that an account agrees to process the transaction
(and potentially pay for it).

*The developer should strive to preserve as many steps as possible both for valid
and invalid transactions as this very method is also used during the gas fee estimation
(without some of the necessary data, e.g. signature).*


```solidity
function validateTransaction(
  bytes32 _txHash,
  bytes32 _suggestedSignedHash,
  Transaction calldata _transaction
) external payable returns (bytes4 magic);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_txHash`|`bytes32`|The hash of the transaction to be used in the explorer|
|`_suggestedSignedHash`|`bytes32`|The hash of the transaction is signed by EOAs|
|`_transaction`|`Transaction`|The transaction itself|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`magic`|`bytes4`|The magic value that should be equal to the signature of this function if the user agrees to proceed with the transaction.|


### executeTransaction


```solidity
function executeTransaction(
  bytes32 _txHash,
  bytes32 _suggestedSignedHash,
  Transaction calldata _transaction
) external payable;
```

### executeTransactionFromOutside


```solidity
function executeTransactionFromOutside(Transaction calldata _transaction)
  external
  payable;
```

### payForTransaction


```solidity
function payForTransaction(
  bytes32 _txHash,
  bytes32 _suggestedSignedHash,
  Transaction calldata _transaction
) external payable;
```

### prepareForPaymaster


```solidity
function prepareForPaymaster(
  bytes32 _txHash,
  bytes32 _possibleSignedHash,
  Transaction calldata _transaction
) external payable;
```

