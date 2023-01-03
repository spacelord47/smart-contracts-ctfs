// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./D31eg4t3.sol";
import "./D31eg4t3Attack.sol";

// For this test we will use a forked environment
contract D31eg4t3POC is Test {
  D31eg4t3 target = D31eg4t3(0x971e55F02367DcDd1535A7faeD0a500B64f2742d);
  D31eg4t3Attack attacker = new D31eg4t3Attack(0x971e55F02367DcDd1535A7faeD0a500B64f2742d);

  function setUp() external {
    require(target.owner() != address(attacker), "POC: attacker is owner");
    require(target.canYouHackMe(address(attacker)) == false, "POC: hacked");
  }

  function testExploit() external {
    attacker.attack();

    require(target.owner() == address(attacker), "POC: attacker not owner");
    require(target.canYouHackMe(address(attacker)) == true, "POC: not hacked");
  }
}
