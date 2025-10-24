// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import {EnumerableSet} from "../../../data/EnumerableSet.sol";

library ERC1155EnumerableStorage {
    struct Layout {
        mapping(uint256 => uint256) totalSupply;
        mapping(uint256 => EnumerableSet.AddressSet) accountsByToken;
        mapping(address => EnumerableSet.UintSet) tokensByAccount;
    }

    /**
     * @dev Storage slot constant for the ERC1155Enumerable storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC1155Enumerable
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x52addbcd7409b68e099e531e8db86135540c82917352e48f140eb62cf0439900;

    //  keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC1155Enumerable")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
