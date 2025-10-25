// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import {IOwnableInternal} from "./IOwnableInternal.sol";
import {OwnableStorage} from "./OwnableStorage.sol";

abstract contract OwnableInternal is IOwnableInternal {
    function __OwnableInternal_init(address owner) internal {
        __OwnableInternal_init_unchained(owner);
    }

    function __OwnableInternal_init_unchained(address owner) internal {
        _setOwner(owner);
    }

    modifier onlyOwner() {
        require(msg.sender == _owner(), "ERC173: sender must be owner");
        _;
    }

    function _owner() internal view virtual returns (address) {
        return OwnableStorage.layout().owner;
    }

    function _transferOwnership(address account) internal virtual {
        _setOwner(account);
    }

    function _setOwner(address account) internal virtual {
        OwnableStorage.Layout storage l = OwnableStorage.layout();
        emit OwnershipTransferred(l.owner, account);
        l.owner = account;
    }
}
