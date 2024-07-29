module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("Deploying contract..................");
  const cherryToken = await deploy("CherryToken", {
    from: deployer,
    args: [],
    log: true,
  });
  log(`Contract deployed at: ${cherryToken.address}`);

  log("--------------------------------------------");
  log("Deploying contract..................");
  const appleToken = await deploy("AppleToken", {
    from: deployer,
    args: [],
    log: true,
  });
  log(`Contract deployed at: ${appleToken.address}`);

  //   if (!(chainId == 31337) && process.env.ETHERSCAN_API_KEY) {
  //     //verify
  //     await verify(fundMe.address, [ethUsdPriceAddress]);
  //     log("Verified...........");
  //   }
};

module.exports.tags = ["all", "cherry"];
