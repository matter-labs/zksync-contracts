# ICompressor
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/ICompressor.sol)

**Author:**
Matter Labs

The interface for the Compressor contract, responsible for verifying the correctness of
the compression of the state diffs and bytecodes.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### publishCompressedBytecode


```solidity
function publishCompressedBytecode(
  bytes calldata _bytecode,
  bytes calldata _rawCompressedData
) external returns (bytes32 bytecodeHash);
```

### verifyCompressedStateDiffs


```solidity
function verifyCompressedStateDiffs(
  uint256 _numberOfStateDiffs,
  uint256 _enumerationIndexSize,
  bytes calldata _stateDiffs,
  bytes calldata _compressedStateDiffs
) external returns (bytes32 stateDiffHash);
```

