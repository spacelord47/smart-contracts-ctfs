// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/console.sol";
import "./TestContract2.sol";

contract TestContract {
  function callPrivate(address _test2) external {
    // TestContract2(_test2).privateFunc();
  }
}
