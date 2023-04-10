// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract utilString {
    
    
    
    function generateProductId(
    string memory farm_Governorate,
    string memory farm_City,
    string memory farmer_First_Name,
    uint256 productCode) internal pure returns (string memory){
        bytes memory nameBytes = bytes(farmer_First_Name);
        bytes memory GovernorateBytes = bytes(farm_Governorate);
        bytes memory cityBytes = bytes(farm_City);
        bytes memory productIdBytes = new bytes(8 + nameBytes.length );

         // Add the first two characters of the farm_Governorate to the product ID
        productIdBytes[0] = GovernorateBytes[0];
        productIdBytes[1] = GovernorateBytes[1];
        productIdBytes[2] = '_';
        
        // Add the first two characters of the city to the product ID
        productIdBytes[3] = cityBytes[0];
        productIdBytes[4] = cityBytes[1];
        productIdBytes[5] = '_';

        // Add the name of the farmer to the product ID
        for (uint i = 0; i < nameBytes.length; i++) {
            productIdBytes[6 + i] = nameBytes[i];
        }
        string memory productID;
        // Add the increment value to the end of the product ID
        productID = string(abi.encodePacked(productIdBytes, uintToString(productCode)));
        
        return productID;
    }

    function uintToString(uint256 myNumber) internal pure returns (string memory) {
    return Strings.toString(myNumber);
}
    function timestampToDate(uint256 timestamp) internal pure returns (string memory) {
    uint256 _day = uint256((timestamp / 86400) % 30) + 1;
    uint256 _month = uint256(((timestamp / 2629743) % 12) + 1);
    uint256 _year = uint256((timestamp / 31556926) + 1970 - 2000);
    return string(abi.encodePacked(
        _day < 10 ? "0" : "", uintToString(_day), "/",
        _month < 10 ? "0" : "", uintToString(_month), "/",
        _year < 10 ? "0" : "", uintToString(_year)));
}

function getCurrentDate() public view returns (string memory) {
    uint256 timestamp = block.timestamp;
    uint256 _day = uint256((timestamp / 86400) % 11) + 1;
    uint256 _month = uint256((timestamp / 2629743) % 12) + 1;
    uint256 _year = uint256((timestamp / 31556926) + 1970 - 2000);
    return string(abi.encodePacked(
        _day < 10 ? "0" : "", uintToString(_day), "/",
        _month < 10 ? "0" : "", uintToString(_month), "/",
        _year < 10 ? "0" : "", uintToString(_year)));
}
}