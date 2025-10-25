// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import "./IInitializableInternal.sol";

/// @title Initializable Interface
/// @notice Interface for initializing facets/packages with the given initialization data.
/// @dev This interface inherits from IInitializableInternal and defines the initialize function.
interface IInitializable is IInitializableInternal {
    /**
     * @notice Returns the initialization status for the specified storage slot.
     * @param storageSlot_ The storage slot to check.
     * @return The {InitializationStatus} of the storage slot.
     */
    function getInitializing(bytes32 storageSlot_) external view returns (InitializationStatus);
}
