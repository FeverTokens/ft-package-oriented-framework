// SPDX-License-Identifier: Apache-2.0
// FeverTokens Contracts v1.0.0

pragma solidity 0.8.26;

import './IEIP712Internal.sol';
import './EIP712Storage.sol';
import { InitializableInternal } from '../initializable/InitializableInternal.sol';
import '@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol';

/**
 * @title EIP712 Internal Abstract Contract
 * @notice Provides internal functions for EIP712 domain handling and message hashing.
 * @dev This abstract contract implements EIP712 domain separator and message hashing functionalities.
 */
abstract contract EIP712Internal is IEIP712Internal, InitializableInternal {
    bytes32 private constant TYPE_HASH =
        keccak256(
            'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
        );

    /**
     * @dev Initializes the domain separator and parameter caches.
     * The meaning of `name` and `version` is specified in
     * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
     * - `name`: the user readable name of the signing domain, i.e., the name of the DApp or the protocol.
     * - `version`: the current major version of the signing domain.
     * NOTE: These parameters cannot be changed except through a
     * smart contract upgrade.
     */
    function __EIP712_init(string memory name, string memory version) internal {
        __EIP712_init_unchained(name, version);
    }

    /**
     * @dev Initializes the domain separator and parameter caches (unchained version).
     */
    function __EIP712_init_unchained(
        string memory name,
        string memory version
    ) internal initializer(EIP712Storage.STORAGE_SLOT) {
        EIP712Storage.Layout storage $ = EIP712Storage.layout();
        $._name = name;
        $._version = version;
        $._hashedName = 0;
        $._hashedVersion = 0;
    }

    /**
     * @dev Returns the fields and values that describe the domain separator used by this contract for EIP-712 signature.
     */
    function _eip712Domain()
        internal
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
        EIP712Storage.Layout storage $ = EIP712Storage.layout();

        // If the hashed name and version in storage are non-zero, the contract hasn't been properly initialized
        // and the EIP712 domain is not reliable, as it will be missing name and version.
        if ($._hashedName != 0 || $._hashedVersion != 0) revert EIP712Uninitialized();

        return (
            hex'0f',
            _EIP712Name(),
            _EIP712Version(),
            block.chainid,
            address(this),
            bytes32(0),
            new uint256[](0)
        );
    }

    /**
     * @dev Returns the domain separator for the current chain.
     */
    function _domainSeparatorV4() internal view returns (bytes32) {
        return _buildDomainSeparator();
    }

    /**
     * @dev Builds the domain separator for the current chain.
     */
    function _buildDomainSeparator() private view returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    TYPE_HASH,
                    _EIP712NameHash(),
                    _EIP712VersionHash(),
                    block.chainid,
                    address(this)
                )
            );
    }

    /**
     * @dev Given an already hashed struct, this function returns the hash of the fully encoded EIP712 message for this domain.
     * This hash can be used together with {ECDSA-recover} to obtain the signer of a message.
     */
    function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
        return MessageHashUtils.toTypedDataHash(_domainSeparatorV4(), structHash);
    }

    /**
     * @dev The name parameter for the EIP712 domain.
     * NOTE: This function reads from storage by default but can be redefined to return a constant value if gas costs
     * are a concern.
     */
    function _EIP712Name() internal view returns (string memory) {
        EIP712Storage.Layout storage $ = EIP712Storage.layout();
        return $._name;
    }

    /**
     * @dev The version parameter for the EIP712 domain.
     * NOTE: This function reads from storage by default but can be redefined to return a constant value if gas costs
     * are a concern.
     */
    function _EIP712Version() internal view returns (string memory) {
        EIP712Storage.Layout storage $ = EIP712Storage.layout();
        return $._version;
    }

    /**
     * @dev The hash of the name parameter for the EIP712 domain.
     */
    function _EIP712NameHash() internal view returns (bytes32) {
        EIP712Storage.Layout storage $ = EIP712Storage.layout();
        string memory name = _EIP712Name();
        if (bytes(name).length > 0) {
            return keccak256(bytes(name));
        } else {
            bytes32 hashedName = $._hashedName;
            if (hashedName != 0) {
                return hashedName;
            } else {
                return keccak256('');
            }
        }
    }

    /**
     * @dev The hash of the version parameter for the EIP712 domain.
     */
    function _EIP712VersionHash() internal view returns (bytes32) {
        EIP712Storage.Layout storage $ = EIP712Storage.layout();
        string memory version = _EIP712Version();
        if (bytes(version).length > 0) {
            return keccak256(bytes(version));
        } else {
            bytes32 hashedVersion = $._hashedVersion;
            if (hashedVersion != 0) {
                return hashedVersion;
            } else {
                return keccak256('');
            }
        }
    }
}
