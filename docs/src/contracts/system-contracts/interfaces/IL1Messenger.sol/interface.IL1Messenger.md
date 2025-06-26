# IL1Messenger
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/system-contracts/interfaces/IL1Messenger.sol)

**Author:**
Matter Labs

The interface of the L1 Messenger contract, responsible for sending messages to L1.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### sendToL1


```solidity
function sendToL1(bytes calldata _message) external returns (bytes32);
```

### sendL2ToL1Log


```solidity
function sendL2ToL1Log(bool _isService, bytes32 _key, bytes32 _value)
  external
  returns (uint256 logIdInMerkleTree);
```

### requestBytecodeL1Publication


```solidity
function requestBytecodeL1Publication(bytes32 _bytecodeHash) external;
```

## Events
### L1MessageSent

```solidity
event L1MessageSent(
  address indexed _sender, bytes32 indexed _hash, bytes _message
);
```

### L2ToL1LogSent

```solidity
event L2ToL1LogSent(L2ToL1Log _l2log);
```

### BytecodeL1PublicationRequested

```solidity
event BytecodeL1PublicationRequested(bytes32 _bytecodeHash);
```

