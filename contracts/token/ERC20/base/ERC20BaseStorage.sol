// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

library ERC20BaseStorage {
    struct Layout {
        mapping(address => uint256) balances;
        mapping(address => mapping(address => uint256)) allowances;
        uint256 totalSupply;
    }

    /**
     * @dev Storage slot constant for the ERC20Base storage layout.
     * @custom:storage-location erc7201:fevertokens.storage.ERC20Base
     */
    //
    bytes32 internal constant STORAGE_SLOT =
        0x2b088ffaa98b64096f77a80ec5d116180e49fee398f475e4311c746d31a5a200;

    //keccak256(abi.encode(uint256(keccak256("fevertokens.storage.ERC20Base")) - 1)) & ~bytes32(uint256(0xff));

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
