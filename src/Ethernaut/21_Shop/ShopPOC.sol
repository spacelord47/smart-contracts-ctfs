// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "./Buyer.sol";
import "./Shop.sol";

contract ShopPOC is Script {
    function run(address _instance) external {
        vm.startBroadcast();

        Buyer buyer = new Buyer(_instance);
        buyer.buy();

        vm.stopBroadcast();
    }
}
