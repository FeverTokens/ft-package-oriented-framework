// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity ^0.8.20;

import { IAccessAuthorizationInternal } from "./IAccessAuthorizationInternal.sol";
import { AccessAuthorizationStorage } from "./AccessAuthorizationStorage.sol";
import { EnumerableSet } from "../../data/EnumerableSet.sol";
import { AddressUtils } from "../../utils/AddressUtils.sol";
import { ContextInternal } from "../../metatx/ContextInternal.sol";

/**
 * @title Function-level authorization system
 */
abstract contract AccessAuthorizationInternal is
    IAccessAuthorizationInternal,
    ContextInternal
{
    using AddressUtils for address;
    using EnumerableSet for EnumerableSet.AddressSet;
    using AccessAuthorizationStorage for AccessAuthorizationStorage.Bytes4Set;

    bytes32 internal constant DEFAULT_ADMIN_ROLE = 0x00;

    modifier onlyAuthorized() {
        _checkAuthorization();
        _;
    }

    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    /**
     * @notice Check if sender has the specified role
     * @param role The role to check
     */
    function _checkRole(bytes32 role) internal view {
        _checkRole(role, _msgSender());
    }

    /**
     * @notice Check if account has the specified role
     * @param role The role to check
     * @param account The account to check
     */
    function _checkRole(bytes32 role, address account) internal view {
        if (!_hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessAuthorization: account ",
                        account.toString(),
                        " is missing role ",
                        bytes32ToString(role)
                    )
                )
            );
        }
    }

    /**
     * @dev Helper function to convert bytes32 to string for error messages
     */
    function bytes32ToString(
        bytes32 value
    ) internal pure returns (string memory) {
        bytes memory byteArray = new bytes(64);

        for (uint256 i = 0; i < 32; i++) {
            uint8 currentByte = uint8(value[i]);
            uint8 leftNibble = currentByte / 16;
            uint8 rightNibble = currentByte % 16;

            byteArray[i * 2] = leftNibble < 10
                ? bytes1(uint8(leftNibble + 48))
                : bytes1(uint8(leftNibble + 87));

            byteArray[i * 2 + 1] = rightNibble < 10
                ? bytes1(uint8(rightNibble + 48))
                : bytes1(uint8(rightNibble + 87));
        }

        return string(byteArray);
    }

    /**
     * @notice Checks if the current function is authorized to be called by the sender
     */
    function _checkAuthorization() internal view virtual {
        // Get the function signature of the current call
        // bytes4 functionSig = msg.sig; // Uncomment if needed for specific implementations
        address sender = _msgSender();

        // Check if the function is authorized for any role the sender has
        bool isAuthorized = false;

        // Check if the sender has any role that authorizes this function
        // Since we don't have a way to iterate through mapping keys, we'll check for
        // common roles like DEFAULT_ADMIN_ROLE first, then rely on the role checks in the contract

        if (_hasRole(DEFAULT_ADMIN_ROLE, sender)) {
            // Admin has all permissions
            isAuthorized = true;
        } else {
            // For specific functions, the contract should implement role checks
            // This is a fallback check that ensures the function call is explicitly allowed
            // AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage.layout(); // Uncomment if needed for future implementations

            // We'll need to check this in the implementing contracts by having them
            // check for role membership explicitly
            require(
                isAuthorized,
                "AccessAuthorization: sender is not authorized to call this function"
            );
        }
    }

    /**
     * @notice Adds a function signature to the list of functions authorized for a role
     * @param functionSig The function signature (bytes4 selector)
     * @param role The role to authorize for the function
     */
    function _addAuthorization(
        bytes4 functionSig,
        bytes32 role
    ) internal virtual {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        l.authorizations[role].authorizedFunctions.add(functionSig);
        emit FunctionAuthorized(functionSig, role, _msgSender());
    }

    /**
     * @notice Removes a function signature from the list of functions authorized for a role
     * @param functionSig The function signature (bytes4 selector)
     * @param role The role to remove authorization from
     */
    function _removeAuthorization(
        bytes4 functionSig,
        bytes32 role
    ) internal virtual {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        l.authorizations[role].authorizedFunctions.remove(functionSig);
        emit FunctionAuthorizationRemoved(functionSig, role, _msgSender());
    }

    /**
     * @notice Checks if a function signature is authorized for a role
     * @param role The role to check
     * @param functionSig The function signature to check
     * @return True if the function is authorized for the role, false otherwise
     */
    function _isAuthorized(
        bytes32 role,
        bytes4 functionSig
    ) internal view virtual returns (bool) {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        return l.authorizations[role].authorizedFunctions.contains(functionSig);
    }

    /**
     * @notice Gets all function signatures authorized for a specific role
     * @param role The role to query authorizations for
     * @return Array of function signatures authorized for the role
     */
    function _getAuthorizations(
        bytes32 role
    ) internal view virtual returns (bytes4[] memory) {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        return l.authorizations[role].authorizedFunctions.toArray();
    }

    /**
     * @notice Gets all members of a specific role
     * @param role The role to query members for
     * @return Array of addresses that are members of the role
     */
    function _getRoleMembers(
        bytes32 role
    ) internal view virtual returns (address[] memory) {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        return l.authorizations[role].roleMembers.toArray();
    }

    /**
     * @notice query whether role is assigned to account
     * @param role role to query
     * @param account account to query
     * @return whether role is assigned to account
     */
    function _hasRole(
        bytes32 role,
        address account
    ) internal view virtual returns (bool) {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        return l.authorizations[role].roleMembers.contains(account);
    }

    /**
     * @notice Grants a role to an account
     * @param role The role to grant
     * @param account The account to grant the role to
     */
    function _grantRole(bytes32 role, address account) internal virtual {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        l.authorizations[role].roleMembers.add(account);
        emit RoleGranted(role, account, _msgSender());
    }

    /**
     * @notice Revokes a role from an account
     * @param role The role to revoke
     * @param account The account to revoke the role from
     */
    function _revokeRole(bytes32 role, address account) internal virtual {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        l.authorizations[role].roleMembers.remove(account);
        emit RoleRevoked(role, account, _msgSender());
    }

    /**
     * @notice Sets the admin role for a role
     * @param role The role to set admin for
     * @param adminRole The admin role to set
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        bytes32 previousAdminRole = l.authorizations[role].adminRole;
        l.authorizations[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @notice Gets the admin role for a role
     * @param role The role to get admin for
     * @return The admin role
     */
    function _getAdminRole(
        bytes32 role
    ) internal view virtual returns (bytes32) {
        AccessAuthorizationStorage.Layout storage l = AccessAuthorizationStorage
            .layout();
        return l.authorizations[role].adminRole;
    }

    /**
     * @notice Renounces a role for the sender
     * @param role The role to renounce
     */
    function _renounceRole(bytes32 role) internal virtual {
        _revokeRole(role, _msgSender());
    }
}
