# IChainAdmin
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/governance/IChainAdmin.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### getRestrictions

Returns the list of active restrictions.


```solidity
function getRestrictions() external view returns (address[] memory);
```

### isRestrictionActive

Checks if the restriction is active.


```solidity
function isRestrictionActive(address _restriction) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_restriction`|`address`|The address of the restriction contract.|


### addRestriction

Adds a new restriction to the active restrictions set.


```solidity
function addRestriction(address _restriction) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_restriction`|`address`|The address of the restriction contract.|


### removeRestriction

Removes a restriction from the active restrictions set.

*Sometimes restrictions might need to enforce their permanence (e.g. if a chain should be a rollup forever).*


```solidity
function removeRestriction(address _restriction) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_restriction`|`address`|The address of the restriction contract.|


### multicall

Execute multiple calls as part of contract administration.

*Intended for batch processing of contract interactions, managing gas efficiency and atomicity of operations.*

*Note, that this function lacks access control. It is expected that the access control is implemented in a separate restriction contract.*

*Even though all the validation from external modules is executed via `staticcall`, the function
is marked as `nonReentrant` to prevent reentrancy attacks in case the staticcall restriction is lifted in the future.*


```solidity
function multicall(Call[] calldata _calls, bool _requireSuccess)
  external
  payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_calls`|`Call[]`|Array of Call structures defining target, value, and data for each call.|
|`_requireSuccess`|`bool`|If true, reverts transaction on any call failure.|


## Events
### UpdateUpgradeTimestamp
Emitted when the expected upgrade timestamp for a specific protocol version is set.


```solidity
event UpdateUpgradeTimestamp(
  uint256 indexed protocolVersion, uint256 upgradeTimestamp
);
```

### CallExecuted
Emitted when the call is executed from the contract.


```solidity
event CallExecuted(Call call, bool success, bytes returnData);
```

### RestrictionAdded
Emitted when a new restriction is added.


```solidity
event RestrictionAdded(address indexed restriction);
```

### RestrictionRemoved
Emitted when a restriction is removed.


```solidity
event RestrictionRemoved(address indexed restriction);
```

