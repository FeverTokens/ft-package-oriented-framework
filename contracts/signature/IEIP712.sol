// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IEIP712Internal.sol";

/**
 * @title EIP712 Interface
 * @notice Provides the interface for EIP712 domain data and signature functionalities.
 * @dev This interface extends IEIP712Internal to include external functions for accessing EIP712 domain data.
 */
interface IEIP712 is IEIP712Internal {
    /**
     * @notice Returns the fields and values that describe the domain separator used by this contract for EIP-712 signatures.
     * @return fields The EIP-712 domain separator fields.
     * @return name The user readable name of the signing domain.
     * @return version The current major version of the signing domain.
     * @return chainId The ID of the chain where the contract is deployed.
     * @return verifyingContract The address of the contract that will verify the signature.
     * @return salt A unique salt value for the domain.
     * @return extensions Any additional extensions used in the domain.
     */
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
        );
}
