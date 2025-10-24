// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {DiamondBaseStorage} from "../base/DiamondBaseStorage.sol";
import {FacetCutAction, FacetCut, IPackageControllerInternal} from "./IPackageControllerInternal.sol";
import {OwnableInternal} from "../../access/ownable/OwnableInternal.sol";
import {InitializableInternal} from "../../initializable/InitializableInternal.sol";

/**
 * @title PackageControllerInternal: EIP-2535 "Diamond" proxy update internal contract
 * @dev inspired from https://github.com/mudgen/diamond-2 (MIT license)
 */
abstract contract PackageControllerInternal is
    IPackageControllerInternal,
    InitializableInternal,
    OwnableInternal
{
    bytes32 private constant CLEAR_ADDRESS_MASK =
        bytes32(uint256(0xffffffffffffffffffffffff));
    bytes32 private constant CLEAR_SELECTOR_MASK =
        bytes32(uint256(0xffffffff << 224));

    function __PackageController_init(address owner) internal {
        __PackageController_init_unchained();
        __OwnableInternal_init(owner);
    }

    function __PackageController_init_unchained()
        internal
        initializer(DiamondBaseStorage.STORAGE_SLOT)
    {}

    /**
     * @notice update functions callable on Diamond proxy
     * @param facetCuts array of structured Diamond facet update data
     * @param target optional recipient of initialization delegatecall
     * @param data optional initialization call data
     */
    function _diamondCut(
        FacetCut[] memory facetCuts,
        address target,
        bytes memory data
    ) internal {
        // Only owner or during construction (when contract has no code yet)
        uint256 contractSize;
        assembly {
            contractSize := extcodesize(address())
        }
        
        if (contractSize > 0 && msg.sender != _owner()) {
            revert("PackageController: Must be contract owner");
        }

        DiamondBaseStorage.Layout storage $ = DiamondBaseStorage.layout();

        unchecked {
            uint256 originalSelectorCount = $.selectorCount;
            uint256 selectorCount = originalSelectorCount;
            bytes32 selectorSlot;

            // Check if last selector slot is not full
            if (selectorCount & 7 > 0) {
                // get last selectorSlot
                selectorSlot = $.selectorSlots[selectorCount >> 3];
            }

            for (uint256 i; i < facetCuts.length; i++) {
                FacetCut memory facetCut = facetCuts[i];
                FacetCutAction action = facetCut.action;

                if (facetCut.selectors.length == 0) {
                    revert PackageControllerSelectorNotSpecified();
                }

                if (action == FacetCutAction.ADD) {
                    (selectorCount, selectorSlot) = _addFacetSelectors(
                        $,
                        selectorCount,
                        selectorSlot,
                        facetCut
                    );
                } else if (action == FacetCutAction.REPLACE) {
                    _replaceFacetSelectors($, facetCut);
                } else if (action == FacetCutAction.REMOVE) {
                    (selectorCount, selectorSlot) = _removeFacetSelectors(
                        $,
                        selectorCount,
                        selectorSlot,
                        facetCut
                    );
                } else {
                    revert PackageControllerInvalidFacetAction();
                }
            }

            if (selectorCount != originalSelectorCount) {
                $.selectorCount = uint16(selectorCount);
            }

            // If last selector slot is not full
            if (selectorCount & 7 > 0) {
                $.selectorSlots[selectorCount >> 3] = selectorSlot;
            }

            emit DiamondCut(facetCuts, target, data);
            _initialize(target, data);
        }
    }

    function _addFacetSelectors(
        DiamondBaseStorage.Layout storage $,
        uint256 selectorCount,
        bytes32 selectorSlot,
        FacetCut memory facetCut
    ) internal returns (uint256, bytes32) {
        unchecked {
            if (
                facetCut.target != address(this) &&
                !_isContract(facetCut.target)
            ) revert PackageControllerTargetHasNoCode();

            for (uint256 i; i < facetCut.selectors.length; i++) {
                bytes4 selector = facetCut.selectors[i];
                bytes32 oldFacet = $.facets[selector];

                if (address(bytes20(oldFacet)) != address(0))
                    revert PackageControllerSelectorAlreadyAdded();

                // add facet for selector
                $.facets[selector] =
                    bytes20(facetCut.target) |
                    bytes32(selectorCount);
                uint256 selectorInSlotPosition = (selectorCount & 7) << 5;

                // clear selector position in slot and add selector
                selectorSlot =
                    (selectorSlot &
                        ~(CLEAR_SELECTOR_MASK >> selectorInSlotPosition)) |
                    (bytes32(selector) >> selectorInSlotPosition);

                // if slot is full then write it to storage
                if (selectorInSlotPosition == 224) {
                    $.selectorSlots[selectorCount >> 3] = selectorSlot;
                    selectorSlot = 0;
                }

                selectorCount++;
            }

            return (selectorCount, selectorSlot);
        }
    }

    function _removeFacetSelectors(
        DiamondBaseStorage.Layout storage $,
        uint256 selectorCount,
        bytes32 selectorSlot,
        FacetCut memory facetCut
    ) internal returns (uint256, bytes32) {
        unchecked {
            if (facetCut.target != address(0))
                revert PackageControllerRemoveTargetNotZeroAddress();

            uint256 selectorSlotCount = selectorCount >> 3;
            uint256 selectorInSlotIndex = selectorCount & 7;

            for (uint256 i; i < facetCut.selectors.length; i++) {
                bytes4 selector = facetCut.selectors[i];
                bytes32 oldFacet = $.facets[selector];

                if (address(bytes20(oldFacet)) == address(0))
                    revert PackageControllerSelectorNotFound();

                if (
                    address(bytes20(oldFacet)) == address(this) ||
                    selector == 0x1f931c1c
                ) revert PackageControllerSelectorIsImmutable(); // 0x1f931c1c == diamondCut

                if (selectorSlot == 0) {
                    selectorSlotCount--;
                    selectorSlot = $.selectorSlots[selectorSlotCount];
                    selectorInSlotIndex = 7;
                } else {
                    selectorInSlotIndex--;
                }

                bytes4 lastSelector;
                uint256 oldSelectorsSlotCount;
                uint256 oldSelectorInSlotPosition;

                // adding a block here prevents stack too deep error
                {
                    // replace selector with last selector in $.facets
                    lastSelector = bytes4(
                        selectorSlot << (selectorInSlotIndex << 5)
                    );

                    if (lastSelector != selector) {
                        // update last selector slot position info
                        $.facets[lastSelector] =
                            (oldFacet & CLEAR_ADDRESS_MASK) |
                            bytes20($.facets[lastSelector]);
                    }

                    delete $.facets[selector];
                    uint256 oldSelectorCount = uint16(uint256(oldFacet));
                    oldSelectorsSlotCount = oldSelectorCount >> 3;
                    oldSelectorInSlotPosition = (oldSelectorCount & 7) << 5;
                }

                if (oldSelectorsSlotCount != selectorSlotCount) {
                    bytes32 oldSelectorSlot = $.selectorSlots[
                        oldSelectorsSlotCount
                    ];

                    // clears the selector we are deleting and puts the last selector in its place.
                    oldSelectorSlot =
                        (oldSelectorSlot &
                            ~(CLEAR_SELECTOR_MASK >>
                                oldSelectorInSlotPosition)) |
                        (bytes32(lastSelector) >> oldSelectorInSlotPosition);

                    // update storage with the modified slot
                    $.selectorSlots[oldSelectorsSlotCount] = oldSelectorSlot;
                } else {
                    // clears the selector we are deleting and puts the last selector in its place.
                    selectorSlot =
                        (selectorSlot &
                            ~(CLEAR_SELECTOR_MASK >>
                                oldSelectorInSlotPosition)) |
                        (bytes32(lastSelector) >> oldSelectorInSlotPosition);
                }

                if (selectorInSlotIndex == 0) {
                    delete $.selectorSlots[selectorSlotCount];
                    selectorSlot = 0;
                }
            }

            selectorCount = (selectorSlotCount << 3) | selectorInSlotIndex;

            return (selectorCount, selectorSlot);
        }
    }

    function _replaceFacetSelectors(
        DiamondBaseStorage.Layout storage $,
        FacetCut memory facetCut
    ) internal {
        unchecked {
            if (!_isContract(facetCut.target))
                revert PackageControllerTargetHasNoCode();

            for (uint256 i; i < facetCut.selectors.length; i++) {
                bytes4 selector = facetCut.selectors[i];
                bytes32 oldFacet = $.facets[selector];
                address oldFacetAddress = address(bytes20(oldFacet));

                if (oldFacetAddress == address(0))
                    revert PackageControllerSelectorNotFound();
                if (oldFacetAddress == address(this) || selector == 0x1f931c1c)
                    revert PackageControllerSelectorIsImmutable(); // 0x1f931c1c == diamondCut
                if (oldFacetAddress == facetCut.target)
                    revert PackageControllerReplaceTargetIsIdentical();

                // replace old facet address
                $.facets[selector] =
                    (oldFacet & CLEAR_ADDRESS_MASK) |
                    bytes20(facetCut.target);
            }
        }
    }

    function _initialize(address target, bytes memory data) private {
        if ((target == address(0)) != (data.length == 0))
            revert PackageControllerInvalidInitializationParameters();

        if (target != address(0)) {
            if (target != address(this)) {
                if (!_isContract(target))
                    revert PackageControllerTargetHasNoCode();
            }

            (bool success, ) = target.delegatecall(data);

            if (!success) {
                assembly {
                    returndatacopy(0, 0, returndatasize())
                    revert(0, returndatasize())
                }
            }
        }
    }

    function _isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}
