# IPermanentRestriction
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/governance/IPermanentRestriction.sol)

**Author:**
Matter Labs

The interface for the permanent restriction contract.

**Note:**
security-contact: security@matterlabs.dev


## Events
### AdminImplementationAllowed
Emitted when the implementation is allowed or disallowed.


```solidity
event AdminImplementationAllowed(
  bytes32 indexed implementationHash, bool isAllowed
);
```

### AllowedDataChanged
Emitted when a certain calldata is allowed or disallowed.


```solidity
event AllowedDataChanged(bytes data, bool isAllowed);
```

### SelectorValidationChanged
Emitted when the selector is labeled as validated or not.


```solidity
event SelectorValidationChanged(bytes4 indexed selector, bool isValidated);
```

### AllowL2Admin
Emitted when the L2 admin is whitelisted or not.


```solidity
event AllowL2Admin(address indexed adminAddress);
```

