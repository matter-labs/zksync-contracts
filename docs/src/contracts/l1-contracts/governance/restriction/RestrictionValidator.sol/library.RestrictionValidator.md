# RestrictionValidator
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/governance/restriction/RestrictionValidator.sol)

**Author:**
Matter Labs

The library which validates whether an address can be a valid restriction

**Note:**
security-contact: security@matterlabs.dev


## Functions
### validateRestriction

Ensures that the provided address implements the restriction interface

*Note that it *can not guarantee* that the corresponding address indeed implements
the interface completely or that it is implemented correctly. It is mainly used to
ensure that invalid restrictions can not be accidentally added.*


```solidity
function validateRestriction(address _restriction) internal view;
```

