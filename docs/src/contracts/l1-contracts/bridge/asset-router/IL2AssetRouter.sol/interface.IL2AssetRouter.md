# IL2AssetRouter
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/asset-router/IL2AssetRouter.sol)

**Inherits:**
[IAssetRouterBase](/contracts/l1-contracts/bridge/asset-router/IAssetRouterBase.sol/interface.IAssetRouterBase.md)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### withdraw


```solidity
function withdraw(bytes32 _assetId, bytes calldata _transferData)
  external
  returns (bytes32);
```

### L1_ASSET_ROUTER


```solidity
function L1_ASSET_ROUTER() external view returns (address);
```

### withdrawLegacyBridge


```solidity
function withdrawLegacyBridge(
  address _l1Receiver,
  address _l2Token,
  uint256 _amount,
  address _sender
) external;
```

### finalizeDepositLegacyBridge


```solidity
function finalizeDepositLegacyBridge(
  address _l1Sender,
  address _l2Receiver,
  address _l1Token,
  uint256 _amount,
  bytes calldata _data
) external;
```

### setAssetHandlerAddress

*Used to set the assetHandlerAddress for a given assetId.*

*Will be used by ZK Gateway*


```solidity
function setAssetHandlerAddress(
  uint256 _originChainId,
  bytes32 _assetId,
  address _assetHandlerAddress
) external;
```

### setLegacyTokenAssetHandler

Function that allows native token vault to register itself as the asset handler for
a legacy asset.


```solidity
function setLegacyTokenAssetHandler(bytes32 _assetId) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_assetId`|`bytes32`|The assetId of the legacy token.|


## Events
### WithdrawalInitiatedAssetRouter

```solidity
event WithdrawalInitiatedAssetRouter(
  uint256 chainId,
  address indexed l2Sender,
  bytes32 indexed assetId,
  bytes assetData
);
```

