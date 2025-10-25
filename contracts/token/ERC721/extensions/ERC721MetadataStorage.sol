// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library ERC721MetadataStorage {
    struct Layout {
        string name;
        string symbol;
        string baseURI;
        mapping(uint256 => string) tokenURIs;
    }

    /**
     * @dev Storage slot constant for the ERC721Metadata storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC721Metadata
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x227733841f7b274a39c8b02b70ab2bce4c4f44d63cfc7360947939ab90892900;

    //keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC721Metadata")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
