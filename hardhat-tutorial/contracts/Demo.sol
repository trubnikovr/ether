// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol" ;

contract Demo {
    
    address owner;

    event Paid(address indexed _from, uint _amount, uint _timesamp);
    constructor() { 

       // owner = msg.sender; 
    }
    
    // receive() external payable {
    //     pay();
    // }

    function pay() public payable {

        emit Paid(msg.sender, msg.value, block.timestamp);
    }

}