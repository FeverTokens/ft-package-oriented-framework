// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import {InitializationStatus} from "./IInitializableInternal.sol";

/**
 * @title Initializable Storage Library
 * @notice Provides storage layout and access for the Initializable.
 * @dev This library defines the storage layout and functions to access the storage slot for the Initializable.
 */
library InitializableStorage {
    /**
     * @dev Storage layout for the Initializable, including a mapping to track initialization statuses.
     * @param initialization A mapping to track initialization statuses identified by a bytes32 key.
     */
    struct Layout {
        mapping(bytes32 => InitializationStatus) initialization;
    }

    /**
     * @dev Storage slot constant for the Initializable storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.Initializable
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x300dbacb4eae624d21bf53d429940a1e327d6e579697456710cdaa5c67d1f900;

    //keccak256(abi.encode(uint256(keccak256("fevertokens.storage.Initializable")) - 1)) & ~bytes32(uint256(0xff));

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
