# ChainTypeManagerInitializeData
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/IChainTypeManager.sol)

Struct that holds all data needed for initializing CTM Proxy.

*We use struct instead of raw parameters in `initialize` function to prevent "Stack too deep" error*


```solidity
struct ChainTypeManagerInitializeData {
  address owner;
  address validatorTimelock;
  ChainCreationParams chainCreationParams;
  uint256 protocolVersion;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`owner`|`address`|The address who can manage non-critical updates in the contract|
|`validatorTimelock`|`address`|The address that serves as consensus, i.e. can submit blocks to be processed|
|`chainCreationParams`|`ChainCreationParams`|The struct that contains the fields that define how a new chain should be created|
|`protocolVersion`|`uint256`|The initial protocol version on the newly deployed chain|

