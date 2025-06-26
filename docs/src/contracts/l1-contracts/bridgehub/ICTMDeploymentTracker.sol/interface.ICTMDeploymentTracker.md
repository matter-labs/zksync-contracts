# ICTMDeploymentTracker
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridgehub/ICTMDeploymentTracker.sol)

**Inherits:**
[IL1AssetDeploymentTracker](/contracts/l1-contracts/bridge/interfaces/IL1AssetDeploymentTracker.sol/interface.IL1AssetDeploymentTracker.md)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### bridgehubDeposit


```solidity
function bridgehubDeposit(
  uint256 _chainId,
  address _originalCaller,
  uint256 _l2Value,
  bytes calldata _data
) external payable returns (L2TransactionRequestTwoBridgesInner memory request);
```

### BRIDGE_HUB


```solidity
function BRIDGE_HUB() external view returns (IBridgehub);
```

### L1_ASSET_ROUTER


```solidity
function L1_ASSET_ROUTER() external view returns (IAssetRouterBase);
```

### registerCTMAssetOnL1


```solidity
function registerCTMAssetOnL1(address _ctmAddress) external;
```

### calculateAssetId


```solidity
function calculateAssetId(address _l1CTM) external view returns (bytes32);
```

