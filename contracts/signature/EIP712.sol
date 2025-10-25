// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IEIP712.sol";
import "./EIP712Internal.sol";

/// @title EIP712 Package Contract
/// @notice Provides EIP-712 domain information.
/// @dev Inherits from IEIP712 and EIP712Internal, exposing public functions to be called through the Diamond Proxy through `delegatecall`.
contract EIP712 is IEIP712, EIP712Internal {
    /// @inheritdoc IEIP712
    function eip712Domain()
        external
        view
        returns (
            bytes1 fields,
            string memory name,
            string memory version,
            uint256 chainId,
            address verifyingContract,
            bytes32 salt,
            uint256[] memory extensions
        )
    {
        return _eip712Domain();
    }
}
