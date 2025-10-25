// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import "./IInitializableInternal.sol";
import "./InitializableStorage.sol";

/**
 * @title Initializable Internal Abstract Contract
 * @notice Provides internal functions and modifiers for initializable management in a Diamond proxy.
 * @dev This abstract contract implements functions and modifiers to manage the initialization process.
 *      inspired from https://github.com/dl-solarity/solidity-lib (MIT license)
 */
abstract contract InitializableInternal is IInitializableInternal {
    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most
     * once for a particular storage in a Diamond proxy that begins with {storageSlot_}.
     * @param storageSlot_ The storage slot to check.
     *
     * In its scope, `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer(bytes32 storageSlot_) {
        InitializableStorage.Layout storage $ = InitializableStorage.layout();

        if ($.initialization[storageSlot_] != InitializationStatus.UnInitialized) {
            revert InitializableInvalidInitialization();
        }

        $.initialization[storageSlot_] = InitializationStatus.Initializing;

        _;

        $.initialization[storageSlot_] = InitializationStatus.Initialized;

        emit Initialized(storageSlot_);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} modifier, directly or indirectly.
     * @param storageSlot_ The storage slot to check.
     */
    modifier onlyInitializing(bytes32 storageSlot_) {
        _checkInitializing(storageSlot_);
        _;
    }

    /**
     * @dev Reverts if the contract is not in an initializing state. See {onlyInitializing}.
     * @param storageSlot_ The storage slot to check.
     */
    function _checkInitializing(bytes32 storageSlot_) internal view {
        if (!_isInitializing(storageSlot_)) {
            revert InitializableNotInitializing();
        }
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers(bytes32 storageSlot_) internal {
        InitializableStorage.Layout storage $ = InitializableStorage.layout();

        if ($.initialization[storageSlot_] != InitializationStatus.UnInitialized) {
            revert InitializableInvalidInitialization();
        }

        $.initialization[storageSlot_] = InitializationStatus.Initialized;

        emit Initialized(storageSlot_);
    }

    /**
     * @dev Internal function that returns the initialization status for the specified storage slot.
     * @param storageSlot_ The storage slot to check.
     */
    function _getInitializing(bytes32 storageSlot_) internal view returns (InitializationStatus) {
        InitializableStorage.Layout storage $ = InitializableStorage.layout();

        return $.initialization[storageSlot_];
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing(bytes32 storageSlot_) internal view returns (bool) {
        InitializableStorage.Layout storage $ = InitializableStorage.layout();

        return $.initialization[storageSlot_] == InitializationStatus.Initializing;
    }
}
