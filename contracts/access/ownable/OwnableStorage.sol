// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library OwnableStorage {
    struct Layout {
        address owner;
    }

    /**
     * @dev Storage slot constant for the Ownable storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.Ownable
     */
    bytes32 internal constant STORAGE_SLOT =
        0x56c55e4db2eee5c0ab5c61dd8eef753314135e0494b9730986c41f9a07037000;

    // keccak256(abi.encode(uint256(keccak256("fevertokens.storage.Ownable")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
