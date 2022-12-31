// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/console.sol";

contract TestContract2 {
    function privateFunc() private view returns (uint256) {
        console.log(2);
        return 1;
    }
}
