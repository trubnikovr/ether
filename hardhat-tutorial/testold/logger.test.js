const hre = require("hardhat");
const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("LoggerEngine", function () {
   let owner, seller, buyer, demoContract;

   beforeEach(async function () {
    [owner, seller, buyer] = await hre.ethers.getSigners();
    
    loggerContract = await (await hre.ethers.getContractFactory("Logger", owner)).deploy();
    await loggerContract.deployed();


    loggerContract1 = await (await hre.ethers.getContractFactory("Logger2", owner)).deploy();
    await loggerContract1.deployed();

    demoLoggerContract = await (await hre.ethers.getContractFactory("DemoLogger", owner)).deploy(loggerContract.address);
    await demoLoggerContract.deployed();
  });

  it("allow to pay and get payment info", async function() {
    const sum = 100;

    const txData = {
      value: sum,
      to: demoLoggerContract.address
    }
    const tx = await owner.sendTransaction(txData);

    await tx.wait();

    await expect(tx).to.changeEtherBalance(demoLoggerContract, sum);

    const amount = await demoLoggerContract.payment(owner.address, 0);
    console.log();
    expect(amount).to.eq(amount);

  });
 
});