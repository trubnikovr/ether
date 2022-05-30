// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol" ;

contract Modifier {
    
    address owner;

    constructor() { 
        owner = msg.sender; 
     }

    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not an owner!");
        _;
    }
    
    function withdraw(address payable _to) external onlyOwner {

        
    }

}