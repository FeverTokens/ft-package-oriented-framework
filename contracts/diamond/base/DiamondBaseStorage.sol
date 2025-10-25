// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

/**
 * @dev derived from https://github.com/mudgen/diamond-2 (MIT license)
 */
library DiamondBaseStorage {
    struct Layout {
        // function selector => (facet address, selector slot position)
        mapping(bytes4 => bytes32) facets;
        // total number of selectors registered
        uint16 selectorCount;
        // array of selector slots with 8 selectors per slot
        mapping(uint256 => bytes32) selectorSlots;
        address fallbackAddress;
    }

    // keccak256(abi.encode(uint256(keccak256("fevertokens.storage.DiamondBase")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 internal constant STORAGE_SLOT =
        0x2edf44bd63cb5d8b62c8e1fe5d7bb72e6b79f4df65709bb1b459372947e4b000;

    function layout() internal pure returns (Layout storage $) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            $.slot := slot
        }
    }
}
