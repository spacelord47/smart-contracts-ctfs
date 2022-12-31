// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./CoinFlip.sol";    
import "./CoinFlipAttack.sol";

contract CoinFlipAttackTest is Test {
    CoinFlip coinFlip;
    CoinFlipAttack coinFlipAttack;

    function setUp() public {
        coinFlip = new CoinFlip();
        coinFlipAttack = new CoinFlipAttack(address(coinFlip));
    }

    function testAttackSucceeded() public {
        coinFlipAttack.attack();
        require(coinFlip.consecutiveWins() == 1);
    }
}
