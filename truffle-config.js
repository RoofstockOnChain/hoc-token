const HDWalletProvider = require("@truffle/hdwallet-provider");
require("dotenv").config();

module.exports = {
  compilers: {
    solc: {
      version: "^0.8.4",
    },
  },
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    rinkeby: {
      provider: function () {
        return new HDWalletProvider(
          `${process.env.MNEMONIC}`,
          `https://rinkeby.infura.io/v3/${process.env.INFURA_ID}`
        );
      },
      network_id: 4,
    },
    mainnet: {
      provider: function () {
        return new HDWalletProvider(
          `${process.env.MNEMONIC}`,
          `https://mainnet.infura.io/v3/${process.env.INFURA_ID}`
        );
      },
      network_id: 1,
    }
  },
  plugins: ["truffle-plugin-verify"],
  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY,
  },
};
