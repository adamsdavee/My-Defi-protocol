require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      { version: "0.8.19" },
      { version: "0.8.20" },
      { version: "0.7.6" },
      { version: "0.5.16" },
      { version: "0.6.6" },
    ],
  },

  networks: {
    localhost: {
      url: "http://127.0.0.1:8545/",
      // accounts: Thanks hardhat!
      chainId: 31337,
      allowUnlimitedContractSize: true,
    },
  },

  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};
