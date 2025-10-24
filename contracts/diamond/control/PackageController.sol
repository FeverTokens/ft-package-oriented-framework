// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {IPackageController} from "./IPackageController.sol";
import {FacetCutAction, FacetCut, PackageControllerInternal} from "./PackageControllerInternal.sol";

/**
 * @title PackageController: EIP-2535 "Diamond" proxy update contract
 * @dev inspired from https://github.com/mudgen/diamond-2 (MIT license)
 */
contract PackageController is IPackageController, PackageControllerInternal {
    /**
     * @inheritdoc IPackageController
     * @dev This function should be overriden to implement access control
     */
    function diamondCut(FacetCut[] calldata facetCuts, address target, bytes calldata data) external {
        _diamondCut(facetCuts, target, data);
    }
}
