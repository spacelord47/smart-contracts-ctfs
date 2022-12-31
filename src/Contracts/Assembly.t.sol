// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./Assembly.sol";

contract AssemblyTest is Test {
    Assembly asm;

    function setUp() public {
        asm = new Assembly();
    }

    function testAdd() public view {
        uint256 res = asm.add(1, 2);
        require(res == 3, "failed add");
    }
}
