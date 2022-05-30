const hre = require("hardhat");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const tokenJson = require("../artifacts/contracts/ER20.sol/MCSToken.json");


describe("MShop", function () {
  let owner, shop, buyer, demoContract, erc20;

   beforeEach(async function () {
    [owner, buyer] = await hre.ethers.getSigners();
    const DemoContract = await hre.ethers.getContractFactory("MShop", owner);
    // class AuksionEngine
    demoContract = await DemoContract.deploy();
    await demoContract.deployed();

    erc20 = new ethers.Contract(demoContract.token(), tokenJson.abi, owner);
  });

  it("should have an owner and a token", async function() {
   
    expect(await demoContract.owner()).to.eq(owner.address);
    expect(await demoContract.token()).to.be.properAddress;
  });


  it("allow to buy", async function() {
    const tokenAmount = 3;

    const txData = {
      value: tokenAmount,
      to: demoContract.address
    };
    const tx = await buyer.sendTransaction(txData);
    await tx.wait();

    expect(await erc20.balanceOf(buyer.address)).to.eq(tokenAmount);

    await expect(() => tx).to.changeEtherBalance(demoContract, tokenAmount);
    // await expect(tx).to.emit(demoContract, "Bought")
    //                           .withArgs(tokenAmount, buyer.sender);
  });


  it("allow to sell", async function() {
    const tokenAmount = 3;

    const txData = {
      value: tokenAmount,
      to: demoContract.address
    };
    const tx = await buyer.sendTransaction(txData);
    await tx.wait();

    const sellAmount = 2;

    const approval =  await erc20.connect(buyer).approve(demoContract.address, sellAmount);
    await approval.wait();

    const sellTx = await demoContract.connect(buyer).sell(sellAmount);

    await expect(() => sellTx).to.changeEtherBalance(shop, -sellAmount);

  

  });


});