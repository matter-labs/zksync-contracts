# UpgradeStorage
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/state-transition/chain-deps/ZKChainStorage.sol)

*Logically separated part of the storage structure, which is responsible for everything related to proxy
upgrades and diamond cuts*


```solidity
struct UpgradeStorage {
  bytes32 proposedUpgradeHash;
  UpgradeState state;
  address securityCouncil;
  bool approvedBySecurityCouncil;
  uint40 proposedUpgradeTimestamp;
  uint40 currentProposalId;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`proposedUpgradeHash`|`bytes32`|The hash of the current upgrade proposal, zero if there is no active proposal|
|`state`|`UpgradeState`|Indicates whether an upgrade is initiated and if yes what type|
|`securityCouncil`|`address`|Address which has the permission to approve instant upgrades (expected to be a Gnosis multisig)|
|`approvedBySecurityCouncil`|`bool`|Indicates whether the security council has approved the upgrade|
|`proposedUpgradeTimestamp`|`uint40`|The timestamp when the upgrade was proposed, zero if there are no active proposals|
|`currentProposalId`|`uint40`|The serial number of proposed upgrades, increments when proposing a new one|

