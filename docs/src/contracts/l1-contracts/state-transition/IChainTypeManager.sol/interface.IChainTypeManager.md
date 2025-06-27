# IChainTypeManager
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/IChainTypeManager.sol)


## Functions
### BRIDGE_HUB


```solidity
function BRIDGE_HUB() external view returns (address);
```

### setPendingAdmin


```solidity
function setPendingAdmin(address _newPendingAdmin) external;
```

### acceptAdmin


```solidity
function acceptAdmin() external;
```

### getZKChain


```solidity
function getZKChain(uint256 _chainId) external view returns (address);
```

### getHyperchain


```solidity
function getHyperchain(uint256 _chainId) external view returns (address);
```

### getZKChainLegacy


```solidity
function getZKChainLegacy(uint256 _chainId) external view returns (address);
```

### storedBatchZero


```solidity
function storedBatchZero() external view returns (bytes32);
```

### initialCutHash


```solidity
function initialCutHash() external view returns (bytes32);
```

### l1GenesisUpgrade


```solidity
function l1GenesisUpgrade() external view returns (address);
```

### upgradeCutHash


```solidity
function upgradeCutHash(uint256 _protocolVersion)
  external
  view
  returns (bytes32);
```

### protocolVersion


```solidity
function protocolVersion() external view returns (uint256);
```

### protocolVersionDeadline


```solidity
function protocolVersionDeadline(uint256 _protocolVersion)
  external
  view
  returns (uint256);
```

### protocolVersionIsActive


```solidity
function protocolVersionIsActive(uint256 _protocolVersion)
  external
  view
  returns (bool);
```

### getProtocolVersion


```solidity
function getProtocolVersion(uint256 _chainId) external view returns (uint256);
```

### initialize


```solidity
function initialize(ChainTypeManagerInitializeData calldata _initializeData)
  external;
```

### setValidatorTimelock


```solidity
function setValidatorTimelock(address _validatorTimelock) external;
```

### setChainCreationParams


```solidity
function setChainCreationParams(
  ChainCreationParams calldata _chainCreationParams
) external;
```

### getChainAdmin


```solidity
function getChainAdmin(uint256 _chainId) external view returns (address);
```

### createNewChain


```solidity
function createNewChain(
  uint256 _chainId,
  bytes32 _baseTokenAssetId,
  address _admin,
  bytes calldata _initData,
  bytes[] calldata _factoryDeps
) external returns (address);
```

### setNewVersionUpgrade


```solidity
function setNewVersionUpgrade(
  Diamond.DiamondCutData calldata _cutData,
  uint256 _oldProtocolVersion,
  uint256 _oldProtocolVersionDeadline,
  uint256 _newProtocolVersion
) external;
```

### setUpgradeDiamondCut


```solidity
function setUpgradeDiamondCut(
  Diamond.DiamondCutData calldata _cutData,
  uint256 _oldProtocolVersion
) external;
```

### executeUpgrade


```solidity
function executeUpgrade(
  uint256 _chainId,
  Diamond.DiamondCutData calldata _diamondCut
) external;
```

### setPriorityTxMaxGasLimit


```solidity
function setPriorityTxMaxGasLimit(uint256 _chainId, uint256 _maxGasLimit)
  external;
```

### freezeChain


```solidity
function freezeChain(uint256 _chainId) external;
```

### unfreezeChain


```solidity
function unfreezeChain(uint256 _chainId) external;
```

### setTokenMultiplier


```solidity
function setTokenMultiplier(
  uint256 _chainId,
  uint128 _nominator,
  uint128 _denominator
) external;
```

### changeFeeParams


```solidity
function changeFeeParams(uint256 _chainId, FeeParams calldata _newFeeParams)
  external;
```

### setValidator


```solidity
function setValidator(uint256 _chainId, address _validator, bool _active)
  external;
```

### setPorterAvailability


```solidity
function setPorterAvailability(uint256 _chainId, bool _zkPorterIsAvailable)
  external;
```

### upgradeChainFromVersion


```solidity
function upgradeChainFromVersion(
  uint256 _chainId,
  uint256 _oldProtocolVersion,
  Diamond.DiamondCutData calldata _diamondCut
) external;
```

### getSemverProtocolVersion


```solidity
function getSemverProtocolVersion()
  external
  view
  returns (uint32, uint32, uint32);
```

### forwardedBridgeBurn


```solidity
function forwardedBridgeBurn(uint256 _chainId, bytes calldata _data)
  external
  returns (bytes memory _bridgeMintData);
```

### forwardedBridgeMint


```solidity
function forwardedBridgeMint(uint256 _chainId, bytes calldata _data)
  external
  returns (address);
```

### forwardedBridgeRecoverFailedTransfer


```solidity
function forwardedBridgeRecoverFailedTransfer(
  uint256 _chainId,
  bytes32 _assetInfo,
  address _depositSender,
  bytes calldata _ctmData
) external;
```

## Events
### NewZKChain
*Emitted when a new ZKChain is added*


```solidity
event NewZKChain(uint256 indexed _chainId, address indexed _zkChainContract);
```

### GenesisUpgrade
*emitted when an chain registers and a GenesisUpgrade happens*


```solidity
event GenesisUpgrade(
  address indexed _zkChain,
  L2CanonicalTransaction _l2Transaction,
  uint256 indexed _protocolVersion
);
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

### NewValidatorTimelock
ValidatorTimelock changed


```solidity
event NewValidatorTimelock(
  address indexed oldValidatorTimelock, address indexed newValidatorTimelock
);
```

### NewChainCreationParams
chain creation parameters changed


```solidity
event NewChainCreationParams(
  address genesisUpgrade,
  bytes32 genesisBatchHash,
  uint64 genesisIndexRepeatedStorageChanges,
  bytes32 genesisBatchCommitment,
  bytes32 newInitialCutHash,
  bytes32 forceDeploymentHash
);
```

### NewUpgradeCutHash
New UpgradeCutHash


```solidity
event NewUpgradeCutHash(
  uint256 indexed protocolVersion, bytes32 indexed upgradeCutHash
);
```

### NewUpgradeCutData
New UpgradeCutData


```solidity
event NewUpgradeCutData(
  uint256 indexed protocolVersion, Diamond.DiamondCutData diamondCutData
);
```

### NewProtocolVersion
New ProtocolVersion


```solidity
event NewProtocolVersion(
  uint256 indexed oldProtocolVersion, uint256 indexed newProtocolVersion
);
```

### UpdateProtocolVersionDeadline
Updated ProtocolVersion deadline


```solidity
event UpdateProtocolVersionDeadline(
  uint256 indexed protocolVersion, uint256 deadline
);
```

