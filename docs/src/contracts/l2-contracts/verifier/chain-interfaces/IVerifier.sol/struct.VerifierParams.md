# VerifierParams
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l2-contracts/verifier/chain-interfaces/IVerifier.sol)

Part of the configuration parameters of ZKP circuits


```solidity
struct VerifierParams {
  bytes32 recursionNodeLevelVkHash;
  bytes32 recursionLeafLevelVkHash;
  bytes32 recursionCircuitsSetVksHash;
}
```

