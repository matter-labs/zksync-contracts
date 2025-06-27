# BridgehubL2TransactionRequest
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/common/Messaging.sol)


```solidity
struct BridgehubL2TransactionRequest {
  address sender;
  address contractL2;
  uint256 mintValue;
  uint256 l2Value;
  bytes l2Calldata;
  uint256 l2GasLimit;
  uint256 l2GasPerPubdataByteLimit;
  bytes[] factoryDeps;
  address refundRecipient;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`sender`|`address`|The sender's address.|
|`contractL2`|`address`||
|`mintValue`|`uint256`||
|`l2Value`|`uint256`|The msg.value of the L2 transaction.|
|`l2Calldata`|`bytes`|The calldata for the L2 transaction.|
|`l2GasLimit`|`uint256`|The limit of the L2 gas for the L2 transaction|
|`l2GasPerPubdataByteLimit`|`uint256`|The price for a single pubdata byte in L2 gas.|
|`factoryDeps`|`bytes[]`|The array of L2 bytecodes that the tx depends on.|
|`refundRecipient`|`address`|The recipient of the refund for the transaction on L2. If the transaction fails, then this address will receive the `l2Value`.|

