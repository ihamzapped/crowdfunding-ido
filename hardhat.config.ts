import "./tasks";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";

import env from "dotenv";
import { HardhatUserConfig } from "hardhat/config";

env.config();

const config: HardhatUserConfig = {
  solidity: "0.8.18",

  paths: {
    // sources: "./contracts ./mocks",
  },

  networks: {
    fuji: {
      url: process.env.FUJI_RPC_URL,
      chainId: 43113,
      // accounts: { mnemonic: process.env.PRIVATE_KEY},
      accounts: [process.env.PRIVATE_KEY || ""],
    },
    mumbai: {
      url: process.env.MUMBAI_RPC_URL,
      chainId: 80001,
      accounts: [process.env.PRIVATE_KEY || ""],
    },
  },

  etherscan: {
    apiKey: {
      avalancheFujiTestnet: process.env.FUJI_API_KEY || "",
      polygonMumbai: process.env.MUMBAI_API_KEY || "",
    },
  },
};

export default config;
