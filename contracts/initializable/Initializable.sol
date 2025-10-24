// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import "./IInitializable.sol";
import "./InitializableInternal.sol";

/**
 * @title Initializable Package Contract
 * @notice This contract provides the functionality to initialize facets/packages with the given initialization data.
 * @dev This contract inherits from IInitializable and InitializableInternal, exposing public functions to be called through the Diamond Proxy through `delegatecall`.
 */
contract Initializable is IInitializable, InitializableInternal {
    /**
     * @inheritdoc IInitializable
     */
    function getInitializing(bytes32 storageSlot_) external view returns (InitializationStatus) {
        return _getInitializing(storageSlot_);
    }
}
