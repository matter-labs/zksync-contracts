# IAccessControlRestriction
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/governance/IAccessControlRestriction.sol)

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

