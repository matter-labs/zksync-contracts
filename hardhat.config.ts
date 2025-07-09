import '@matterlabs/hardhat-zksync';
import { HardhatUserConfig } from 'hardhat/config';

import * as dotenv from 'dotenv';
dotenv.config();

const isZKsync = process.env.USE_ZKSYNC === 'true';

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.24',
    settings: {
      evmVersion: 'cancun',
      optimizer: {
        enabled: true,
        runs: 9_999_999,
      },
    },
  },
  paths: {
    sources: process.env.HARDHAT_CONTRACTS_PATH || 'contracts',
    artifacts: 'artifacts',
    cache: 'cache',
  },
  networks: {
    hardhat: {
      zksync: isZKsync,
    },
  },
  zksolc: {
    version: '1.5.15',
    settings: {
      codegen: 'yul',
      suppressedWarnings: ['txorigin'],
    },
  },
};

export default config;
