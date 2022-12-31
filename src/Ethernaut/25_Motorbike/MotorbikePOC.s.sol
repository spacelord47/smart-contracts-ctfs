// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "./MotorbikeAttack.sol";

contract MotorbikePOC is Script {
    function run(address _impl) external {
        vm.startBroadcast();
        
        MotorbikeAttack a = new MotorbikeAttack(_impl);
        a.attack();

        vm.stopBroadcast();
    }
}
