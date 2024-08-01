// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WeightCheck {

    // Define cost per gram
    uint256 public costPerGram = 1; // Example cost per gram (in wei)

    // Define the threshold deviation percentage
    uint256 public deviationThreshold = 2; // 2%

    // Event for additional charges
    event AdditionalCharge(address indexed customer, uint256 amount);
    // Event for successful processing without additional charge
    event Done(address indexed customer);

    // Function to check weight and handle charges
    function checkWeightAndCalculateCharges(
        uint256 predefinedWeight,
        uint256 weightAtFacility
    ) public {
        uint256 deviation = calculateDeviation(predefinedWeight, weightAtFacility);

        if (deviation <= deviationThreshold) {
            emit Done(msg.sender);
        } else {
            uint256 additionalWeight = predefinedWeight > weightAtFacility
                ? predefinedWeight - weightAtFacility
                : 0;

            uint256 extraCharge = calculateExtraCharge(additionalWeight);

            // Emit the additional charge event with the calculated amount
            emit AdditionalCharge(msg.sender, extraCharge);
        }
    }

    // Function to calculate deviation percentage
    function calculateDeviation(uint256 predefinedWeight, uint256 weightAtFacility) internal pure returns (uint256) {
        if (predefinedWeight == 0) return 0;
        return ((predefinedWeight > weightAtFacility ? predefinedWeight - weightAtFacility : weightAtFacility - predefinedWeight) * 100) / predefinedWeight;
    }

    // Function to calculate extra charge
    function calculateExtraCharge(uint256 additionalWeight) internal view returns (uint256) {
        return additionalWeight * costPerGram;
    }

    // Function to withdraw contract balance (for testing or administrative purposes)
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Fallback function to receive ETH
    receive() external payable {}
}
