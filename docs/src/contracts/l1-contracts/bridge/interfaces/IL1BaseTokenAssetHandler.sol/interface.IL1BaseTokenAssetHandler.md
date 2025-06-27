# IL1BaseTokenAssetHandler
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/interfaces/IL1BaseTokenAssetHandler.sol)

**Author:**
Matter Labs

Used for any asset handler and called by the L1AssetRouter

**Note:**
security-contact: security@matterlabs.dev


## Functions
### tokenAddress

Used to get the token address of an assetId


```solidity
function tokenAddress(bytes32 _assetId) external view returns (address);
```

