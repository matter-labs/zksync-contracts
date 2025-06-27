# IKnownCodesStorage
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IKnownCodesStorage.sol)

**Author:**
Matter Labs

The interface for the KnownCodesStorage contract, which is responsible
for storing the hashes of the bytecodes that have been published to the network.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### markFactoryDeps


```solidity
function markFactoryDeps(bool _shouldSendToL1, bytes32[] calldata _hashes)
  external;
```

### markBytecodeAsPublished


```solidity
function markBytecodeAsPublished(bytes32 _bytecodeHash) external;
```

### getMarker


```solidity
function getMarker(bytes32 _hash) external view returns (uint256);
```

## Events
### MarkedAsKnown

```solidity
event MarkedAsKnown(
  bytes32 indexed bytecodeHash, bool indexed sendBytecodeToL1
);
```

