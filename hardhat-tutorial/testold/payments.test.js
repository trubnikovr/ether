const hre = require("hardhat");
const { expect } = require("chai");
 
 describe("Payments", function() {
     let acc1, acc2, payments;
    
     beforeEach(async function() {
         [acc1, acc2] = await hre.ethers.getSigners();
         const Payments = await hre.ethers.getContractFactory("Payments", acc1);
         payments = await Payments.deploy();
         await payments.deployed();
     })
     
    it('should be deployed', async function() {
         expect(payments.address).to.be.properAddress;
     })

    it('should have 0 ether by default', async function() {
        const balance = await payments.getBalance();
        expect(balance).to.eq(0);
    })

    it("should be possible to send funds", async function() {
        const tx =  await payments.connect(acc2).pay({ value:20 });
        await tx.wait();

        await expect(()=> tx).to.changeEtherBalances([acc2, payments], [-20, 20])        
        const newPayment = await payments.getPayment(acc2.address, 0);
    })
 })