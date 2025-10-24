// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library PausableStorage {
    struct Layout {
        bool paused;
    }

    /**
     * @dev Storage slot constant for the Pausable storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.Pausable
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0xebcd51003fd5533c59513c252620a545fc9897054eca22522368fea01d3dcc00;

    // keccak256(abi.encode(uint256(keccak256("fevertokens.storage.Pausable")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
