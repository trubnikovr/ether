// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol" ;

contract Payments {
    
    // struct
    struct Payment {
        uint amount;
        uint timestamp;
        address from;
    }

    struct Balance {
        uint total;
        Payment[] payments;
    }

    mapping(address => Balance) balances;

    function getPayment(address _addr, uint _index) public view returns(Payment memory) {
     
       return balances[_addr].payments[0];
    }

    function getBalance() public view returns(uint) {

        return address(this).balance;
    }
    
    receive() external payable {
        pay();
    }

    function pay() public payable {

        balances[msg.sender].total++;
        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp,
            msg.sender
        );

        balances[msg.sender].payments.push(newPayment);
        // console.log(balances[msg.sender].payments);
    }
}
