// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library ReentrancyGuardStorage {
    struct Layout {
        uint256 status;
    }

    /**
     * @dev Storage slot constant for the ReentrancyGuard storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ReentrancyGuard
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x00819acec55f767aa17d67e128b36718f254b1fc532bb62897fe40fd70a5d100;

    // keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ReentrancyGuard")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
