// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "./TestContract2.sol";

contract TestContractPOC is Script {
    function run() external {
        vm.startBroadcast();

        TestContract2 test2 = new TestContract2();

        (bool success, bytes memory res) = address(test2).call(
            abi.encodeWithSignature("privateFunc()")
        );
        console.log(success);
        console.logBytes(res);

        vm.stopBroadcast();
    }
}
