# L2CanonicalTransaction
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l1-contracts/common/Messaging.sol)

*Structure that includes all fields of the L2 transaction*

*The hash of this structure is the "canonical L2 transaction hash" and can
be used as a unique identifier of a tx*


```solidity
struct L2CanonicalTransaction {
  uint256 txType;
  uint256 from;
  uint256 to;
  uint256 gasLimit;
  uint256 gasPerPubdataByteLimit;
  uint256 maxFeePerGas;
  uint256 maxPriorityFeePerGas;
  uint256 paymaster;
  uint256 nonce;
  uint256 value;
  uint256[4] reserved;
  bytes data;
  bytes signature;
  uint256[] factoryDeps;
  bytes paymasterInput;
  bytes reservedDynamic;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`txType`|`uint256`|The tx type number, depending on which the L2 transaction can be interpreted differently|
|`from`|`uint256`|The sender's address. `uint256` type for possible address format changes and maintaining backward compatibility|
|`to`|`uint256`|The recipient's address. `uint256` type for possible address format changes and maintaining backward compatibility|
|`gasLimit`|`uint256`|The L2 gas limit for L2 transaction. Analog to the `gasLimit` on an L1 transactions|
|`gasPerPubdataByteLimit`|`uint256`|Maximum number of L2 gas that will cost one byte of pubdata (every piece of data that will be stored on L1 as calldata)|
|`maxFeePerGas`|`uint256`|The absolute maximum sender willing to pay per unit of L2 gas to get the transaction included in a Batch. Analog to the EIP-1559 `maxFeePerGas` on an L1 transactions|
|`maxPriorityFeePerGas`|`uint256`|The additional fee that is paid directly to the validator to incentivize them to include the transaction in a Batch. Analog to the EIP-1559 `maxPriorityFeePerGas` on an L1 transactions|
|`paymaster`|`uint256`|The address of the EIP-4337 paymaster, that will pay fees for the transaction. `uint256` type for possible address format changes and maintaining backward compatibility|
|`nonce`|`uint256`|The nonce of the transaction. For L1->L2 transactions it is the priority operation Id|
|`value`|`uint256`|The value to pass with the transaction|
|`reserved`|`uint256[4]`|The fixed-length fields for usage in a future extension of transaction formats|
|`data`|`bytes`|The calldata that is transmitted for the transaction call|
|`signature`|`bytes`|An abstract set of bytes that are used for transaction authorization|
|`factoryDeps`|`uint256[]`|The set of L2 bytecode hashes whose preimages were shown on L1|
|`paymasterInput`|`bytes`|The arbitrary-length data that is used as a calldata to the paymaster pre-call|
|`reservedDynamic`|`bytes`|The arbitrary-length field for usage in a future extension of transaction formats|

