# IL2ContractDeployer
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/common/interfaces/IL2ContractDeployer.sol)

**Author:**
Matter Labs

System smart contract that is responsible for deploying other smart contracts on a ZK chain.


## Functions
### forceDeployOnAddresses

This method is to be used only during an upgrade to set bytecodes on specific addresses.


```solidity
function forceDeployOnAddresses(ForceDeployment[] calldata _deployParams)
  external;
```

### create2

Deploys a contract with similar address derivation rules to the EVM's `CREATE2` opcode.


```solidity
function create2(bytes32 _salt, bytes32 _bytecodeHash, bytes calldata _input)
  external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_salt`|`bytes32`|The create2 salt.|
|`_bytecodeHash`|`bytes32`|The correctly formatted hash of the bytecode.|
|`_input`|`bytes`|The constructor calldata.|


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

