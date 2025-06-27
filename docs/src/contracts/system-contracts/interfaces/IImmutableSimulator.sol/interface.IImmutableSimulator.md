# IImmutableSimulator
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/IImmutableSimulator.sol)


## Functions
### getImmutable


```solidity
function getImmutable(address _dest, uint256 _index)
  external
  view
  returns (bytes32);
```

### setImmutables


```solidity
function setImmutables(address _dest, ImmutableData[] calldata _immutables)
  external;
```

