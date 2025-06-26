# IAdmin
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IAdmin.sol)

**Inherits:**
[IZKChainBase](/contracts/l1-contracts/state-transition/chain-interfaces/IZKChainBase.sol/interface.IZKChainBase.md)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### setPendingAdmin

Starts the transfer of admin rights. Only the current admin can propose a new pending one.

New admin can accept admin rights by calling `acceptAdmin` function.


```solidity
function setPendingAdmin(address _newPendingAdmin) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newPendingAdmin`|`address`|Address of the new admin|


### acceptAdmin

Accepts transfer of admin rights. Only pending admin can accept the role.


```solidity
function acceptAdmin() external;
```

### setValidator

Change validator status (active or not active)


```solidity
function setValidator(address _validator, bool _active) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_validator`|`address`|Validator address|
|`_active`|`bool`|Active flag|


### setPorterAvailability

Change zk porter availability


```solidity
function setPorterAvailability(bool _zkPorterIsAvailable) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_zkPorterIsAvailable`|`bool`|The availability of zk porter shard|


### setPriorityTxMaxGasLimit

Change the max L2 gas limit for L1 -> L2 transactions


```solidity
function setPriorityTxMaxGasLimit(uint256 _newPriorityTxMaxGasLimit) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newPriorityTxMaxGasLimit`|`uint256`|The maximum number of L2 gas that a user can request for L1 -> L2 transactions|


### changeFeeParams

Change the fee params for L1->L2 transactions


```solidity
function changeFeeParams(FeeParams calldata _newFeeParams) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newFeeParams`|`FeeParams`|The new fee params|


### setTokenMultiplier

Change the token multiplier for L1->L2 transactions


```solidity
function setTokenMultiplier(uint128 _nominator, uint128 _denominator) external;
```

### setPubdataPricingMode

Change the pubdata pricing mode before the first batch is processed


```solidity
function setPubdataPricingMode(PubdataPricingMode _pricingMode) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_pricingMode`|`PubdataPricingMode`|The new pubdata pricing mode|


### setTransactionFilterer

Set the transaction filterer


```solidity
function setTransactionFilterer(address _transactionFilterer) external;
```

### upgradeChainFromVersion

Perform the upgrade from the current protocol version with the corresponding upgrade data


```solidity
function upgradeChainFromVersion(
  uint256 _protocolVersion,
  Diamond.DiamondCutData calldata _cutData
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_protocolVersion`|`uint256`|The current protocol version from which upgrade is executed|
|`_cutData`|`Diamond.DiamondCutData`|The diamond cut parameters that is executed in the upgrade|


### executeUpgrade

Executes a proposed governor upgrade

*Only the ChainTypeManager contract can execute the upgrade*


```solidity
function executeUpgrade(Diamond.DiamondCutData calldata _diamondCut) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_diamondCut`|`Diamond.DiamondCutData`|The diamond cut parameters to be executed|


### freezeDiamond

Instantly pause the functionality of all freezable facets & their selectors

*Only the governance mechanism may freeze Diamond Proxy*


```solidity
function freezeDiamond() external;
```

### unfreezeDiamond

Unpause the functionality of all freezable facets & their selectors

*Only the CTM can unfreeze Diamond Proxy*


```solidity
function unfreezeDiamond() external;
```

### genesisUpgrade


```solidity
function genesisUpgrade(
  address _l1GenesisUpgrade,
  address _ctmDeployer,
  bytes calldata _forceDeploymentData,
  bytes[] calldata _factoryDeps
) external;
```

### setDAValidatorPair

Set the L1 DA validator address as well as the L2 DA validator address.

*While in principle it is possible that updating only one of the addresses is needed,
usually these should work in pair and L1 validator typically expects a specific input from the L2 Validator.
That's why we change those together to prevent admins of chains from shooting themselves in the foot.*


```solidity
function setDAValidatorPair(address _l1DAValidator, address _l2DAValidator)
  external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_l1DAValidator`|`address`|The address of the L1 DA validator|
|`_l2DAValidator`|`address`|The address of the L2 DA validator|


