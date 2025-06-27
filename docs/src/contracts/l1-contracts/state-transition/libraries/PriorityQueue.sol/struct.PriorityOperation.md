# PriorityOperation
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/libraries/PriorityQueue.sol)

The structure that contains meta information of the L2 transaction that was requested from L1

*The weird size of fields was selected specifically to minimize the structure storage size*


```solidity
struct PriorityOperation {
  bytes32 canonicalTxHash;
  uint64 expirationTimestamp;
  uint192 layer2Tip;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`canonicalTxHash`|`bytes32`|Hashed L2 transaction data that is needed to process it|
|`expirationTimestamp`|`uint64`|Expiration timestamp for this request (must be satisfied before)|
|`layer2Tip`|`uint192`|Additional payment to the validator as an incentive to perform the operation|

