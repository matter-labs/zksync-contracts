import { HardhatUserConfig } from 'hardhat/config';

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
};

export default config;
