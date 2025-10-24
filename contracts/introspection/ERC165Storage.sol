// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library ERC165Storage {
    struct Layout {
        mapping(bytes4 => bool) supportedInterfaces;
    }

    /**
     * @dev Storage slot constant for the ERC165 storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC165
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0xb5b8963eb69caba739dcbcf25496d25c11c82c55d18d8b19fd10f0dde3a5db00;

    //  keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC165")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
