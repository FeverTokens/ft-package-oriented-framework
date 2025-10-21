// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity ^0.8.20;

interface IAccessAuthorizationInternal {
    /**
     * @dev Emitted when `function_signature` is authorized to be called by members of `role`.
     *
     * `sender` is the account that originated the contract call.
     */
    event FunctionAuthorized(
        bytes4 indexed function_signature,
        bytes32 indexed role,
        address indexed sender
    );

    /**
     * @dev Emitted when `function_signature` is no longer authorized to be called by members of `role`.
     *
     * `sender` is the account that originated the contract call.
     */
    event FunctionAuthorizationRemoved(
        bytes4 indexed function_signature,
        bytes32 indexed role,
        address indexed sender
    );

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessAuthorization-_setupRole}.
     */
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     */
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );
}
