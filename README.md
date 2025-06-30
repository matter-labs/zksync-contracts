<div align="center">

<h1>
  <picture>
    <source srcset=".github/assets/elastic_white.svg" media="(prefers-color-scheme: dark)" />
    <img src=".github/assets/elastic_black.svg" alt="ZKsync" width="32" style="vertical-align: middle;">
  </picture>
  ZKsync Contracts
</h1>

*Canonical L1 & L2 contract interfaces for the ZKsync Elastic Network*

[![NPM](https://img.shields.io/npm/v/@matterlabs/zksync-contracts)](https://www.npmjs.com/package/@matterlabs/zksync-contracts)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE-MIT)
[![Docs](https://img.shields.io/badge/docs-reference-blue)](https://matter-labs.github.io/zksync-contracts/latest/)
[![X: @zksyncdevs](https://img.shields.io/badge/follow-@zksyncdevs-1DA1F2?logo=x)](https://x.com/zksyncdevs)

</div>

> **Snapshot notice**  
> These contracts target **protocol version 28**, commit [`9fcd2823`](https://github.com/matter-labs/era-contracts/commit/9fcd28238cf749462b22e513a9f545008637f301).

> [!NOTE]
> 🛠️ This is a **development repository** for _interfaces only_.  
> If you're looking for **contract implementations**, see  
> 👉 [matter-labs/era-contracts](https://github.com/matter-labs/era-contracts/tree/release-v28)

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

## 📖 Documentation

* **Interface & Library Docs**
  [Solidity interfaces and helper libraries](https://matter-labs.github.io/zksync-contracts/latest/)

* **System Contract Specifications**
  [Core system contract specs](https://matter-labs.github.io/zksync-era/core/latest/specs/contracts/index.html)

* **Source Repository**
  [GitHub – matter-labs/era-contracts](https://github.com/matter-labs/era-contracts/tree/release-v28)

* **ZKsync Docs**
  [docs.zksync.io](https://docs.zksync.io)

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
