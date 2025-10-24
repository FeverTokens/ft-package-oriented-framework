// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {FacetCut, IPackageControllerInternal} from "./IPackageControllerInternal.sol";

/**
 * @title Package Controller (Diamond proxy upgrade) interface
 * @dev see https://eips.ethereum.org/EIPS/eip-2535
 */
interface IPackageController is IPackageControllerInternal {
    /**
     * @notice update diamond facets and optionally execute arbitrary initialization function
     * @param facetCuts array of structured Diamond facet update data
     * @param target optional target of initialization delegatecall
     * @param data optional initialization function call data
     */
    function diamondCut(FacetCut[] calldata facetCuts, address target, bytes calldata data) external;
}
