# ICreate2Factory
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/a1506a91fd7e3b73aa6fe10caf12e32f39e26211/contracts/system-contracts/interfaces/ICreate2Factory.sol)

**Author:**
Matter Labs

The contract that can be used for deterministic contract deployment.

**Note:**
security-contact: security@matterlabs.dev


## Functions
### create2

Function that calls the `create2` method of the `ContractDeployer` contract.

*This function accepts the same parameters as the `create2` function of the ContractDeployer system contract,
so that we could efficiently relay the calldata.*


```solidity
function create2(bytes32, bytes32, bytes calldata)
  external
  payable
  returns (address);
```

### create2Account

Function that calls the `create2Account` method of the `ContractDeployer` contract.

*This function accepts the same parameters as the `create2Account` function of the ContractDeployer system contract,
so that we could efficiently relay the calldata.*


```solidity
function create2Account(
  bytes32,
  bytes32,
  bytes calldata,
  IContractDeployer.AccountAbstractionVersion
) external payable returns (address);
```

