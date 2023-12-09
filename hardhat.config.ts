import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { config as dotenvConfig } from "dotenv";

dotenvConfig();

const INFURA_API_KEY="6ef3994d93bf46cabd0d4dba91a2df7a";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "";

const POLYGON_ZKEVM = "https://rpc.public.zkevm-test.net";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
      },
    },
  },
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY]
    },
    zkEVM_testnet: {
      url: `${POLYGON_ZKEVM}`,
      accounts: [PRIVATE_KEY]
    },
    linea_testnet: {
      url: `https://linea-goerli.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
  }
};

export default config;
