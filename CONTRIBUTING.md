# Contribution Guidelines

Hello! Thanks for your interest in contributing. This repository is a **snapshot** of the canonical [era-contracts](https://github.com/matter-labs/era-contracts) repository, maintained by Matter Labs. It provides external contract **interfaces and helper libraries** intended for use as dependencies in dApps.

We welcome contributions—but please note that **source-of-truth development happens in `era-contracts`**. Changes made upstream will be reflected here through versioned snapshots.

## How to contribute

If you're looking to contribute, here’s what to keep in mind:

1. **Upstream first**: All functional changes (e.g., modifying interfaces, fixing logic, adding new contracts) should be proposed directly in the [canonical repo](https://github.com/matter-labs/era-contracts).
2. **Missing interfaces**: If an interface is already present in the canonical repo but missing here, feel free to open a PR to add it.
3. **Bug reports and issues**: If you notice inconsistencies or bugs specific to this repo, open an issue with relevant context.
4. **Security issues**: Please see [our security policy](./github/SECURITY.md) for responsible disclosure instructions.

## Making changes

To propose a change:

* Fork the repo.
* Make the update (limited to syncing existing upstream changes or fixing missing files).
* Submit a PR with a clear description and rationale.

Note: If your change modifies contract logic or structure, please open it in the [era-contracts](https://github.com/matter-labs/era-contracts) repository instead.

Here’s a [GitHub guide to working with PRs from forks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork).

## Licenses

All contributions to this project are made under both the [Apache 2.0](LICENSE-APACHE) and [MIT](LICENSE-MIT) licenses.

## Resources

Some helpful links:

* [Developer documentation](https://matter-labs.github.io/zksync-contracts/latest/)
* [ZKsync Docs](https://docs.zksync.io/)
* [README](./README.md)

## Code of Conduct

Please be kind, respectful, and constructive in all interactions.
