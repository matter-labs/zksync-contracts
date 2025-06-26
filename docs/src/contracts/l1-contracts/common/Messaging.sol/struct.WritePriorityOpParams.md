# WritePriorityOpParams
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/common/Messaging.sol)

*Internal structure that contains the parameters for the writePriorityOp
internal function.*


```solidity
struct WritePriorityOpParams {
  uint256 txId;
  uint256 l2GasPrice;
  uint64 expirationTimestamp;
  BridgehubL2TransactionRequest request;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`txId`|`uint256`|The id of the priority transaction.|
|`l2GasPrice`|`uint256`|The gas price for the l2 priority operation.|
|`expirationTimestamp`|`uint64`|The timestamp by which the priority operation must be processed by the operator.|
|`request`|`BridgehubL2TransactionRequest`|The external calldata request for the priority operation.|

