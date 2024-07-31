module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("Deploying contract..................");
  const factory = await deploy("Factory", {
    from: deployer,
    args: ["0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"],
    log: true,
  });
  log(`Contract deployed at: ${factory.address}`);

  //   if (!(chainId == 31337) && process.env.ETHERSCAN_API_KEY) {
  //     //verify
  //     await verify(fundMe.address, [ethUsdPriceAddress]);
  //     log("Verified...........");
  //   }
};

module.exports.tags = ["all", "factory"];
