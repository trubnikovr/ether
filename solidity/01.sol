// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyFirstShop {
    mapping(address => bool) buyers;
    uint256 public price = 2 ether;
    address public owner;
    address public shopAddress;
    bool fullyPaid = false;
    constructor()
    {
        owner = msg.sender;
        shopAddress = address(this);
    }

    event ItemFullyPaid(uint _price, address _shopAddress);
    function getBalance() public view returns(uint) {

        return shopAddress.balance;
    }

    receive() external payable {

        require(
         owner == msg.sender
         && msg.value <= price
         && !fullyPaid  , "Reject");
         if(shopAddress.balance == price) {
            fullyPaid = true;

            emit ItemFullyPaid(price,  shopAddress);
        }
    }

    function getBayer(address _addr) public view returns(bool) {

        require(owner == msg.sender, "You are not an owner!");
        return buyers[_addr];
    }

    function addBayer(address _addr) public {

        require(owner == msg.sender, "You are not an owner!");
        buyers[_addr] = true;
    }

    function withdrawAll() public {

        require(owner == msg.sender && fullyPaid, "You are not an owner!");
        address payable receiver = payable(msg.sender);

        receiver.transfer(shopAddress.balance);
    }
}
