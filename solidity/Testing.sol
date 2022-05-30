// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol" ;

contract Structs {
    
    // struct
    struct Payment {
        uint amount;
        uint timestamp;
        address from; 
    }

    struct Balance {
        uint total;
        mapping(address => Balance) payments;
    }

    mapping(address => Balance) balances;
 
}
