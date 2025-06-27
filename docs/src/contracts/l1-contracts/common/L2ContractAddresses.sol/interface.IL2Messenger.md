# IL2Messenger
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/l1-contracts/common/L2ContractAddresses.sol)

**Author:**
Matter Labs

Smart contract for sending arbitrary length messages to L1

*by default ZkSync can send fixed-length messages on L1.
A fixed length message has 4 parameters `senderAddress`, `isService`, `key`, `value`,
the first one is taken from the context, the other three are chosen by the sender.*

*To send a variable-length message we use this trick:
- This system contract accepts an arbitrary length message and sends a fixed length message with
parameters `senderAddress == this`, `isService == true`, `key == msg.sender`, `value == keccak256(message)`.
- The contract on L1 accepts all sent messages and if the message came from this system contract
it requires that the preimage of `value` be provided.*

**Note:**
security-contact: security@matterlabs.dev


## Functions
### sendToL1

Sends an arbitrary length message to L1.


```solidity
function sendToL1(bytes calldata _message) external returns (bytes32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_message`|`bytes`|The variable length message to be sent to L1.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|Returns the keccak256 hashed value of the message.|


