// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity ^0.8.26;

/**
 * @title EIP712 Storage Library
 * @notice Provides storage layout and access for EIP712 domain data.
 * @dev This library defines the storage layout and functions to access the storage slot for EIP712 domain data.
 */
library EIP712Storage {
    /**
     * @dev Storage layout for the EIP712 domain, including hashed name, hashed version, name, and version.
     * @param _hashedName The keccak256 hash of the domain name.
     * @param _hashedVersion The keccak256 hash of the domain version.
     * @param _name The domain name.
     * @param _version The domain version.
     */
    struct Layout {
        bytes32 _hashedName;
        bytes32 _hashedVersion;
        string _name;
        string _version;
    }

    /**
     * @dev Storage slot constant for the EIP712 storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.EIP712
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x25bd642bde6ccba30d90decc48cf28dd1d98433926125ed62a6aefecd15b0800;

    // keccak256(abi.encode(uint256(keccak256("fevertokens.storage.EIP712")) - 1)) & ~bytes32(uint256(0xff));

    /**
     * @notice Provides access to the storage layout.
     * @dev This function uses inline assembly to assign the storage slot to the layout.
     */
    function layout() internal pure returns (Layout storage $) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            $.slot := slot
        }
    }
}