### makePermanentRollup

Makes the chain as permanent rollup.

*This is a security feature needed for chains that should be
trusted to keep their data available even if the chain admin becomes malicious
and tries to set the DA validator pair to something which does not publish DA to Ethereum.*

*DANGEROUS: once activated, there is no way back!*


```solidity
function makePermanentRollup() external;
```

### forwardedBridgeBurn

*Similar to IL1AssetHandler interface, used to send chains.*


```solidity
function forwardedBridgeBurn(
  address _settlementLayer,
  address _originalCaller,
  bytes calldata _data
) external payable returns (bytes memory _bridgeMintData);
```

### forwardedBridgeRecoverFailedTransfer

*Similar to IL1AssetHandler interface, used to claim failed chain transfers.*


```solidity
function forwardedBridgeRecoverFailedTransfer(
  uint256 _chainId,
  bytes32 _assetInfo,
  address _originalCaller,
  bytes calldata _chainData
) external payable;
```

### forwardedBridgeMint

*Similar to IL1AssetHandler interface, used to receive chains.*


```solidity
function forwardedBridgeMint(
  bytes calldata _data,
  bool _contractAlreadyDeployed
) external payable;
```

### prepareChainCommitment


```solidity
function prepareChainCommitment()
  external
  view
  returns (ZKChainCommitment memory commitment);
```

## Events
### IsPorterAvailableStatusUpdate
Porter availability status changes


```solidity
event IsPorterAvailableStatusUpdate(bool isPorterAvailable);
```

### ValidatorStatusUpdate
Validator's status changed


```solidity
event ValidatorStatusUpdate(address indexed validatorAddress, bool isActive);
```

### NewPendingAdmin
pendingAdmin is changed

*Also emitted when new admin is accepted and in this case, `newPendingAdmin` would be zero address*


```solidity
event NewPendingAdmin(
  address indexed oldPendingAdmin, address indexed newPendingAdmin
);
```

### NewAdmin
Admin changed


```solidity
event NewAdmin(address indexed oldAdmin, address indexed newAdmin);
```

### NewPriorityTxMaxGasLimit
Priority transaction max L2 gas limit changed


```solidity
event NewPriorityTxMaxGasLimit(
  uint256 oldPriorityTxMaxGasLimit, uint256 newPriorityTxMaxGasLimit
);
```

### NewFeeParams
Fee params for L1->L2 transactions changed


```solidity
event NewFeeParams(FeeParams oldFeeParams, FeeParams newFeeParams);
```

### PubdataPricingModeUpdate
Validium mode status changed


```solidity
event PubdataPricingModeUpdate(PubdataPricingMode validiumMode);
```

### NewTransactionFilterer
The transaction filterer has been updated


```solidity
event NewTransactionFilterer(
  address oldTransactionFilterer, address newTransactionFilterer
);
```

### NewBaseTokenMultiplier
BaseToken multiplier for L1->L2 transactions changed


```solidity
event NewBaseTokenMultiplier(
  uint128 oldNominator,
  uint128 oldDenominator,
  uint128 newNominator,
  uint128 newDenominator
);
```

### ExecuteUpgrade
Emitted when an upgrade is executed.


```solidity
event ExecuteUpgrade(Diamond.DiamondCutData diamondCut);
```

### MigrationComplete
Emitted when the migration to the new settlement layer is complete.


```solidity
event MigrationComplete();
```

### Freeze
Emitted when the contract is frozen.


```solidity
event Freeze();
```

### Unfreeze
Emitted when the contract is unfrozen.


```solidity
event Unfreeze();
```

### NewL2DAValidator
New pair of DA validators set


```solidity
event NewL2DAValidator(
  address indexed oldL2DAValidator, address indexed newL2DAValidator
);
```

### NewL1DAValidator

```solidity
event NewL1DAValidator(
  address indexed oldL1DAValidator, address indexed newL1DAValidator
);
```

### BridgeMint

```solidity
event BridgeMint(address indexed _account, uint256 _amount);
```

