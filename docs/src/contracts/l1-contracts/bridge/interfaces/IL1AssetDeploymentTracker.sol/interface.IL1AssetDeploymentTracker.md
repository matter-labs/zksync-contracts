# IL1AssetDeploymentTracker
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/bridge/interfaces/IL1AssetDeploymentTracker.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### bridgeCheckCounterpartAddress


```solidity
function bridgeCheckCounterpartAddress(
  uint256 _chainId,
  bytes32 _assetId,
  address _originalCaller,
  address _assetHandlerAddressOnCounterpart
) external view;
```

