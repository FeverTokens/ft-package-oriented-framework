// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library ERC20MetadataStorage {
    struct Layout {
        string name;
        string symbol;
        uint8 decimals;
    }

    /**
     * @dev Storage slot constant for the ERC20Metadata storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC20Metadata
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x1a60cc5e0b4158f9359c1dbe59b309fb98a1fe38a11a3ccfa50330f26679bd00;

    // keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC20Metadata")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
