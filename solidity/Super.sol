// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Ownlable {
 address public owner;
 constructor() {
        owner  = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, 'not an owner');
        _;
    }
}

contract Balance is Ownlable {
    
    function getBalance() public view onlyOwner returns(uint)
    {
        return address(this).balance;
    }
}

contract MyContract is Ownlable, Balance {
   
    function withdraw(address payable _to) public onlyOwner {
        _to.transfer(address(this).balance);
    }
}