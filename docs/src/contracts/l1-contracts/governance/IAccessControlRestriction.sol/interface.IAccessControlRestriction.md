# IAccessControlRestriction
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/governance/IAccessControlRestriction.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Events
### RoleSet
Emitted when the required role for a specific function is set.


```solidity
event RoleSet(
  address indexed target, bytes4 indexed selector, bytes32 requiredRole
);
```

### FallbackRoleSet
Emitted when the required role for a fallback function is set.


```solidity
event FallbackRoleSet(address indexed target, bytes32 requiredRole);
```

