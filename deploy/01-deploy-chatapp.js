// function deployFunc(hre) {
//   console.log("Hi!");
//   hre.getNamedAccounts;
//   hre.deployments;
// }

// module.exports.default = deployFunc;

// module.exports async (hre) => {
//   const {getNamedAccounts, deployments} = hre;
// const { verify } = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("Deploying contract..................");
  const chatapp = await deploy("ChatApp", {
    from: deployer,
    args: [],
    log: true,
  });
  log(`Contract deployed at: ${chatapp.address}`);

  //   if (!(chainId == 31337) && process.env.ETHERSCAN_API_KEY) {
  //     //verify
  //     await verify(fundMe.address, [ethUsdPriceAddress]);
  //     log("Verified...........");
  //   }
};

module.exports.tags = ["all", "fund"];
