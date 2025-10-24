// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

interface IProxy {
    error ProxyImplementationIsNotContract();

    fallback() external payable;
}
