// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol" ;

contract Ttee {
    //
    bytes32 public hashes;
    string[4] transactions = [
        "TX1",
        "TX2",
        "TX3",
        "TX4"
        ];
    uint offset = 0;    
    constructor() {
        
        for(uint i = 0; i < transactions.length; i++) {
            hashes.push(makeHash(transactions[i]));
        }

        uint count = transactions.length;

        while(count = transactions.length) {
            for(uint i = 0; i < count; i += 2) {
                hashes.push(makeHash(
                    abi.encodePacked(
                        hashes[offset + i], hashes[offset + i + 1]
                    )
                ));
            }
            offset += count;
            count = count /2;

        }
    }

    function encode(string memory input)  public pure returns(bytes memory) {

      return abi.encodePacked(input);  
    }

    function verify(string memory transaction, uint index, bytes32 rootHash,  bytes32[] memory proof ) public pure returns(bool) {
        bytes32 hash = makeHash(transaction);
        for(uint i = 0; i < proof.length; i++) {
            bytes32 element = proof[i];
            if(index % 2) {
                hash = keccak256(abi.encodePacked(hash, element));
            } else {
                hash = keccak256(abi.encodePacked(element, hash));
            }
            index = index/2;
        }

        return rootHash == hash;
    }

    function makeHash(string memory input) public pure returns(bytes32) {
        
        return keccak256(
            encode(input)
        );
    }
}