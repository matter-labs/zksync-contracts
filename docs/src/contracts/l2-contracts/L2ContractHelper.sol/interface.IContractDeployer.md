# IContractDeployer
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l2-contracts/L2ContractHelper.sol)

**Author:**
Matter Labs

Interface for the contract that is used to deploy contracts on L2.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### forceDeployOnAddresses

This method is to be used only during an upgrade to set bytecodes on specific addresses.


```solidity
function forceDeployOnAddresses(ForceDeployment[] calldata _deployParams)
  external
  payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_deployParams`|`ForceDeployment[]`|A set of parameters describing force deployment.|


### create2

Creates a new contract at a determined address using the `CREATE2` salt on L2


```solidity
function create2(bytes32 _salt, bytes32 _bytecodeHash, bytes calldata _input)
  external
  returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_salt`|`bytes32`|a unique value to create the deterministic address of the new contract|
|`_bytecodeHash`|`bytes32`|the bytecodehash of the new contract to be deployed|
|`_input`|`bytes`|the calldata to be sent to the constructor of the new contract|


### getNewAddressCreate2

Calculates the address of a create2 contract deployment


```solidity
function getNewAddressCreate2(
  address _sender,
  bytes32 _bytecodeHash,
  bytes32 _salt,
  bytes calldata _input
) external view returns (address newAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_sender`|`address`|The address of the sender.|
|`_bytecodeHash`|`bytes32`|The bytecode hash of the new contract to be deployed.|
|`_salt`|`bytes32`|a unique value to create the deterministic address of the new contract|
|`_input`|`bytes`|the calldata to be sent to the constructor of the new contract|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`newAddress`|`address`|The derived address of the account.|


## Structs
### ForceDeployment
A struct that describes a forced deployment on an address.


```solidity
struct ForceDeployment {
  bytes32 bytecodeHash;
  address newAddress;
  bool callConstructor;
  uint256 value;
  bytes input;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`bytecodeHash`|`bytes32`|The bytecode hash to put on an address.|
|`newAddress`|`address`|The address on which to deploy the bytecodehash to.|
|`callConstructor`|`bool`|Whether to run the constructor on the force deployment.|
|`value`|`uint256`|The `msg.value` with which to initialize a contract.|
|`input`|`bytes`|The constructor calldata.|

