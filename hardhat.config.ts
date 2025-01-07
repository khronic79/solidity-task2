import { HardhatUserConfig } from "hardhat/config";
import dotenv from "dotenv";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    amoy: {
      url: `https://polygon-amoy.infura.io/v3/6c3f5b8bc9e14265b21c4fbce8b51a26`,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 80002,
    },
 },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY,
    customChains: [
      {
        network: "amoy",
        chainId: 80002,
        urls: {
          apiURL: "https://api-amoy.polygonscan.com/api",
          browserURL: "https://amoy.polygonscan.com/"
        }
      }
    ]
},
};

export default config;
