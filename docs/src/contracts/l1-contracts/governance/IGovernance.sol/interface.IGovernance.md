# IGovernance
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/governance/IGovernance.sol)

**Author:**
Matter Labs

**Note:**
security-contact: security@matterlabs.dev


## Functions
### isOperation


```solidity
function isOperation(bytes32 _id) external view returns (bool);
```

### isOperationPending


```solidity
function isOperationPending(bytes32 _id) external view returns (bool);
```

### isOperationReady


```solidity
function isOperationReady(bytes32 _id) external view returns (bool);
```

### isOperationDone


```solidity
function isOperationDone(bytes32 _id) external view returns (bool);
```

### getOperationState


```solidity
function getOperationState(bytes32 _id) external view returns (OperationState);
```

### scheduleTransparent


```solidity
function scheduleTransparent(Operation calldata _operation, uint256 _delay)
  external;
```

### scheduleShadow


```solidity
function scheduleShadow(bytes32 _id, uint256 _delay) external;
```

### cancel


```solidity
function cancel(bytes32 _id) external;
```

### execute


```solidity
function execute(Operation calldata _operation) external payable;
```

### executeInstant


```solidity
function executeInstant(Operation calldata _operation) external payable;
```

### hashOperation


```solidity
function hashOperation(Operation calldata _operation)
  external
  pure
  returns (bytes32);
```

### updateDelay


```solidity
function updateDelay(uint256 _newDelay) external;
```

### updateSecurityCouncil


```solidity
function updateSecurityCouncil(address _newSecurityCouncil) external;
```

## Events
### TransparentOperationScheduled
Emitted when transparent operation is scheduled.


```solidity
event TransparentOperationScheduled(
  bytes32 indexed _id, uint256 delay, Operation _operation
);
```

### ShadowOperationScheduled
Emitted when shadow operation is scheduled.


```solidity
event ShadowOperationScheduled(bytes32 indexed _id, uint256 delay);
```

### OperationExecuted
Emitted when the operation is executed with delay or instantly.


```solidity
event OperationExecuted(bytes32 indexed _id);
```

### ChangeSecurityCouncil
Emitted when the security council address is changed.


```solidity
event ChangeSecurityCouncil(
  address _securityCouncilBefore, address _securityCouncilAfter
);
```

### ChangeMinDelay
Emitted when the minimum delay for future operations is modified.


```solidity
event ChangeMinDelay(uint256 _delayBefore, uint256 _delayAfter);
```

### OperationCancelled
Emitted when the operation with specified id is cancelled.


```solidity
event OperationCancelled(bytes32 indexed _id);
```

## Structs
### Operation
*Defines the structure of an operation that Governance executes.*


```solidity
struct Operation {
  Call[] calls;
  bytes32 predecessor;
  bytes32 salt;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`calls`|`Call[]`|An array of `Call` structs, each representing a call to be made during the operation.|
|`predecessor`|`bytes32`|The hash of the predecessor operation, that should be executed before this operation.|
|`salt`|`bytes32`|A bytes32 value used for creating unique operation hashes.|

## Enums
### OperationState
*This enumeration includes the following states:*


```solidity
enum OperationState {
  Unset,
  Waiting,
  Ready,
  Done
}
```

