const hre = require("hardhat");
const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("AuksionEngine", function () {
   let owner, seller, buyer, demoContract;

   beforeEach(async function () {
    [owner, seller, buyer] = await hre.ethers.getSigners();
    const DemoContract = await hre.ethers.getContractFactory("AuksionEngine", owner);
    // class AuksionEngine
    demoContract = await DemoContract.deploy();
    await demoContract.deployed();
  })

  it('sets owner', async function() {
    const contractOwner = await demoContract.owner();
    expect(contractOwner).to.eq(owner.address);
  });

  async function getTimestamp(bn) {

    return (
      await ethers.provider.getBlock(bn)
    ).timestamp;
  }

  describe("createAuction", function() {
    it('create auction correctly', async function() {
      const duration = 60;
      const tx = demoContract.createAuction(
        ethers.utils.parseEther('0.0001'),
        3,
        'face item',
        60,
      );

      const cAuction = await demoContract.auctions(0);
      expect(cAuction.item).to.eq('face item');
      const ts = await getTimestamp(tx.blockNumber);

      expect(cAuction.endAt).to.eq(ts + duration);
    });
  });

  function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  describe('buy', function() {
    it('allow to buy', async function() {
      const tx = demoContract.connect(seller).createAuction(
        ethers.utils.parseEther('0.0001'),
        3,
        'face item',
        60,
      );
  
      this.timeout(5000); // 5 sec
      await delay(1000); // 1 sec
  
      const butTx = await demoContract.connect(buyer).buy(0, { value: ethers.utils.parseEther('0.0001')});
      const cAuction = await demoContract.auctions(0);
      const finalPrice = cAuction.finalPrice;
      await expect(() => butTx).to.changeEtherBalance(seller,
         finalPrice - Math.floor(((finalPrice * 10) / 100)));
      
      await expect(butTx)
                      .to.emit(demoContract, 'AuctionEnded')
                      .withArgs(0, finalPrice, buyer.address);

    });
  });
 
});