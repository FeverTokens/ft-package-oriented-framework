// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

enum FacetCutAction {
    ADD,
    REPLACE,
    REMOVE
}

struct FacetCut {
    address target;
    FacetCutAction action;
    bytes4[] selectors;
}

interface IPackageControllerInternal {
    event DiamondCut(FacetCut[] facetCuts, address target, bytes data);

    error PackageControllerInvalidInitializationParameters();
    error PackageControllerRemoveTargetNotZeroAddress();
    error PackageControllerReplaceTargetIsIdentical();
    error PackageControllerSelectorAlreadyAdded();
    error PackageControllerSelectorIsImmutable();
    error PackageControllerSelectorNotFound();
    error PackageControllerSelectorNotSpecified();
    error PackageControllerTargetHasNoCode();
    error PackageControllerInvalidFacetAction();
    error PackageControllerZeroAddress();
}
