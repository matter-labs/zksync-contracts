# IL2WrappedBaseToken
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IL2WrappedBaseToken.sol)


## Functions
### initializeV3

Initializes a contract token for later use. Expected to be used in the proxy.

This function is used to integrate the previously deployed WETH token with the bridge.

*Sets up `name`/`symbol`/`decimals` getters.*


```solidity
function initializeV3(
  string calldata name_,
  string calldata symbol_,
  address _l2Bridge,
  address _l1Address,
  bytes32 _baseTokenAssetId
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`name_`|`string`|The name of the token.|
|`symbol_`|`string`|The symbol of the token.|
|`_l2Bridge`|`address`|Address of the L2 bridge|
|`_l1Address`|`address`|Address of the L1 token that can be deposited to mint this L2 WETH. Note: The decimals are hardcoded to 18, the same as on Ether.|
|`_baseTokenAssetId`|`bytes32`||


