// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

/**
 * @title ERC1155 metadata extensions
 */
library ERC1155MetadataStorage {
    struct Layout {
        string baseURI;
        mapping(uint256 => string) tokenURIs;
    }

    /**
     * @dev Storage slot constant for the ERC1155Metadata storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC1155Metadata
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x28fc3dc02aeda1eeabf348e3bec1bec10c11bd41c8cef9f87114b47cb3c1ba00;

    // keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC1155Metadata")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
