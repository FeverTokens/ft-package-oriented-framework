// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import {IContextInternal} from "./IContextInternal.sol";

abstract contract ContextInternal is IContextInternal {
    function __Context_init() internal {}

    function __Context_init_unchained() internal {}

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
