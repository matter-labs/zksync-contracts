# ZKsync Contracts

[![Logo](https://raw.githubusercontent.com/matter-labs/v2-testnet-contracts/beta/logo.svg)](https://zksync.io)

> [!WARNING]
> This project is provided on the best effort basis and might not accurately reflect contracts that are deployed on any particular ZK chain. Proper source of truth is still [era-contracts](https://github.com/matter-labs/era-contracts)

This package contains lightweight subset of ZKsync L1, L2 and system contracts that we consider to be publicly facing. For more details see [era-contracts](https://github.com/matter-labs/era-contracts).


> [!IMPORTANT]
> Current contract snapshot was made for protocol version 26 as taken from commit [6badcb8a9b6114c6dd10d3b172a96812250604b0](https://github.com/matter-labs/era-contracts/commit/6badcb8a9b6114c6dd10d3b172a96812250604b0)

## Installation

### Hardhat

```bash
yarn add @matterlabs/zksync-contracts@beta
```

### Foundry

```bash
forge install matter-labs/v2-testnet-contracts@beta
```

Add the following to the `remappings.txt` file of your project:

```txt
@matterlabs/zksync-contracts/=lib/v2-testnet-contracts/
```

## Usage

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IPaymaster} from "@matterlabs/zksync-contracts/contracts/system-contracts/interfaces/IPaymaster.sol";

contract MyPaymaster is IPaymaster {
     // IMPLEMENTATION
}
```

You can find a lot of useful examples in the [ZKsync docs](https://docs.zksync.io).

## License

ZKsync Contracts are distributed under the terms of the MIT license.

See [LICENSE-MIT](LICENSE-MIT) for details.

## Official Links

- [Website](https://zksync.io)
- [GitHub](https://github.com/matter-labs)
- [ZK Credo](https://github.com/zksync/credo)
- [X](https://x.com/zksync)
- [X for Devs](https://x.com/zksyncdevs)
- [Discord](https://join.zksync.dev)
- [Mirror](https://zksync.mirror.xyz)
