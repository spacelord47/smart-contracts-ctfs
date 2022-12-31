// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./GatekeeperTwo.sol";
import "./GatekeeperTwoAttack.sol";

contract GatekeeperTwoAttackTest is Test {
    GatekeeperTwo gatekeeperTwo;
    GatekeeperTwoAttack gatekeeperTwoAttack;

    function setUp() public {
        gatekeeperTwo = new GatekeeperTwo();
        // gatekeeperTwoAttack = new GatekeeperTwoAttack();
    }

    function testGatekeeperTwoAttack() external {
        gatekeeperTwoAttack = new GatekeeperTwoAttack(address(gatekeeperTwo));
        require(gatekeeperTwo.entrant() != address(0));
    }
}
