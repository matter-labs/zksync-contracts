# ICompressor
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/ICompressor.sol)

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

