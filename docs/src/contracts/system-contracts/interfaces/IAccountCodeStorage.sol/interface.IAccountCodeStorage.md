# IAccountCodeStorage
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IAccountCodeStorage.sol)


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

