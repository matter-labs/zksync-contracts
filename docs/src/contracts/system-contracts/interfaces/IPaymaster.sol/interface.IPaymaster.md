# IPaymaster
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IPaymaster.sol)


## Functions
### validateAndPayForPaymasterTransaction

*Called by the bootloader to verify that the paymaster agrees to pay for the
fee for the transaction. This transaction should also send the necessary amount of funds onto the bootloader
address.*

*The developer should strive to preserve as many steps as possible both for valid
and invalid transactions as this very method is also used during the gas fee estimation
(without some of the necessary data, e.g. signature).*


```solidity
function validateAndPayForPaymasterTransaction(
  bytes32 _txHash,
  bytes32 _suggestedSignedHash,
  Transaction calldata _transaction
) external payable returns (bytes4 magic, bytes memory context);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_txHash`|`bytes32`|The hash of the transaction|
|`_suggestedSignedHash`|`bytes32`|The hash of the transaction that is signed by an EOA|
|`_transaction`|`Transaction`|The transaction itself.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`magic`|`bytes4`|The value that should be equal to the signature of the validateAndPayForPaymasterTransaction if the paymaster agrees to pay for the transaction.|
|`context`|`bytes`|The "context" of the transaction: an array of bytes of length at most 1024 bytes, which will be passed to the `postTransaction` method of the account.|


### postTransaction

*Called by the bootloader after the execution of the transaction. Please note that
there is no guarantee that this method will be called at all. Unlike the original EIP4337,
this method won't be called if the transaction execution results in out-of-gas.*

*The exact amount refunded depends on the gas spent by the "postOp" itself and so the developers should
take that into account.*


```solidity
function postTransaction(
  bytes calldata _context,
  Transaction calldata _transaction,
  bytes32 _txHash,
  bytes32 _suggestedSignedHash,
  ExecutionResult _txResult,
  uint256 _maxRefundedGas
) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_context`|`bytes`||
|`_transaction`|`Transaction`||
|`_txHash`|`bytes32`||
|`_suggestedSignedHash`|`bytes32`||
|`_txResult`|`ExecutionResult`||
|`_maxRefundedGas`|`uint256`||


