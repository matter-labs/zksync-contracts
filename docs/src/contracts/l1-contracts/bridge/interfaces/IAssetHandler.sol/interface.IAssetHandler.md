# IAssetHandler
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/IAssetHandler.sol)

**Author:**
Matter Labs

Used for any asset handler and called by the AssetRouter

**Note:**
security-contact: security@matterlabs.dev


## Functions
### bridgeMint

*Note, that while payable, this function will only receive base token on L2 chains,
while L1 the provided msg.value is always 0. However, this may change in the future,
so if your AssetHandler implementation relies on it, it is better to explicitly check it.*


```solidity
function bridgeMint(uint256 _chainId, bytes32 _assetId, bytes calldata _data)
  external
  payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|the chainId that the message is from|
|`_assetId`|`bytes32`|the assetId of the asset being bridged|
|`_data`|`bytes`|the actual data specified for the function|


### bridgeBurn

Burns bridged tokens and returns the calldata for L2 <-> L1 message.

*In case of native token vault _data is the tuple of _depositAmount and _l2Receiver.*


```solidity
function bridgeBurn(
  uint256 _chainId,
  uint256 _msgValue,
  bytes32 _assetId,
  address _originalCaller,
  bytes calldata _data
) external payable returns (bytes memory _bridgeMintData);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|the chainId that the message will be sent to|
|`_msgValue`|`uint256`|the msg.value of the L2 transaction. For now it is always 0.|
|`_assetId`|`bytes32`|the assetId of the asset being bridged|
|`_originalCaller`|`address`|the original caller of the|
|`_data`|`bytes`|the actual data specified for the function|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`_bridgeMintData`|`bytes`|The calldata used by counterpart asset handler to unlock tokens for recipient.|


## Events
### BridgeMint
*Emitted when a token is minted*


```solidity
event BridgeMint(
  uint256 indexed chainId,
  bytes32 indexed assetId,
  address receiver,
  uint256 amount
);
```

### BridgeBurn
*Emitted when a token is burned*


```solidity
event BridgeBurn(
  uint256 indexed chainId,
  bytes32 indexed assetId,
  address indexed sender,
  address receiver,
  uint256 amount
);
```

