# IChainAdminOwnable
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/governance/IChainAdminOwnable.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### setTokenMultiplierSetter


```solidity
function setTokenMultiplierSetter(address _tokenMultiplierSetter) external;
```

### setUpgradeTimestamp


```solidity
function setUpgradeTimestamp(
  uint256 _protocolVersion,
  uint256 _upgradeTimestamp
) external;
```

### multicall


```solidity
function multicall(Call[] calldata _calls, bool _requireSuccess)
  external
  payable;
```

### setTokenMultiplier


```solidity
function setTokenMultiplier(
  IAdmin _chainContract,
  uint128 _nominator,
  uint128 _denominator
) external;
```

## Events
### UpdateUpgradeTimestamp
Emitted when the expected upgrade timestamp for a specific protocol version is set.


```solidity
event UpdateUpgradeTimestamp(
  uint256 indexed _protocolVersion, uint256 _upgradeTimestamp
);
```

### CallExecuted
Emitted when the call is executed from the contract.


```solidity
event CallExecuted(Call _call, bool _success, bytes _returnData);
```

### NewTokenMultiplierSetter
Emitted when the new token multiplier address is set.


```solidity
event NewTokenMultiplierSetter(
  address _oldTokenMultiplierSetter, address _newTokenMultiplierSetter
);
```

## Structs
### Call
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

