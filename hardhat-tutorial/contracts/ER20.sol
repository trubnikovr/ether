// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./IERC20.sol";

contract ER20 is IERC20 {
    address owner;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;
    string _name;
    string _symbol;

    uint256 totalTokens;

    modifier enoughToken(address _from, uint256 _amount) {
        require(balanceOf(_from) >= _amount, "not enough tokens");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address shop
    ) {
        _name = name;
        _symbol = symbol;
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function mint(uint256 amount, address shop) public onlyOwner {
        balances[shop] += amount;
        totalTokens += amount;
        emit Transfer(address(0), shop, amount);
    }

    function decimals() external pure override returns (uint256) {
        return 18;
    }

    function totalSupply() external view override  returns (uint256) {
        return totalTokens;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 amount)
        external
        override
        enoughToken(msg.sender, amount)
    {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 amount
    ) internal virtual {}

    function allowance(address _owner, address spender)
        external
        override
        view
        returns (uint256)
    {
        return allowances[_owner][spender];
    }

    function burn(address _from, uint256 amount) public onlyOwner {
        _beforeTokenTransfer(_from, address(0), amount);

        balances[_from] -= amount;
        totalTokens -= amount;
    }

    function approve(address spender, uint256 amount) public override {
        _approve(msg.sender, spender, amount);
    }

    function _approve(
        address sender,
        address spender,
        uint256 amount
    ) internal virtual {
        allowances[sender][spender] = amount;
        emit Approve(sender, spender, amount);
    }

    function transferFrom(
        address spender,
        address recipient,
        uint256 amount
    ) external override enoughToken(spender, amount) {
        _beforeTokenTransfer(spender, recipient, amount);
        allowances[spender][recipient] -= amount;
        balances[spender] -= amount;
        balances[recipient] += amount;
        emit Transfer(spender, recipient, amount);
    }
}

contract MCSToken is ER20 {
    constructor(address shop) ER20("MCSToken", "MCT", 20, shop) {}
}

contract MShop {
    IERC20 public token;
    address payable public owner;
    event Bought(uint256 _amount, address indexed _buyer);
    event Sold(uint256 _amount, address indexed _seller);

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    constructor() {
        token = new MCSToken(address(this));
        owner = payable(msg.sender);
    }

    function sell(uint256 _amountToSell) external {
        require(
            _amountToSell > 0 && token.balanceOf(msg.sender) >= _amountToSell,
            "incorrect amount"
        );

        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amountToSell, "check allowance");

        token.transferFrom(msg.sender, address(this), _amountToSell);
        payable(msg.sender).transfer(_amountToSell);

        emit Sold(_amountToSell, msg.sender);
    }

    receive() external payable {
        uint256 tokensToBuy = msg.value;
        require(tokensToBuy > 0, "not enough funds!");

        require(tokenBalance() > tokensToBuy, "not enough token");

        token.transfer(msg.sender, tokensToBuy);
        emit Bought(tokensToBuy, msg.sender);
    }

    function tokenBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
