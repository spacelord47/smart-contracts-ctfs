// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./GatekeeperOne.sol";
import "./GatekeeperAttack.sol";

contract GatekeeperAttackTest is Test {
    GatekeeperOne gatekeeper;
    GatekeeperAttack gatekeeperAttack;

    function setUp() public {
        gatekeeper = new GatekeeperOne();
        gatekeeperAttack = new GatekeeperAttack();
    }

    function testGatekeeperAttack() public {
        vm.prank(
            0x37728F27aa7760d4A3f38498A017A393f9E3A867,
            0x37728F27aa7760d4A3f38498A017A393f9E3A867
        );
        gatekeeperAttack.attack(address(gatekeeper));
        require(gatekeeper.entrant() == 0x37728F27aa7760d4A3f38498A017A393f9E3A867);
    }
}
