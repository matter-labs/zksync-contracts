# ITransactionFilterer
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/ITransactionFilterer.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### isTransactionAllowed

Check if the transaction is allowed


```solidity
function isTransactionAllowed(
  address sender,
  address contractL2,
  uint256 mintValue,
  uint256 l2Value,
  bytes memory l2Calldata,
  address refundRecipient
) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`sender`|`address`|The sender of the transaction|
|`contractL2`|`address`|The L2 receiver address|
|`mintValue`|`uint256`|The value of the L1 transaction|
|`l2Value`|`uint256`|The msg.value of the L2 transaction|
|`l2Calldata`|`bytes`|The calldata of the L2 transaction|
|`refundRecipient`|`address`|The address to refund the excess value|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the transaction is allowed|


