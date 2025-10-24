// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {Proxy} from "../proxy/Proxy.sol";
import {IDiamondBase} from "./IDiamondBase.sol";
import {DiamondBaseStorage} from "./DiamondBaseStorage.sol";

/**
 * @title EIP-2535 "Diamond" proxy base contract
 * @dev see https://eips.ethereum.org/EIPS/eip-2535
 */
abstract contract DiamondBase is IDiamondBase, Proxy {
    /**
     * @inheritdoc Proxy
     */
    function _getImplementation() internal view override returns (address implementation) {
        DiamondBaseStorage.Layout storage $ = DiamondBaseStorage.layout();

        implementation = address(bytes20($.facets[msg.sig]));
    }
}
