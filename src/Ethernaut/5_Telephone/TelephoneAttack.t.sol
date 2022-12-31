// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./Telephone.sol";
import "./TelephoneAttack.sol";

contract TelephoneAttackTest is Test {
    Telephone t;
    TelephoneAttack a;

    function setUp() public {
        t = new Telephone();
        a = new TelephoneAttack(address(t));
    }

    function testAttack() public {
        vm.prank(address(1));
        a.attack();
        require(t.owner() == address(1));
    }
}
