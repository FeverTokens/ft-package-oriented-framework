// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import {EnumerableSet} from "../../data/EnumerableSet.sol";
import {RoleData} from "./IAccessControlInternal.sol";

library AccessControlStorage {
    struct Layout {
        mapping(bytes32 => RoleData) roles;
    }

    /**
     * @dev Storage slot constant for the AccessControl storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.AccessControl
     */
    bytes32 internal constant STORAGE_SLOT =
        0xfd4241aef6acb253cbb26cb9e68f86195af1b7467df05d94eed5539cb2e13700;

    //  keccak256(abi.encode(uint256(keccak256("fevertokens.storage.AccessControl")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
