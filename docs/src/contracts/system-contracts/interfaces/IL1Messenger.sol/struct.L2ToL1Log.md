# L2ToL1Log
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IL1Messenger.sol)

*The log passed from L2*


```solidity
struct L2ToL1Log {
  uint8 l2ShardId;
  bool isService;
  uint16 txNumberInBlock;
  address sender;
  bytes32 key;
  bytes32 value;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`l2ShardId`|`uint8`|The shard identifier, 0 - rollup, 1 - porter. All other values are not used but are reserved for the future|
|`isService`|`bool`|A boolean flag that is part of the log along with `key`, `value`, and `sender` address. This field is required formally but does not have any special meaning.|
|`txNumberInBlock`|`uint16`|The L2 transaction number in a block, in which the log was sent|
|`sender`|`address`|The L2 address which sent the log|
|`key`|`bytes32`|The 32 bytes of information that was sent in the log|
|`value`|`bytes32`|The 32 bytes of information that was sent in the log|

