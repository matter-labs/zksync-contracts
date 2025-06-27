# SystemLogKey
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-interfaces/IExecutor.sol)

*Enum used by L2 System Contracts to differentiate logs.*


```solidity
enum SystemLogKey {
  L2_TO_L1_LOGS_TREE_ROOT_KEY,
  PACKED_BATCH_AND_L2_BLOCK_TIMESTAMP_KEY,
  CHAINED_PRIORITY_TXN_HASH_KEY,
  NUMBER_OF_LAYER_1_TXS_KEY,
  PREV_BATCH_HASH_KEY,
  L2_DA_VALIDATOR_OUTPUT_HASH_KEY,
  USED_L2_DA_VALIDATOR_ADDRESS_KEY,
  EXPECTED_SYSTEM_CONTRACT_UPGRADE_TX_HASH_KEY
}
```

