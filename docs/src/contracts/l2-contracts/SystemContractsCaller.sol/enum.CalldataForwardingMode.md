# CalldataForwardingMode
[Git Source](https://github.com/matter-labs/zksync-contracts/blob/c6e73735b89a4b474234f6471e326125c9069f15/contracts/l2-contracts/SystemContractsCaller.sol)

The way to forward the calldata:
- Use the current heap (i.e. the same as on EVM).
- Use the auxiliary heap.
- Forward via a pointer

*Note, that currently, users do not have access to the auxiliary
heap and so the only type of forwarding that will be used by the users
are UseHeap and ForwardFatPointer for forwarding a slice of the current calldata
to the next call.*


```solidity
enum CalldataForwardingMode {
  UseHeap,
  ForwardFatPointer,
  UseAuxHeap
}
```

