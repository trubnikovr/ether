pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract AuksionEngine {
    address public owner;
    uint constant DURATION = 2 days;
    uint constant FEE = 10;

    // 
    struct Auction {
        address payable seller;
        uint startingPrice;
        uint finalPrice;
        uint startAt;
        uint endAt;
        uint discountRate;
        string item;
        bool stopped;
    }

    event AuctionCreated(uint index, string item, uint startingPrice, uint duration);
    event AuctionEnded(uint index,  uint finalPrice, address winner);

    Auction[] public auctions;

    constructor() {
        owner = msg.sender;
    }

    function createAuction(uint _startingPrice, uint _discountRate, string calldata _item, uint _duration) external {
        uint duration = _duration == 0 ? DURATION : _duration;

        require(_startingPrice >= _discountRate * duration, "incorrect starting price");

        Auction memory newAuction = Auction({
            seller: payable(msg.sender),
            startingPrice: _startingPrice,
            finalPrice: _startingPrice,
            startAt: block.timestamp,
            discountRate: _discountRate,
            endAt: block.timestamp + duration,
            item: _item,
            stopped: false
        });

        auctions.push(newAuction);

        emit AuctionCreated(auctions.length + 1, _item, _startingPrice, duration);
    }

    function getPriceFor(uint index) public view returns(uint) {
        Auction memory cAuksion = auctions[index];
        require(!cAuksion.stopped, "stopped");

        uint elapsed = block.timestamp - cAuksion.startAt;
        uint discount = cAuksion.discountRate * elapsed;

        return cAuksion.startingPrice - discount;
    }

    function stop(uint index) public  {
        Auction storage cAukcion = auctions[index];
        cAukcion.stopped = true;
    }

    function buy(uint index) external payable {

        Auction storage cAuksion = auctions[index];
        require(!cAuksion.stopped, "stopped");
        require(block.timestamp < cAuksion.endAt, "ended!");

        uint cPrice = getPriceFor(index);

        require(block.timestamp < cAuksion.endAt, "not enough funds!");
        cAuksion.stopped = true;
        cAuksion.finalPrice = cPrice;


        uint refund = msg.value - cPrice;

        if(refund > 0) {
            payable(msg.sender).transfer(refund);
        }

        cAuksion.seller.transfer(
            cPrice - ((cPrice * FEE) / 100)
        );

        emit AuctionEnded(index, cPrice, msg.sender);
    }
}