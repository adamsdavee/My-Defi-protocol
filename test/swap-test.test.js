const { getNamedAccounts, deployments, ethers } = require("hardhat");
const { assert, expect } = require("chai");

describe("NftMarketplace", function () {
  let factory,
    deployer,
    accounts,
    cherry,
    apple,
    router,
    cherryContract,
    appleContract,
    rout;

  beforeEach(async function () {
    accounts = await ethers.getSigners();
    deployer = (await getNamedAccounts()).deployer;
    player = accounts[1];

    // await deployments.fixture(["all"]);

    const fact = await deployments.get("PoolFactory", deployer);
    factory = await ethers.getContractAt("PoolFactory", fact.address);

    rout = await deployments.get("LiquidityProvider", deployer);
    router = await ethers.getContractAt("LiquidityProvider", rout.address);
    // console.log(rout.address);

    cherry = await deployments.get("CherryToken", deployer);
    cherryContract = await ethers.getContractAt("CherryToken", cherry.address);
    apple = await deployments.get("AppleToken", deployer);
    appleContract = await ethers.getContractAt("AppleToken", apple.address);

    console.log(await cherryContract.balanceOf(deployer));
    await cherryContract.approve(rout.address, ethers.parseEther("10"));
    await appleContract.approve(rout.address, ethers.parseEther("10"));
    console.log(await cherryContract.allowance(deployer, rout.address));
    console.log(await appleContract.allowance(deployer, rout.address));
    console.log("Done!");
  });

  describe("Test Factory", function () {
    it("checks if its creates pair", async function () {
      const pairAddress = await factory.getTokenPairs(
        cherry.address,
        apple.address
      );
      // console.log(pair);
      console.log(pairAddress);
      const pair = await factory.createPool(cherry.address, apple.address);
      // const pairLength = await factory.allTokenPairs();
      // console.log(pairLength);
      // console.log(await cherryContract.balanceOf(deployer));
      // console.log(pairLength);
    });
    it("checks if its adds liquidity", async function () {
      console.log("heyy");
      console.log(await appleContract.balanceOf(rout.address));
      console.log(await appleContract.balanceOf(rout.address));
      console.log(await cherryContract.balanceOf(rout.address));
      const pair = await router.addLiquidity(
        cherry.address,
        apple.address,
        ethers.parseEther("1.5"),
        ethers.parseEther("1"),
        ethers.parseEther(".9"),
        ethers.parseEther("1.3")
      );
      console.log(pair);
    });

    it.only("swaps", async function () {
      console.log("Hiiiiiiii");
      const pairAddress = await factory.getTokenPairs(
        cherry.address,
        apple.address
      );
      // console.log(pair);
      console.log(pairAddress);
      // console.log(await cherryContract.balanceOf(pairAddress));
      // console.log(await appleContract.balanceOf(pairAddress));
      // const pair = await router.addLiquidity(
      //   cherry.address,
      //   apple.address,
      //   ethers.parseEther("4"),
      //   ethers.parseEther("4"),
      //   ethers.parseEther("3.8"),
      //   ethers.parseEther("3.8")
      // );
      // console.log(pair);
      console.log(await cherryContract.balanceOf(pairAddress));
      console.log(await appleContract.balanceOf(pairAddress));
      console.log("I made it here");
      // console.log(pair);
      console.log("Getting amounts.....");
      const path = [apple.address, cherry.address];
      const amountOut = await router.getAmountsOut(
        pairAddress,
        ethers.parseEther(".4"),
        path
      );
      console.log(amountOut);

      const tokenOut = await router.swapExactTokensForTokens(
        ethers.parseEther(".4"),
        ethers.parseEther(".1"),
        path
      );
      // console.log(tokenOut);
      console.log("Sappedddd");
      console.log(await cherryContract.balanceOf(pairAddress));
      console.log(await appleContract.balanceOf(pairAddress));
    });
    // it("reverts if item has been listed", async function () {
    //   await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
    //   const error = `NftMarketplace__AlreadyListed("${basicNft.target}", ${TOKEN_ID})`;
    //   console.log(error);

    //   expect(
    //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE)
    //   ).to.be.revertedWithCustomError(nftMarketplace, error);
    // });
    // it("allows only owner to list the NFT", async function () {
    //   const newContract = await nftMarketplace.connect(player);
    //   expect(
    //     await newContract.listItem(basicNft.target, TOKEN_ID, PRICE)
    //   ).to.be.revertedWithCustomError(newContract, "NftMarketplace__NotOwner");
    // });
    // it("needs approval to list items", async function () {
    //   await basicNft.approve(player.address, TOKEN_ID);
    //   expect(
    //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE)
    //   ).to.be.revertedWithCustomError(
    //     nftMarketplace,
    //     "NftMarketplace__NotApprovedForMarketplace"
    //   );
    // });
    // it("updates listing with seller and price", async function () {
    //   await basicNft.approve(nftMarketplace.target, TOKEN_ID);
    //   await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
    //   const listing = await nftMarketplace.getListing(
    //     basicNft.target,
    //     TOKEN_ID
    //   );
    //   assert(listing.price == PRICE);
    //   assert(listing.seller == deployer);
    // });
    // it("reverts if price is <= 0", async function () {
    //   expect(
    //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, 0)
    //   ).to.be.revertedWithCustomError(
    //     nftMarketplace,
    //     "NftMarketplace__PriceMustBeAboveZero"
    //   );
    // });
  });

  // describe("cancelListing", function () {
  //   it("reverts if there is no listing", async function () {
  //     const error = `NftMarketplace__AlreadyListed("${basicNft.target}", ${TOKEN_ID})`;
  //     expect(
  //       await nftMarketplace.cancelListing(basicNft.target, TOKEN_ID)
  //     ).to.be.revertedWithCustomError(nftMarketplace, error);
  //   });
  //   it("reverts if anyone but the owner tries to call it", async function () {
  //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
  //     const newContract = await nftMarketplace.connect(player);
  //     expect(
  //       await newContract.cancelListing(basicNft.target, TOKEN_ID)
  //     ).to.be.revertedWithCustomError(newContract, "NftMarketplace__NotOwner");
  //   });
  //   it("emits an event and removes listing", async function () {
  //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
  //     expect(
  //       await nftMarketplace.cancelListing(basicNft.target, TOKEN_ID)
  //     ).to.emit(nftMarketplace, "ItemCanceled");
  //     const listing = await nftMarketplace.getListing(
  //       basicNft.target,
  //       TOKEN_ID
  //     );
  //     assert(listing.price == 0);
  //   });
  // });

  // describe("buyItem", function () {
  //   it("reverts if the item isn't listed", async function () {
  //     const error = `NftMarketplace__AlreadyListed("${basicNft.target}", ${TOKEN_ID})`;
  //     expect(
  //       await nftMarketplace.buyItem(basicNft.target, TOKEN_ID)
  //     ).to.be.revertedWithCustomError(nftMarketplace, error);
  //   });
  //   it("reverts if price is not met", async function () {
  //     const error = `NftMarketplace__PriceNotMet("${basicNft.target}", ${TOKEN_ID}, ${PRICE})`;
  //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
  //     expect(
  //       await nftMarketplace.buyItem(basicNft.target, TOKEN_ID)
  //     ).to.be.revertedWithCustomError(nftMarketplace, error);
  //   });
  //   it("transfers nft to the buyer and updates internal proceeds records", async function () {
  //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
  //     const newUser = await nftMarketplace.connect(player);
  //     expect(
  //       await newUser.buyItem(basicNft.target, TOKEN_ID, { value: PRICE })
  //     ).to.emit(newUser, "ItemBought");
  //     const proceeds = await newUser.getProceeds(deployer);
  //     const owner = await basicNft.ownerOf(TOKEN_ID);
  //     assert.equal(proceeds, PRICE);
  //     assert.equal(owner, player.address);
  //   });
  // });

  // describe("Update listing", function () {
  //   it("must be owner and listed", async function () {
  //     const error = ` NftMarketplace__NotListed("${basicNft.target}, ${TOKEN_ID})`;
  //     expect(
  //       await nftMarketplace.updateListing(basicNft.target, TOKEN_ID, PRICE)
  //     ).to.be.revertedWith(newUser, error);
  //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
  //     const newUser = nftMarketplace.connect(player);
  //     expect(
  //       await newUser.updateListing(basicNft.target, TOKEN_ID, PRICE)
  //     ).to.be.revertedWithCustomError(newUser, "NftMarketplace__NotOwner");
  //   });
  //   it("reverts if new price is <= 0", async function () {
  //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
  //     expect(
  //       await nftMarketplace.updateListing(basicNft.target, TOKEN_ID, 0)
  //     ).to.be.revertedWithCustomError(
  //       nftMarketplace,
  //       "NftMarketplace__PriceMustBeAboveZero"
  //     );
  //   });
  //   it("updates price of the item", async function () {
  //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
  //     const updatedPrice = ethers.parseEther("0.6");
  //     await nftMarketplace.updateListing(
  //       basicNft.target,
  //       TOKEN_ID,
  //       updatedPrice
  //     );

  //     const listing = await nftMarketplace.getListing(
  //       basicNft.target,
  //       TOKEN_ID
  //     );
  //     assert(listing.price == updatedPrice);
  //   });
  // });

  // describe("Withdraw proceeds", function () {
  //   it.only("doesn't allow 0 proceeds withdrawals", async function () {
  //     expect(
  //       await nftMarketplace.withdrawProceeds()
  //     ).to.be.revertedWithCustomError(
  //       nftMarketplace,
  //       "NftMarketplace__NoProceeds"
  //     );
  //   });
  //   it.only("withdraw proceeds", async function () {
  //     await nftMarketplace.listItem(basicNft.target, TOKEN_ID, PRICE);
  //     const buyer = nftMarketplace.connect(player);

  //     expect(
  //       await buyer.buyItem(basicNft.target, TOKEN_ID, { value: PRICE })
  //     ).to.emit(buyer, "ItemBought");

  //     await nftMarketplace.connect(accounts[0]);
  //     const proceeds = await nftMarketplace.getProceeds(deployer);
  //     console.log(proceeds);
  //     await nftMarketplace.withdrawProceeds();
  //     const newProceeds = await nftMarketplace.getProceeds(deployer);
  //     console.log(newProceeds);
  //     const accountBalance = await ethers.balanceOf(accounts[0].address);
  //     console.log(accountBalance);
  //   });
  // });
});
