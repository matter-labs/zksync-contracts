# Release Process

This document outlines the automated release process for the `zksync-contracts` repo.  
The release process ensures that every change is systematically analyzed, documented, and packaged for distribution.

## Release Process Overview

1. **Triggering the Release Workflow**
    - Every merge to the `main` branch activates a special workflow.
    - This workflow uses the [`release-please` tool](https://github.com/googleapis/release-please) to analyze the commits.

2. **Commit Analysis and Release Candidate Creation**
    - The `release-please` tool scans for new conventional commits that meet the criteria for triggering a release.
    - If qualifying commits are found, the tool automatically creates a **Release Pull Request (PR)**. This PR includes:
        - An updated changelog detailing the new changes.
        - Updated `package.json` with the next release version.

3. **Review and Approval**
    - The Release PR must be reviewed and approved by the designated Release Manager.
    - Once approved, the PR is merged when the release is planned.

4. **Creating a New Release**
    - Upon merging the Release PR:
        - The workflow automatically creates a new GitHub tag and release corresponding to the new version.
        - The Release PR is marked as "released" and linked to the newly created release.
        - Merged PRs included in the release are also labeled with `released in version...`.

5. **Publishing to Registries**
    - The `release-please` workflow also triggers the `release.yaml` workflow.
    - This workflow:
        - Publishes the new version of the package to **npm**.
        - Publishes the new version to **Soldeer**.

6. **Release Completion**
    - With the npm and Soldeer packages published, the release is complete and available for distribution.

## Release Versioning

The `zksync-contracts` project follows [Semantic Versioning](https://semver.org/).

- Tags are created in the format `zksync-contracts-vX.Y.Z`.  
- Release tags correspond directly with the release tags of the implementation repo:  
  [matter-labs/era-contracts](https://github.com/matter-labs/era-contracts).

## Major Version Bumps

When bumping to a **new major version** (e.g., `28.x.x → 29.0.0`), create a dedicated commit to declare the release:

```bash
git commit -m "fix: release 29.0.0" -m "Release-As: 29.0.0"
```

This commit instructs `release-please` to treat the next release as version `29.0.0`, regardless of the calculated version from conventional commits.
This ensures alignment with the release cycle of the `era-contracts` repo.
