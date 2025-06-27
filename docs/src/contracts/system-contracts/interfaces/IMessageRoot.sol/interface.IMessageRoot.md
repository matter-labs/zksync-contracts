# IMessageRoot
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IMessageRoot.sol)

**Author:**
Matter Labs

MessageRoot contract is responsible for storing and aggregating the roots of the batches from different chains into the MessageRoot.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### getAggregatedRoot

The aggregated root of the batches from different chains.


```solidity
function getAggregatedRoot() external view returns (bytes32 aggregatedRoot);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`aggregatedRoot`|`bytes32`|of the batches from different chains.|


