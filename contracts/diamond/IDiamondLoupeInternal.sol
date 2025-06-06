// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity ^0.8.20;

interface IDiamondLoupeInternal {
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }
}
