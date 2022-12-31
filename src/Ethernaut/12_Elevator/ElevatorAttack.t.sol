// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./Elevator.sol";
import "./ElevatorAttack.sol";
import "./ElevatorAttackAdvanced.sol";

contract ElevatorAttackTest is Test {
    Elevator elevator;
    ElevatorAttack elevatorAttack;
    ElevatorAttackAdvanced elevatorAttackAdvanced;

    function setUp() public {
        elevator = new Elevator();
        elevatorAttack = new ElevatorAttack(address(elevator));
        elevatorAttackAdvanced = new ElevatorAttackAdvanced(address(elevator));
    }

    function testAttack() public {
        elevatorAttack.attack();
        require(elevator.top(), "top == false");
    }
    
    function testAdvancedAttack() public {
        elevatorAttackAdvanced.attack();
        require(elevator.top(), "top == false");
    }
}
