# Getting Started

1. **Add the package**

   ```bash
   # Hardhat / npm / bun
   npm add @matterlabs/zksync-contracts
   # or Foundry
   forge install matter-labs/zksync-contracts
   ````

2. **Implement a contract**

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.28;

   import {IPaymaster} from
       "@matterlabs/zksync-contracts/contracts/system-contracts/interfaces/IPaymaster.sol";

   contract MyPaymaster is IPaymaster {
       // implement paymaster logic here
   }
   ```

3. **Build & test**

   * Hardhat  `npx hardhat compile`
   * Foundry   `forge build`
