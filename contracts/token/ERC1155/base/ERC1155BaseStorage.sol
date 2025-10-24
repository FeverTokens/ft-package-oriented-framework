// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library ERC1155BaseStorage {
    struct Layout {
        mapping(uint256 => mapping(address => uint256)) balances;
        mapping(address => mapping(address => bool)) operatorApprovals;
    }

    /**
     * @dev Storage slot constant for the ERC1155Base storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC1155Base
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0xfa365e4df336c5282d22d85a2a7afc76b787bad4b2de3199fa452c9c34d04000;

    // keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC1155Base")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
