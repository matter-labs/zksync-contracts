# VerifierParams
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-interfaces/IVerifier.sol)

Part of the configuration parameters of ZKP circuits


```solidity
struct VerifierParams {
  bytes32 recursionNodeLevelVkHash;
  bytes32 recursionLeafLevelVkHash;
  bytes32 recursionCircuitsSetVksHash;
}
```

