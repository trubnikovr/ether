const hre = require("hardhat");
const { expect } = require("chai");

describe("Demo", function () {
  let owner, other_addr, demo;

  beforeEach(async function () {
    [owner, other_addr] = await hre.ethers.getSigners();
    const DemoContract = await hre.ethers.getContractFactory("Demo", owner);
    demoContract = await DemoContract.deploy();
    await demoContract.deployed();
  })

  async function sendMoney(sender, amount) {

    const txData = {
      to: demoContract.address,
      value: amount
    };
  
    const ownerBalance = await sender.provider.getBalance(sender.address)
    const tx = await sender.sendTransaction(txData);
 
    await tx.wait();
 
    return [tx, amount];
  }
  

  it('should allow to send money', async function () {
    const [sendMoneyTx, amount] = await sendMoney(other_addr, 1);
    console.log(sendMoneyTx);
  })

})