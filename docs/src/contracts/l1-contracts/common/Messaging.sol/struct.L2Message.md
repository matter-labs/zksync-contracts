# L2Message
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/common/Messaging.sol)

Under the hood it is `L2Log` sent from the special system L2 contract

*An arbitrary length message passed from L2*


```solidity
struct L2Message {
  uint16 txNumberInBatch;
  address sender;
  bytes data;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`txNumberInBatch`|`uint16`|The L2 transaction number in a Batch, in which the message was sent|
|`sender`|`address`|The address of the L2 account from which the message was passed|
|`data`|`bytes`|An arbitrary length message|

