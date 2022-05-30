// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol" ;

contract Demo {
    
    address owner;

    constructor() { 
        owner = msg.sender; 
     }
    
    function withdraw(address payable _to) external payable {

        require(msg.sender == owner, "You are not an owner!");
        address payable receiver = payable(msg.sender);

        if(false) {

            revert("You are not an owner!");
        }

        _to.transfer(address(this).balance);
    }

}