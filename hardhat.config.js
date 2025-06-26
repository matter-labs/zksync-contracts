module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      evmVersion: "cancun",
      optimizer: {
        enabled: true,
        runs: 9999999,
      },
    },
  },
  paths: {
    sources: process.env.HARDHAT_CONTRACTS_PATH || "contracts",
    artifacts: "artifacts",
    cache: "cache",
  },
};
