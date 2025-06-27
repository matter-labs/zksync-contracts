# IRestriction
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/governance/restriction/IRestriction.sol)

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


