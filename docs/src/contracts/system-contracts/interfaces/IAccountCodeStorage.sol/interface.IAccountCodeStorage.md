# IAccountCodeStorage
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IAccountCodeStorage.sol)


## Functions
### storeAccountConstructingCodeHash


```solidity
function storeAccountConstructingCodeHash(address _address, bytes32 _hash)
  external;
```

### storeAccountConstructedCodeHash


```solidity
function storeAccountConstructedCodeHash(address _address, bytes32 _hash)
  external;
```

### markAccountCodeHashAsConstructed


```solidity
function markAccountCodeHashAsConstructed(address _address) external;
```

### getRawCodeHash


```solidity
function getRawCodeHash(address _address)
  external
  view
  returns (bytes32 codeHash);
```

### getCodeHash


```solidity
function getCodeHash(uint256 _input) external view returns (bytes32 codeHash);
```

### getCodeSize


```solidity
function getCodeSize(uint256 _input) external view returns (uint256 codeSize);
```

