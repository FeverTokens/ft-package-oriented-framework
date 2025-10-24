// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import {EnumerableMap} from "../../../data/EnumerableMap.sol";
import {EnumerableSet} from "../../../data/EnumerableSet.sol";

library ERC721BaseStorage {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    struct Layout {
        EnumerableMap.UintToAddressMap tokenOwners;
        mapping(address => EnumerableSet.UintSet) holderTokens;
        mapping(uint256 => address) tokenApprovals;
        mapping(address => mapping(address => bool)) operatorApprovals;
    }

    /**
     * @dev Storage slot constant for the ERC721Base storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC721Base
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x494c48381414e3934627e89b3bcb3a88a5a339d52bf4b192704b1c9315693700;

    //   keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC721Base")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
