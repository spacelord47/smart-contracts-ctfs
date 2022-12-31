// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "./GoodSamartian.sol";
import "./GoodSamartianAttack.sol";

contract GoodSamartianPOC is Script {
    function run() external {
        vm.startBroadcast();

        GoodSamartianAttack a = new GoodSamartianAttack();
        a.attack();

        vm.stopBroadcast();
    }
}
