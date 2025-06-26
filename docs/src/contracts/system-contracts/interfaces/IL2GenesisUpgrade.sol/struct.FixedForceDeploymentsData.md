# FixedForceDeploymentsData
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IL2GenesisUpgrade.sol)

THe structure that describes force deployments that are the same for each chain.

*Note, that for simplicity, the same struct is used both for upgrading to the
Gateway version and for the Genesis. Some fields may not be used in either of those.*


```solidity
struct FixedForceDeploymentsData {
  uint256 l1ChainId;
  uint256 eraChainId;
  address l1AssetRouter;
  bytes32 l2TokenProxyBytecodeHash;
  address aliasedL1Governance;
  uint256 maxNumberOfZKChains;
  bytes32 bridgehubBytecodeHash;
  bytes32 l2AssetRouterBytecodeHash;
  bytes32 l2NtvBytecodeHash;
  bytes32 messageRootBytecodeHash;
  address l2SharedBridgeLegacyImpl;
  address l2BridgedStandardERC20Impl;
  address dangerousTestOnlyForcedBeacon;
}
```

