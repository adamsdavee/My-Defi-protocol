module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  const args = [
    "0x5FbDB2315678afecb367f032d93F642f64180aa3",
    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
  ];

  log("Deploying contract..................");
  const router = await deploy("LiquidityProvider", {
    from: deployer,
    args: args,
    log: true,
  });
  log(`Contract deployed at: ${router.address}`);

  //   if (!(chainId == 31337) && process.env.ETHERSCAN_API_KEY) {
  //     //verify
  //     await verify(fundMe.address, [ethUsdPriceAddress]);
  //     log("Verified...........");
  //   }
};

module.exports.tags = ["all", "router"];
