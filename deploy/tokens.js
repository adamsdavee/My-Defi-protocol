module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("Deploying contract..................");
  const cherryToken = await deploy("CherryToken", {
    from: deployer,
    args: [],
    log: true,
  });
  const cherry = await ethers.getContractAt("CherryToken", cherryToken.address);
  await cherry.mint(ethers.parseEther("30"));
  log(`Contract deployed at: ${cherryToken.address}`);

  log("--------------------------------------------");
  log("Deploying contract..................");
  const appleToken = await deploy("AppleToken", {
    from: deployer,
    args: [],
    log: true,
  });
  const apple = await ethers.getContractAt("AppleToken", appleToken.address);

  await apple.mint(ethers.parseEther("30"));
  log(`Contract deployed at: ${appleToken.address}`);

  // log("Deploying contract..................");
  // const poolToken = await deploy("Pool", {
  //   from: deployer,
  //   args: [],
  //   log: true,
  // });
  // const pool = await ethers.getContractAt("Pool", poolToken.address);

  // // await pool.init(cherryToken.address, appleToken.address);
  // await pool.mint(deployer);
  // log(`Contract deployed at: ${poolToken.address}`);

  //   if (!(chainId == 31337) && process.env.ETHERSCAN_API_KEY) {
  //     //verify
  //     await verify(fundMe.address, [ethUsdPriceAddress]);
  //     log("Verified...........");
  //   }
};

module.exports.tags = ["all", "cherry"];
