// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity ^0.8.20;

import { IAccessAuthorization } from "./IAccessAuthorization.sol";
import { AccessAuthorizationInternal } from "./AccessAuthorizationInternal.sol";

/**
 * @title Function-level authorization system
 */
contract AccessAuthorization is
    IAccessAuthorization,
    AccessAuthorizationInternal
{
    /**
     * @notice Adds an authorization for a function signature to be called by members of a specific role
     * @param functionSig The function signature (bytes4 selector)
     * @param role The role that will be authorized to call the function
     */
    function addAuthorization(
        bytes4 functionSig,
        bytes32 role
    ) external virtual onlyRole(_getAdminRole(role)) {
        _addAuthorization(functionSig, role);
    }

    /**
     * @notice Removes an authorization for a function signature from a specific role
     * @param functionSig The function signature (bytes4 selector)
     * @param role The role to remove authorization from
     */
    function removeAuthorization(
        bytes4 functionSig,
        bytes32 role
    ) external virtual onlyRole(_getAdminRole(role)) {
        _removeAuthorization(functionSig, role);
    }

    /**
     * @notice Gets all function signatures authorized for a specific role
     * @param role The role to query authorizations for
     * @return Array of function signatures authorized for the role
     */
    function getAuthorizations(
        bytes32 role
    ) external view virtual returns (bytes4[] memory) {
        return _getAuthorizations(role);
    }

    /**
     * @notice Gets all members of a specific role
     * @param role The role to query members for
     * @return Array of addresses that are members of the role
     */
    function getRoleMembers(
        bytes32 role
    ) external view virtual returns (address[] memory) {
        return _getRoleMembers(role);
    }

    /**
     * @notice Gets the admin role that can manage a specific role
     * @param role The role to query admin for
     * @return The admin role bytes32 identifier
     */
    function getAdminRole(
        bytes32 role
    ) external view virtual returns (bytes32) {
        return _getAdminRole(role);
    }

    /**
     * @notice Checks if an account has a specific role
     * @param role The role to check
     * @param account The account to check
     * @return True if the account has the role, false otherwise
     */
    function hasRole(
        bytes32 role,
        address account
    ) external view virtual returns (bool) {
        return _hasRole(role, account);
    }

    /**
     * @notice Grants a role to an account
     * @param role The role to grant
     * @param account The account to grant the role to
     */
    function grantRole(
        bytes32 role,
        address account
    ) external virtual onlyRole(_getAdminRole(role)) {
        _grantRole(role, account);
    }

    /**
     * @notice Revokes a role from an account
     * @param role The role to revoke
     * @param account The account to revoke the role from
     */
    function revokeRole(
        bytes32 role,
        address account
    ) external virtual onlyRole(_getAdminRole(role)) {
        _revokeRole(role, account);
    }

    /**
     * @notice Allows an account to renounce a role they have
     * @param role The role to renounce
     */
    function renounceRole(bytes32 role) external virtual {
        _renounceRole(role);
    }

    /**
     * @notice Sets the admin role for a role
     * @param role The role to set admin for
     * @param adminRole The admin role to set
     */
    function setRoleAdmin(
        bytes32 role,
        bytes32 adminRole
    ) external virtual onlyRole(_getAdminRole(role)) {
        _setRoleAdmin(role, adminRole);
    }
}
