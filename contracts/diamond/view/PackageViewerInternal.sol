// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {DiamondBaseStorage} from "../base/DiamondBaseStorage.sol";
import {Facet, IPackageViewerInternal} from "./IPackageViewerInternal.sol";

/**
 * @title PackageViewerInternal: EIP-2535 "Diamond" proxy introspection internal contract
 * @dev inspired from https://github.com/mudgen/diamond-2 (MIT license)
 */
abstract contract PackageViewerInternal is IPackageViewerInternal {
    function _facets() internal view returns (Facet[] memory diamondFacets) {
        DiamondBaseStorage.Layout storage $ = DiamondBaseStorage.layout();

        diamondFacets = new Facet[]($.selectorCount);

        uint8[] memory numFacetSelectors = new uint8[]($.selectorCount);
        uint256 numFacets;
        uint256 selectorIndex;

        // loop through function selectors
        for (uint256 slotIndex; selectorIndex < $.selectorCount; slotIndex++) {
            bytes32 slot = $.selectorSlots[slotIndex];

            for (uint256 selectorSlotIndex; selectorSlotIndex < 8; selectorSlotIndex++) {
                selectorIndex++;

                if (selectorIndex > $.selectorCount) {
                    break;
                }

                bytes4 selector = bytes4(slot << (selectorSlotIndex << 5));
                address facet = address(bytes20($.facets[selector]));

                bool continueLoop;

                for (uint256 facetIndex; facetIndex < numFacets; facetIndex++) {
                    if (diamondFacets[facetIndex].target == facet) {
                        diamondFacets[facetIndex].selectors[numFacetSelectors[facetIndex]] = selector;
                        // probably will never have more than 256 functions from one facet contract
                        require(numFacetSelectors[facetIndex] < 255);
                        numFacetSelectors[facetIndex]++;
                        continueLoop = true;
                        break;
                    }
                }

                if (continueLoop) {
                    continue;
                }

                diamondFacets[numFacets].target = facet;
                diamondFacets[numFacets].selectors = new bytes4[]($.selectorCount);
                diamondFacets[numFacets].selectors[0] = selector;
                numFacetSelectors[numFacets] = 1;
                numFacets++;
            }
        }

        for (uint256 facetIndex; facetIndex < numFacets; facetIndex++) {
            uint256 numSelectors = numFacetSelectors[facetIndex];
            bytes4[] memory selectors = diamondFacets[facetIndex].selectors;

            // setting the number of selectors
            assembly {
                mstore(selectors, numSelectors)
            }
        }

        // setting the number of facets
        assembly {
            mstore(diamondFacets, numFacets)
        }
    }

    function _facetFunctionSelectors(address facet) internal view returns (bytes4[] memory selectors) {
        DiamondBaseStorage.Layout storage $ = DiamondBaseStorage.layout();

        selectors = new bytes4[]($.selectorCount);

        uint256 numSelectors;
        uint256 selectorIndex;

        // loop through function selectors
        for (uint256 slotIndex; selectorIndex < $.selectorCount; slotIndex++) {
            bytes32 slot = $.selectorSlots[slotIndex];

            for (uint256 selectorSlotIndex; selectorSlotIndex < 8; selectorSlotIndex++) {
                selectorIndex++;

                if (selectorIndex > $.selectorCount) {
                    break;
                }

                bytes4 selector = bytes4(slot << (selectorSlotIndex << 5));

                if (facet == address(bytes20($.facets[selector]))) {
                    selectors[numSelectors] = selector;
                    numSelectors++;
                }
            }
        }

        // set the number of selectors in the array
        assembly {
            mstore(selectors, numSelectors)
        }
    }

    function _facetAddresses() internal view returns (address[] memory addresses) {
        DiamondBaseStorage.Layout storage $ = DiamondBaseStorage.layout();

        addresses = new address[]($.selectorCount);
        uint256 numFacets;
        uint256 selectorIndex;

        for (uint256 slotIndex; selectorIndex < $.selectorCount; slotIndex++) {
            bytes32 slot = $.selectorSlots[slotIndex];

            for (uint256 selectorSlotIndex; selectorSlotIndex < 8; selectorSlotIndex++) {
                selectorIndex++;

                if (selectorIndex > $.selectorCount) {
                    break;
                }

                bytes4 selector = bytes4(slot << (selectorSlotIndex << 5));
                address facet = address(bytes20($.facets[selector]));

                bool continueLoop;

                for (uint256 facetIndex; facetIndex < numFacets; facetIndex++) {
                    if (facet == addresses[facetIndex]) {
                        continueLoop = true;
                        break;
                    }
                }

                if (continueLoop) {
                    continue;
                }

                addresses[numFacets] = facet;
                numFacets++;
            }
        }

        // set the number of facet addresses in the array
        assembly {
            mstore(addresses, numFacets)
        }
    }

    function _facetAddress(bytes4 selector) internal view returns (address facet) {
        facet = address(bytes20(DiamondBaseStorage.layout().facets[selector]));
    }
}
