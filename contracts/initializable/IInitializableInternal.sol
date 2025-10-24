// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

/**
 * @notice The status of the contract initialization.
 * @dev UnInitialized The contract is not initialized.
 * @dev Initializing The contract is initializing.
 * @dev Initialized The contract is initialized.
 */
enum InitializationStatus {
    UnInitialized,
    Initializing,
    Initialized
}

/**
 * @title Initializable Internal Interface
 * @notice Partial Interface for Initializable defining events and errors used by internal functions.
 */
interface IInitializableInternal {
    /**
     * @notice Emitted when the contract has been initialized.
     * @param storageSlot The storage slot to check.
     */
    event Initialized(bytes32 storageSlot);

    /**
     * @dev The contract is already initialized.
     * @notice Thrown when attempting to initialize an already initialized contract.
     */
    error InitializableInvalidInitialization();

    /**
     * @dev The contract is not initializing.
     * @notice Thrown when an operation requiring initialization is called when the contract is not in the initializing state.
     */
    error InitializableNotInitializing();

    /**
     * @dev The contract failed to initialize facets.
     * @notice Thrown when the initialization process of facets fails.
     */
    error InitializableFailedInitialization();
}
