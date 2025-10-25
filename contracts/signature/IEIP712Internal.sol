// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

/**
 * @title EIP712 Internal Interface
 * @notice Partial Interface for EIP712 needed by internal functions.
 */
interface IEIP712Internal {
    /**
     * @dev MAY be emitted to signal that the domain could have changed.
     */
    event EIP712DomainChanged();

    /**
     * @dev The EIP712 Contract was not properly initialized.
     * @notice Thrown when the EIP712 contract is not initialized.
     */
    error EIP712Uninitialized();
}
