// SPDX-License-Identifier: MIT
// FeverTokens Contracts v1.0.0

pragma solidity ^0.8.20;

import { EnumerableSet } from "../../data/EnumerableSet.sol";

library AccessAuthorizationStorage {
    // Adding Bytes4Set since it's not in the EnumerableSet library
    struct Bytes4Set {
        EnumerableSet.Set _inner;
    }

    // Helper functions for Bytes4Set - using direct Set operations
    function at(
        Bytes4Set storage set,
        uint256 index
    ) internal view returns (bytes4) {
        bytes32 value;
        // We need to use assembly to access the values directly
        assembly {
            // Get the storage slot of the _values array in the Set
            let valuesSlot := add(set.slot, 0)

            // Load the array length
            let arrayLength := sload(valuesSlot)

            // Check if index is in range
            if iszero(lt(index, arrayLength)) {
                // Out of bounds error
                revert(0, 0)
            }

            // Calculate the storage slot of the element at index
            let dataSlot := add(keccak256(valuesSlot, 0x20), index)

            // Load the value
            value := sload(dataSlot)
        }
        return bytes4(value);
    }

    function contains(
        Bytes4Set storage set,
        bytes4 value
    ) internal view returns (bool) {
        return _contains(set, value);
    }

    function length(Bytes4Set storage set) internal view returns (uint256) {
        return _length(set);
    }

    function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
        return _add(set, value);
    }

    function remove(
        Bytes4Set storage set,
        bytes4 value
    ) internal returns (bool) {
        return _remove(set, value);
    }

    function toArray(
        Bytes4Set storage set
    ) internal view returns (bytes4[] memory) {
        uint256 len = length(set);
        bytes4[] memory result = new bytes4[](len);

        for (uint256 i = 0; i < len; i++) {
            result[i] = at(set, i);
        }

        return result;
    }

    // Private helper functions that mirror EnumerableSet functionality
    function _contains(
        Bytes4Set storage set,
        bytes4 value
    ) private view returns (bool) {
        // We convert bytes4 to bytes32 for storage
        bytes32 valueAsBytes32 = bytes32(uint256(uint32(value)));

        // Use inline assembly to check if the value exists in the set
        uint256 index;
        assembly {
            // Get the storage slot for _indexes mapping
            let indexesSlot := add(set.slot, 1) // _indexes is the second field in the struct

            // Calculate the slot where the index is stored
            mstore(0, valueAsBytes32)
            mstore(0x20, indexesSlot)
            let mappingSlot := keccak256(0, 0x40)

            // Load the index (1-indexed, so 0 means not present)
            index := sload(mappingSlot)
        }

        return index != 0;
    }

    function _length(Bytes4Set storage set) private view returns (uint256) {
        uint256 setLength;
        assembly {
            // Get the storage slot of the _values array in the Set
            let valuesSlot := add(set.slot, 0)

            // Load the array length
            setLength := sload(valuesSlot)
        }
        return setLength;
    }

    function _add(Bytes4Set storage set, bytes4 value) private returns (bool) {
        bytes32 valueAsBytes32 = bytes32(uint256(uint32(value)));

        if (!_contains(set, value)) {
            assembly {
                // Get the storage slot of the _values array
                let valuesSlot := add(set.slot, 0)

                // Get current length
                let arrayLength := sload(valuesSlot)

                // Store value at the end of the array
                let valuesArr := keccak256(valuesSlot, 0x20)
                sstore(add(valuesArr, arrayLength), valueAsBytes32)

                // Update length
                sstore(valuesSlot, add(arrayLength, 1))

                // Update index mapping
                let indexesSlot := add(set.slot, 1)

                // Store 1-based index (length + 1)
                mstore(0, valueAsBytes32)
                mstore(0x20, indexesSlot)
                let mappingSlot := keccak256(0, 0x40)
                sstore(mappingSlot, add(arrayLength, 1))
            }
            return true;
        }
        return false;
    }

    function _remove(
        Bytes4Set storage set,
        bytes4 value
    ) private returns (bool) {
        bytes32 valueAsBytes32 = bytes32(uint256(uint32(value)));

        // Get the index (1-based)
        uint256 valueIndex;
        assembly {
            let indexesSlot := add(set.slot, 1)
            mstore(0, valueAsBytes32)
            mstore(0x20, indexesSlot)
            let mappingSlot := keccak256(0, 0x40)
            valueIndex := sload(mappingSlot)
        }

        if (valueIndex != 0) {
            // Convert to 0-based index
            valueIndex--;

            // Get the last element and its index
            uint256 lastIndex;
            bytes32 lastValue;

            assembly {
                // Get values array slot
                let valuesSlot := add(set.slot, 0)

                // Get length
                let arrayLength := sload(valuesSlot)

                // Calculate last index
                lastIndex := sub(arrayLength, 1)

                // Calculate values array hash once
                let valuesArr := keccak256(valuesSlot, 0x20)

                // Get last value
                let lastValueSlot := add(valuesArr, lastIndex)
                lastValue := sload(lastValueSlot)

                // If it's not the last element, move the last element to the removed position
                if iszero(eq(valueIndex, lastIndex)) {
                    let valueSlot := add(valuesArr, valueIndex)
                    sstore(valueSlot, lastValue)

                    // Update index mapping for the moved element
                    let indexesSlot := add(set.slot, 1)
                    mstore(0, lastValue)
                    mstore(0x20, indexesSlot)
                    let lastMappingSlot := keccak256(0, 0x40)
                    sstore(lastMappingSlot, add(valueIndex, 1))
                }

                // Delete the last element
                sstore(add(valuesArr, lastIndex), 0) // Clear the slot

                // Decrement length
                sstore(valuesSlot, lastIndex)

                // Delete the index mapping entry
                let indexesSlot := add(set.slot, 1)
                mstore(0, valueAsBytes32)
                mstore(0x20, indexesSlot)
                let mappingSlot := keccak256(0, 0x40)
                sstore(mappingSlot, 0)
            }

            return true;
        }

        return false;
    }

    // Main storage structures
    struct AuthorizationData {
        EnumerableSet.AddressSet roleMembers;
        Bytes4Set authorizedFunctions;
        bytes32 adminRole;
    }

    struct Layout {
        mapping(bytes32 => AuthorizationData) authorizations;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256("fevertokens.contracts.storage.AccessAuthorization");

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
