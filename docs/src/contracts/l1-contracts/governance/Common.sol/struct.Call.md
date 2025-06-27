# Call
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/governance/Common.sol)

*Represents a call to be made during multicall.*


```solidity
struct Call {
  address target;
  uint256 value;
  bytes data;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`target`|`address`|The address to which the call will be made.|
|`value`|`uint256`|The amount of Ether (in wei) to be sent along with the call.|
|`data`|`bytes`|The calldata to be executed on the `target` address.|

