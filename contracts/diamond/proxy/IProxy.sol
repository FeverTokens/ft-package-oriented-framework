// SPDX-License-Identifier: Apache-2.0

pragma solidity 0.8.26;

interface IProxy {
    error ProxyImplementationIsNotContract();

    fallback() external payable;
}
