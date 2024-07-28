module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("Deploying contract..................");
  const swapTokens = await deploy("SwapTokens", {
    from: deployer,
    args: [],
    log: true,
  });
  log(`Contract deployed at: ${swapTokens.address}`);

  //   if (!(chainId == 31337) && process.env.ETHERSCAN_API_KEY) {
  //     //verify
  //     await verify(fundMe.address, [ethUsdPriceAddress]);
  //     log("Verified...........");
  //   }
};

module.exports.tags = ["all", "fund"];
