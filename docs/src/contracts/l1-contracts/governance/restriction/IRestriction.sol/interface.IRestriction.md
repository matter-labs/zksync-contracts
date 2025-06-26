# IRestriction
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/governance/restriction/IRestriction.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### getSupportsRestrictionMagic

A method used to check that the contract supports this interface.


```solidity
function getSupportsRestrictionMagic() external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|Returns the `RESTRICTION_MAGIC`|


### validateCall

Ensures that the invoker has the required role to call the function.


```solidity
function validateCall(Call calldata _call, address _invoker) external view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_call`|`Call`|The call data.|
|`_invoker`|`address`|The address of the invoker.|


