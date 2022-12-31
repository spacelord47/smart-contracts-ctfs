// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract Assembly {
    function add(uint256 /*_a*/, uint256 /*_b*/) external pure returns (uint256 result) {
        assembly {
            // the memory up to 0x40 reserved by EVM
            let ptr := mload(0x40)
            let a := ptr
            let b := add(ptr, 32)

            // 4: starting after function signature
            // 32: uint256 size
            calldatacopy(a, 4, 32)
            calldatacopy(b, 36, 32)

            result := add(mload(a), mload(b))
        }
    }
}
