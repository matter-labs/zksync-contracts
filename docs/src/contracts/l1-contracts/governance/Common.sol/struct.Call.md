# Call
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/governance/Common.sol)

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

