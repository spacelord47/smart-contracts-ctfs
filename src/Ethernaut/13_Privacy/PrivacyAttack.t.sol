// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./Privacy.sol";
import "./PrivacyAttack.sol";

contract PrivacyAttackTest is Test {
    Privacy privacy;
    PrivacyAttack privacyAttack;

    function setUp() public {
        bytes32[3] memory arr = [
            bytes32(0xb398989eb9364f5aac4f54d845b9b89db5f81a2979d2e57aa26efbc7ece58e1b),
            bytes32(0x364259e7406455e625cbdbe75faf0e063f86b4b01a7eb3b65f8fed86806c9308),
            bytes32(0x118ee1a4fb9947ecc74f397f045ee5a1d8213798a33f0994e96183f7a104a9d4)
        ];
        privacy = new Privacy(arr);
        privacyAttack = new PrivacyAttack(address(privacy));
    }
    
    function testAttack() public {
      privacyAttack.attack();
    }
}
