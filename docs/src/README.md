<div align="center">

# 🛠️ ZKsync Contracts

*Canonical L1 & L2 contract interfaces for the ZKsync ecosystem*

[![NPM](https://img.shields.io/npm/v/@matterlabs/zksync-contracts)](https://www.npmjs.com/package/@matterlabs/zksync-contracts)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE-MIT)
[![Docs](https://img.shields.io/badge/docs-reference-blue)](https://docs.zksync.io)
[![X: @zksyncdevs](https://img.shields.io/badge/follow-@zksyncdevs-1DA1F2?logo=x)](https://x.com/zksyncdevs)

</div>

> **Snapshot notice**  
> These contracts target **protocol version 26**, commit [`6badcb8a`](https://github.com/matter-labs/era-contracts/commit/6badcb8a9b6114c6dd10d3b172a96812250604b0).  
> Verify against on-chain bytecode if you are using another network or version.

---

## 📦 Installation

To install with [**Foundry-ZKsync**](https://github.com/matter-labs/foundry-zksync):

```bash
forge install matter-labs/zksync-contracts
```

Add the following to the `remappings.txt` file of your project:

```txt
@matterlabs/zksync-contracts/=lib/v2-testnet-contracts/
```

To install with [**Hardhat**](https://github.com/matter-labs/hardhat-zksync):

```bash
bun install @matterlabs/zksync-contracts
```

## 🚀 Quick start

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IPaymaster} from
    "@matterlabs/zksync-contracts/contracts/system-contracts/interfaces/IPaymaster.sol";

contract MyPaymaster is IPaymaster {
    // Your implementation here
}
```

See more examples in the [official docs](https://docs.zksync.io).

## 📖 Documentation

* **API reference:** [https://docs.zksync.io](https://docs.zksync.io)
* **Canonical source:** [matter-labs/era-contracts](https://github.com/matter-labs/era-contracts) (this repo is a curated subset)

## 🤝 Contributing

Bug fixes, new snapshots, and added ABIs are welcome!
Open an issue before large changes and follow the standard PR workflow.

## 📜 License

Dual-licensed under **MIT** / **Apache-2.0**.
See [LICENSE-MIT](LICENSE-MIT) and [LICENSE-APACHE](LICENSE-APACHE).

<div align="center">

[Website](https://zksync.io) •
[GitHub](https://github.com/matter-labs) •
[X](https://x.com/zksync) •
[X for Devs](https://x.com/zksyncdevs) •
[Discord](https://join.zksync.dev) •
[Mirror](https://zksync.mirror.xyz)

</div>
