# IL1AssetHandler
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/IL1AssetHandler.sol)

**Author:**
Matter Labs

Used for any asset handler and called by the L1AssetRouter

**Note:**
security-contact: security@matterlabs.dev


## Functions
### bridgeRecoverFailedTransfer


```solidity
function bridgeRecoverFailedTransfer(
  uint256 _chainId,
  bytes32 _assetId,
  address _depositSender,
  bytes calldata _data
) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chainId`|`uint256`|the chainId that the message will be sent to|
|`_assetId`|`bytes32`|the assetId of the asset being bridged|
|`_depositSender`|`address`|the address of the entity that initiated the deposit.|
|`_data`|`bytes`|the actual data specified for the function|


