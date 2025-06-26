# IBridgehub
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridgehub/IBridgehub.sol)

**Inherits:**
[IAssetHandler](/contracts/l1-contracts/bridge/interfaces/IAssetHandler.sol/interface.IAssetHandler.md), [IL1AssetHandler](/contracts/l1-contracts/bridge/interfaces/IL1AssetHandler.sol/interface.IL1AssetHandler.md)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### setPendingAdmin

Starts the transfer of admin rights. Only the current admin or owner can propose a new pending one.

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

### chainTypeManagerIsRegistered

Getters


```solidity
function chainTypeManagerIsRegistered(address _chainTypeManager)
  external
  view
  returns (bool);
```

### chainTypeManager


```solidity
function chainTypeManager(uint256 _chainId) external view returns (address);
```

### assetIdIsRegistered


```solidity
function assetIdIsRegistered(bytes32 _baseTokenAssetId)
  external
  view
  returns (bool);
```

### baseToken


```solidity
function baseToken(uint256 _chainId) external view returns (address);
```

### baseTokenAssetId


```solidity
function baseTokenAssetId(uint256 _chainId) external view returns (bytes32);
```

### sharedBridge


```solidity
function sharedBridge() external view returns (address);
```

### messageRoot


```solidity
function messageRoot() external view returns (IMessageRoot);
```

### getZKChain


```solidity
function getZKChain(uint256 _chainId) external view returns (address);
```

### getAllZKChains


```solidity
function getAllZKChains() external view returns (address[] memory);
```

### getAllZKChainChainIDs


```solidity
function getAllZKChainChainIDs() external view returns (uint256[] memory);
```

### migrationPaused


```solidity
function migrationPaused() external view returns (bool);
```

### admin


```solidity
function admin() external view returns (address);
```

### assetRouter


```solidity
function assetRouter() external view returns (address);
```

### proveL2MessageInclusion

Mailbox forwarder


```solidity
function proveL2MessageInclusion(
  uint256 _chainId,
  uint256 _batchNumber,
  uint256 _index,
  L2Message calldata _message,
  bytes32[] calldata _proof
) external view returns (bool);
```

### proveL2LogInclusion


```solidity
function proveL2LogInclusion(
  uint256 _chainId,
  uint256 _batchNumber,
  uint256 _index,
  L2Log memory _log,
  bytes32[] calldata _proof
) external view returns (bool);
```

### proveL1ToL2TransactionStatus


```solidity
function proveL1ToL2TransactionStatus(
  uint256 _chainId,
  bytes32 _l2TxHash,
  uint256 _l2BatchNumber,
  uint256 _l2MessageIndex,
  uint16 _l2TxNumberInBatch,
  bytes32[] calldata _merkleProof,
  TxStatus _status
) external view returns (bool);
```

### requestL2TransactionDirect


```solidity
function requestL2TransactionDirect(
  L2TransactionRequestDirect calldata _request
) external payable returns (bytes32 canonicalTxHash);
```

### requestL2TransactionTwoBridges


```solidity
function requestL2TransactionTwoBridges(
  L2TransactionRequestTwoBridgesOuter calldata _request
) external payable returns (bytes32 canonicalTxHash);
```

### l2TransactionBaseCost


```solidity
function l2TransactionBaseCost(
  uint256 _chainId,
  uint256 _gasPrice,
  uint256 _l2GasLimit,
  uint256 _l2GasPerPubdataByteLimit
) external view returns (uint256);
```

### createNewChain


```solidity
function createNewChain(
  uint256 _chainId,
  address _chainTypeManager,
  bytes32 _baseTokenAssetId,
  uint256 _salt,
  address _admin,
  bytes calldata _initData,
  bytes[] calldata _factoryDeps
) external returns (uint256 chainId);
```

### addChainTypeManager


```solidity
function addChainTypeManager(address _chainTypeManager) external;
```

### removeChainTypeManager


```solidity
function removeChainTypeManager(address _chainTypeManager) external;
```

### addTokenAssetId


