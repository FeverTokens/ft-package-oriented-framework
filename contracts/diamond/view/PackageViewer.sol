// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {DiamondBaseStorage} from "../base/DiamondBaseStorage.sol";
import {Facet, IPackageViewer} from "./IPackageViewer.sol";
import {PackageViewerInternal} from "./PackageViewerInternal.sol";

/**
 * @title PackageViewer: EIP-2535 "Diamond" proxy introspection contract
 * @dev inspired from https://github.com/mudgen/diamond-2 (MIT license)
 */
contract PackageViewer is IPackageViewer, PackageViewerInternal {
    /**
     * @inheritdoc IPackageViewer
     */
    function facets() external view returns (Facet[] memory diamondFacets) {
        return _facets();
    }

    /**
     * @inheritdoc IPackageViewer
     */
    function facetFunctionSelectors(address facet) external view returns (bytes4[] memory selectors) {
        return _facetFunctionSelectors(facet);
    }

    /**
     * @inheritdoc IPackageViewer
     */
    function facetAddresses() external view returns (address[] memory addresses) {
        return _facetAddresses();
    }

    /**
     * @inheritdoc IPackageViewer
     */
    function facetAddress(bytes4 selector) external view returns (address facet) {
        return _facetAddress(selector);
    }
}
