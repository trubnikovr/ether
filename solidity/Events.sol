// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol" ;

contract Events {
    
    address owner;

    constructor() { 
        owner = msg.sender; 
    }
    
    event Paid(address indexed _from, uint _amount, uint _timesamp);

    function pay() external payable {
        emit Paid(msg.sender, msg.value, block.timestamp);
    }
}