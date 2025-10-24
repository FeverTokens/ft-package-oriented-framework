// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

struct Facet {
    address target;
    bytes4[] selectors;
}

interface IPackageViewerInternal {}
