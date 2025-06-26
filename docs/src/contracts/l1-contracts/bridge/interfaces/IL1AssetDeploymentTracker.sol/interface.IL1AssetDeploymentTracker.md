# IL1AssetDeploymentTracker
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/interfaces/IL1AssetDeploymentTracker.sol)

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

