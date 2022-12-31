// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./Denial.sol";
import "./DenialAttack.sol";

contract DenialTest is Test {
    Denial target;
    DenialAttack attacker;

    function setUp() public {
        target = new Denial();
        attacker = new DenialAttack();
        deal(address(target), 1_000_000);
    }

    function testDenial() external {
        target.setWithdrawPartner(address(attacker));
        target.withdraw();
    }
}