```solidity
function addTokenAssetId(bytes32 _baseTokenAssetId) external;
```

### setAddresses


```solidity
function setAddresses(
  address _sharedBridge,
  ICTMDeploymentTracker _l1CtmDeployer,
  IMessageRoot _messageRoot
) external;
```

### whitelistedSettlementLayers


```solidity
function whitelistedSettlementLayers(uint256 _chainId)
  external
  view
  returns (bool);
```

### registerSettlementLayer


```solidity
function registerSettlementLayer(
  uint256 _newSettlementLayerChainId,
  bool _isWhitelisted
) external;
```

### settlementLayer


```solidity
function settlementLayer(uint256 _chainId) external view returns (uint256);
```

### forwardTransactionOnGateway


```solidity
function forwardTransactionOnGateway(
  uint256 _chainId,
  bytes32 _canonicalTxHash,
  uint64 _expirationTimestamp
) external;
```

### ctmAssetIdFromChainId


```solidity
function ctmAssetIdFromChainId(uint256 _chainId)
  external
  view
  returns (bytes32);
```

### ctmAssetIdFromAddress


```solidity
function ctmAssetIdFromAddress(address _ctmAddress)
  external
  view
  returns (bytes32);
```

### l1CtmDeployer


```solidity
function l1CtmDeployer() external view returns (ICTMDeploymentTracker);
```

### ctmAssetIdToAddress


```solidity
function ctmAssetIdToAddress(bytes32 _assetInfo)
  external
  view
  returns (address);
```

### setCTMAssetAddress


```solidity
function setCTMAssetAddress(bytes32 _additionalData, address _assetAddress)
  external;
```

### L1_CHAIN_ID


```solidity
function L1_CHAIN_ID() external view returns (uint256);
```

### registerAlreadyDeployedZKChain


```solidity
function registerAlreadyDeployedZKChain(uint256 _chainId, address _hyperchain)
  external;
```

### getHyperchain

return the ZK chain contract for a chainId

*It is a legacy method. Do not use!*


```solidity
function getHyperchain(uint256 _chainId) external view returns (address);
```

### registerLegacyChain


```solidity
function registerLegacyChain(uint256 _chainId) external;
```

## Events
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

### AssetRegistered
CTM asset registered


```solidity
event AssetRegistered(
  bytes32 indexed assetInfo,
  address indexed _assetAddress,
  bytes32 indexed additionalData,
  address sender
);
```

### SettlementLayerRegistered

```solidity
event SettlementLayerRegistered(
  uint256 indexed chainId, bool indexed isWhitelisted
);
```

### MigrationStarted
Emitted when the bridging to the chain is started.


```solidity
event MigrationStarted(
  uint256 indexed chainId,
  bytes32 indexed assetId,
  uint256 indexed settlementLayerChainId
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chainId`|`uint256`|Chain ID of the ZK chain|
|`assetId`|`bytes32`|Asset ID of the token for the zkChain's CTM|
|`settlementLayerChainId`|`uint256`|The chain id of the settlement layer the chain migrates to.|

### MigrationFinalized
Emitted when the bridging to the chain is complete.


```solidity
event MigrationFinalized(
  uint256 indexed chainId, bytes32 indexed assetId, address indexed zkChain
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chainId`|`uint256`|Chain ID of the ZK chain|
|`assetId`|`bytes32`|Asset ID of the token for the zkChain's CTM|
|`zkChain`|`address`|The address of the ZK chain on the chain where it is migrated to.|

### NewChain

```solidity
event NewChain(
  uint256 indexed chainId,
  address chainTypeManager,
  address indexed chainGovernance
);
```

### ChainTypeManagerAdded

```solidity
event ChainTypeManagerAdded(address indexed chainTypeManager);
```

### ChainTypeManagerRemoved

```solidity
event ChainTypeManagerRemoved(address indexed chainTypeManager);
```

### BaseTokenAssetIdRegistered

```solidity
event BaseTokenAssetIdRegistered(bytes32 indexed assetId);
```

