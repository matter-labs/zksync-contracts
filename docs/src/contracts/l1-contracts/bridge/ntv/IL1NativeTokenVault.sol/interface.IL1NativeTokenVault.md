# IL1NativeTokenVault
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/bridge/ntv/IL1NativeTokenVault.sol)

**Inherits:**
[INativeTokenVault](/contracts/l1-contracts/bridge/ntv/INativeTokenVault.sol/interface.INativeTokenVault.md), [IL1AssetDeploymentTracker](/contracts/l1-contracts/bridge/interfaces/IL1AssetDeploymentTracker.sol/interface.IL1AssetDeploymentTracker.md)

**Author:**
Matter Labs

The NTV is an Asset Handler for the L1AssetRouter to handle native tokens

**Note:**
security-contact: security@matterlabs.dev


## Functions
### L1_NULLIFIER

The L1Nullifier contract


```solidity
function L1_NULLIFIER() external view returns (IL1Nullifier);
```

### chainBalance

Returns the total number of specific tokens locked for some chain


```solidity
function chainBalance(uint256 _chainId, bytes32 _assetId)
  external
  view
  returns (uint256);
```

### registerEthToken

Registers ETH token


```solidity
function registerEthToken() external;
```

## Events
### TokenBeaconUpdated

```solidity
event TokenBeaconUpdated(address indexed l2TokenBeacon);
```

