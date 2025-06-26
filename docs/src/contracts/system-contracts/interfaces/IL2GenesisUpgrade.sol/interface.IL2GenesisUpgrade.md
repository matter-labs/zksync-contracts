# IL2GenesisUpgrade
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IL2GenesisUpgrade.sol)


## Functions
### genesisUpgrade


```solidity
function genesisUpgrade(
  uint256 _chainId,
  address _ctmDeployer,
  bytes calldata _fixedForceDeploymentsData,
  bytes calldata _additionalForceDeploymentsData
) external payable;
```

## Events
### UpgradeComplete

```solidity
event UpgradeComplete(uint256 _chainId);
```

