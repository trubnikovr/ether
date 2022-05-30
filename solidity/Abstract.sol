pragma solidity ^0.8.0;
contract Ownlable {
 address public owner;
    constructor(address ownerOverride) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, 'not an owner');
        _;
    }

    function withdraw(address payable _to) public virtual onlyOwner {
      _to.transfer(owner.balance);
    }
}

abstract contract Balance is Ownlable {
    
    function getBalance() public view onlyOwner returns(uint)
    {
        return address(this).balance;
    }

    function withdraw(address payable _to) public override virtual onlyOwner {
      _to.transfer(owner.balance);
    }
}
contract MyContract is Ownlable(address(0)), Balance {

    // constructor(address ownerOverride) Ownlable(address(0)) 
    constructor(address ownerOverride) {
         
    }
    
    function withdraw(address payable _to) public override(Ownlable, Balance) onlyOwner {
        _to.transfer(address(this).balance);
        // Ownlable.withdraw(_to);
        // Balance.withdraw(_to);
        super.withdraw(_to);
    }
}