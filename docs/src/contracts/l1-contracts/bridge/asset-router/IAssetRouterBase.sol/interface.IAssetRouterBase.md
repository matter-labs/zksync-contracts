# IAssetRouterBase
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/asset-router/IAssetRouterBase.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### BRIDGE_HUB


```solidity
function BRIDGE_HUB() external view returns (IBridgehub);
```

### setAssetHandlerAddressThisChain

Sets the asset handler address for a specified asset ID on the chain of the asset deployment tracker.

*The caller of this function is encoded within the `assetId`, therefore, it should be invoked by the asset deployment tracker contract.*

*No access control on the caller, as msg.sender is encoded in the assetId.*

*Typically, for most tokens, ADT is the native token vault. However, custom tokens may have their own specific asset deployment trackers.*

*`setAssetHandlerAddressOnCounterpart` should be called on L1 to set asset handlers on L2 chains for a specific asset ID.*


```solidity
function setAssetHandlerAddressThisChain(
  bytes32 _assetRegistrationData,
  address _assetHandlerAddress
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_assetRegistrationData`|`bytes32`|The asset data which may include the asset address and any additional required data or encodings.|
|`_assetHandlerAddress`|`address`|The address of the asset handler to be set for the provided asset.|


### assetHandlerAddress


```solidity
function assetHandlerAddress(bytes32 _assetId) external view returns (address);
```

### finalizeDeposit

Finalize the withdrawal and release funds.

*We have both the legacy finalizeWithdrawal and the new finalizeDeposit functions,
finalizeDeposit uses the new format. On the L2 we have finalizeDeposit with new and old formats both.*


```solidity
function finalizeDeposit(
  uint256 _chainId,
  bytes32 _assetId,
  bytes memory _transferData
) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|The chain ID of the transaction to check.|
|`_assetId`|`bytes32`|The bridged asset ID.|
|`_transferData`|`bytes`|The position in the L2 logs Merkle tree of the l2Log that was sent with the message.|


## Events
### BridgehubDepositBaseTokenInitiated

```solidity
event BridgehubDepositBaseTokenInitiated(
  uint256 indexed chainId, address indexed from, bytes32 assetId, uint256 amount
);
```

### BridgehubDepositInitiated

```solidity
event BridgehubDepositInitiated(
  uint256 indexed chainId,
  bytes32 indexed txDataHash,
  address indexed from,
  bytes32 assetId,
  bytes bridgeMintCalldata
);
```

### BridgehubWithdrawalInitiated

```solidity
event BridgehubWithdrawalInitiated(
  uint256 chainId,
  address indexed sender,
  bytes32 indexed assetId,
  bytes32 assetDataHash
);
```

### AssetDeploymentTrackerRegistered

```solidity
event AssetDeploymentTrackerRegistered(
  bytes32 indexed assetId,
  bytes32 indexed additionalData,
  address assetDeploymentTracker
);
```

### AssetHandlerRegistered

```solidity
event AssetHandlerRegistered(
  bytes32 indexed assetId, address indexed _assetHandlerAddress
);
```

### DepositFinalizedAssetRouter

```solidity
event DepositFinalizedAssetRouter(
  uint256 indexed chainId, bytes32 indexed assetId, bytes assetData
);
```

