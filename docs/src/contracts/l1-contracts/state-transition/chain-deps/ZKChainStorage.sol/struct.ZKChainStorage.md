# ZKChainStorage
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/state-transition/chain-deps/ZKChainStorage.sol)

*storing all storage variables for ZK chain diamond facets
NOTE: It is used in a proxy, so it is possible to add new variables to the end
but NOT to modify already existing variables or change their order.
NOTE: variables prefixed with '__DEPRECATED_' are deprecated and shouldn't be used.
Their presence is maintained for compatibility and to prevent storage collision.*


```solidity
struct ZKChainStorage {
  uint256[7] __DEPRECATED_diamondCutStorage;
  address __DEPRECATED_governor;
  address __DEPRECATED_pendingGovernor;
  mapping(address validatorAddress => bool isValidator) validators;
  IVerifier verifier;
  uint256 totalBatchesExecuted;
  uint256 totalBatchesVerified;
  uint256 totalBatchesCommitted;
  mapping(uint256 batchNumber => bytes32 batchHash) storedBatchHashes;
  mapping(uint256 batchNumber => bytes32 l2LogsRootHash) l2LogsRootHashes;
  PriorityQueue.Queue priorityQueue;
  address __DEPRECATED_allowList;
  VerifierParams __DEPRECATED_verifierParams;
  bytes32 l2BootloaderBytecodeHash;
  bytes32 l2DefaultAccountBytecodeHash;
  bool zkPorterIsAvailable;
  uint256 priorityTxMaxGasLimit;
  UpgradeStorage __DEPRECATED_upgrades;
  mapping(
    uint256 l2BatchNumber
      => mapping(uint256 l2ToL1MessageNumber => bool isFinalized)
  ) isEthWithdrawalFinalized;
  uint256 __DEPRECATED_lastWithdrawalLimitReset;
  uint256 __DEPRECATED_withdrawnAmountInWindow;
  mapping(address => uint256) __DEPRECATED_totalDepositedAmountPerUser;
  uint256 protocolVersion;
  bytes32 l2SystemContractsUpgradeTxHash;
  uint256 l2SystemContractsUpgradeBatchNumber;
  address admin;
  address pendingAdmin;
  FeeParams feeParams;
  address blobVersionedHashRetriever;
  uint256 chainId;
  address bridgehub;
  address chainTypeManager;
  address __DEPRECATED_baseToken;
  address __DEPRECATED_baseTokenBridge;
  uint128 baseTokenGasPriceMultiplierNominator;
  uint128 baseTokenGasPriceMultiplierDenominator;
  address transactionFilterer;
  address l1DAValidator;
  address l2DAValidator;
  bytes32 baseTokenAssetId;
  address settlementLayer;
  PriorityTree.Tree priorityTree;
  bool isPermanentRollup;
}
```

