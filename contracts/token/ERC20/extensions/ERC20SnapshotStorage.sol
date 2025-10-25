// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library ERC20SnapshotStorage {
    struct Snapshots {
        uint256[] ids;
        uint256[] values;
    }

    struct Layout {
        mapping(address => Snapshots) accountBalanceSnapshots;
        Snapshots totalSupplySnapshots;
        uint256 snapshotId;
    }

    /**
     * @dev Storage slot constant for the ERC20Snapshot storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC20Snapshot
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0xa6697c98d1bb1793c27f3449917b2ef0d302ddb2978a230fa460435688af6300;

    //keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC20Snapshot")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
