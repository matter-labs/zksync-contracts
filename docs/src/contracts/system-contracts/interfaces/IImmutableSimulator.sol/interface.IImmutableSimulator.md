# IImmutableSimulator
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IImmutableSimulator.sol)


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

