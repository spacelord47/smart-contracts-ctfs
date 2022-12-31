// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./King.sol";
import "./KingAttack.sol";

contract KingAttackTest is Test {
    King king;
    KingAttack kingAttack;

    function setUp() public {
        king = new King{value: 1}();
        kingAttack = new KingAttack(address(king));

        deal(address(king), 10 ether);
        deal(address(kingAttack), 10 ether);
    }

    function testAttack() public {
        kingAttack.attack();
        (bool success, ) = address(king).call{value: 3}("");
        require(success == false);
    }

    receive() external payable {}
}
