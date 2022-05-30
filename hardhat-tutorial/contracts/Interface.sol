// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol" ;

interface ILogger {
      function log(address _from, uint _amount) external ;

      function getEntry(address _from, uint index) external view returns(uint);
}

contract Logger is ILogger {
    mapping(address => uint[])  payments;

    function log(address _from, uint _amount) public override {
        require(_from != address(0), 'zero address');
        payments[_from].push(_amount);    
    }

    function getEntry(address _from, uint index) public override view returns(uint) {
        return payments[_from][index];
    }
}

contract Logger2 is ILogger {
    mapping(address => uint[])  payments;

    function log(address _from, uint _amount) public override {
        require(_from != address(0), 'zero address');
        require(_amount == _amount, 'zero address');
        
        payments[_from].push(50);
    }

    function getEntry(address _from, uint index) public override view returns(uint) {
        return payments[_from][index];
    }
}

contract DemoLogger {
    ILogger logger;

    constructor(address _logger) {
        logger = ILogger(_logger);
    }

    function payment(address _from, uint _number) public view returns(uint) {
        return logger.getEntry(_from, _number);
    }

    receive() external payable {
        logger.log(msg.sender, msg.value);
    }
}