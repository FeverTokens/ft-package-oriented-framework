// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

/**
 * @title Helper library for safe casting of uint and int values
 * @dev derived from https://github.com/OpenZeppelin/openzeppelin-contracts (MIT license)
 */
library SafeCast {
    error SafeCast__NegativeValue();
    error SafeCast__ValueDoesNotFit();

    function toUint224(uint256 value) internal pure returns (uint224) {
        if (value > type(uint224).max) revert("SafeCast: Value Does Not Fit");
        return uint224(value);
    }

    function toUint128(uint256 value) internal pure returns (uint128) {
        if (value > type(uint128).max) revert("SafeCast: Value Does Not Fit");
        return uint128(value);
    }

    function toUint96(uint256 value) internal pure returns (uint96) {
        if (value > type(uint96).max) revert("SafeCast: Value Does Not Fit");
        return uint96(value);
    }

    function toUint64(uint256 value) internal pure returns (uint64) {
        if (value > type(uint64).max) revert("SafeCast: Value Does Not Fit");
        return uint64(value);
    }

    function toUint32(uint256 value) internal pure returns (uint32) {
        if (value > type(uint32).max) revert("SafeCast: Value Does Not Fit");
        return uint32(value);
    }

    function toUint16(uint256 value) internal pure returns (uint16) {
        if (value > type(uint16).max) revert("SafeCast: Value Does Not Fit");
        return uint16(value);
    }

    function toUint8(uint256 value) internal pure returns (uint8) {
        if (value > type(uint8).max) revert("SafeCast: Value Does Not Fit");
        return uint8(value);
    }

    function toUint256(int256 value) internal pure returns (uint256) {
        if (value < 0) revert("SafeCast: Negative Value");
        return uint256(value);
    }

    function toInt128(int256 value) internal pure returns (int128) {
        if (value < type(int128).min || value > type(int128).max) revert("SafeCast: Value Does Not Fit");

        return int128(value);
    }

    function toInt64(int256 value) internal pure returns (int64) {
        if (value < type(int64).min || value > type(int64).max) revert("SafeCast: Value Does Not Fit");
        return int64(value);
    }

    function toInt32(int256 value) internal pure returns (int32) {
        if (value < type(int32).min || value > type(int32).max) revert("SafeCast: Value Does Not Fit");
        return int32(value);
    }

    function toInt16(int256 value) internal pure returns (int16) {
        if (value < type(int16).min || value > type(int16).max) revert("SafeCast: Value Does Not Fit");
        return int16(value);
    }

    function toInt8(int256 value) internal pure returns (int8) {
        if (value < type(int8).min || value > type(int8).max) revert("SafeCast: Value Does Not Fit");
        return int8(value);
    }

    function toInt256(uint256 value) internal pure returns (int256) {
        if (value > uint256(type(int256).max)) revert("SafeCast: Value Does Not Fit");
        return int256(value);
    }
}
