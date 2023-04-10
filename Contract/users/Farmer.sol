//// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Roles.sol";
import "../utils/Context.sol";

// define farmerRole to manage the adding, removing and checking a farmer
contract FarmerRole is Context {
    using Roles for Roles.Role;


    struct farmer_info{
        address farmerID; // Metamask-Ethereum address of the Farmer // ADDED PAYABLE
        //farmer information 
        string farmer_First_Name; 
        string farmer_Last_Name;
        string farmer_phone; 
        string farmer_Address;
        //farm information 
        string farm_Country;
        string farm_Governorate;
        string farm_City;
        string farm_Address;
        uint256 farm_area;
        string type_of_soil;
        uint8 number_of_wells;
        uint8 number_of_boreholes;
        uint256 farm_Lat; //geo_location
        uint256 farm_Long; //geo_location

    }
    mapping (address=> farmer_info) farmer;

    //define two event one for add and another for remove farmer
    event FarmerAdding(address indexed account);
    event FarmerRemoving(address indexed account);

    Roles.Role private Farmers;

    //constructor take the address that deploy the contract and add a new farmer
    constructor (){
    }
    //
    modifier onlyFarmer(){
       require(isFarmer(_msgSender()));
       _;
    }
    function isFarmer(address account) public  view returns (bool){
        return Farmers.has(account);
    }
    //define a public function to add new Farmer
   /* function addNewFarmer(address account) public onlyFarmer{
        _addFarmer(account);
    }*/
    //define a public function to remove Farmer
    function removeFarmer(address account) public onlyFarmer{
        _removeFarmer(account);
    }
    // Define an internal function '_addFarmer' to add this role, called by 'addNewFarmer'
    function addFarmer ( 
        string memory farmer_First_Name,
        string memory farmer_Last_Name,
        string memory farmer_phone, 
        string memory farmer_Address) public {
        address account = _msgSender();
        farmer_info memory farmerInfo;
        Farmers.add(account);

        farmerInfo.farmerID = _msgSender();
        farmerInfo.farmer_First_Name = farmer_First_Name;
        farmerInfo.farmer_Last_Name = farmer_Last_Name;
        farmerInfo.farmer_phone = farmer_phone;
        farmerInfo.farmer_Address = farmer_Address;
        farmer[account] = farmerInfo;
        emit FarmerAdding(account);
    }
    function Farm_info ( 
        string memory farm_Country,
        string memory farm_Governorate,
        string memory farm_City, 
        string memory farm_Address,
        uint256 farm_Lat,
        uint256 farm_Long) public onlyFarmer {
        address account = _msgSender();
        farmer[account].farm_Country = farm_Country;
        farmer[account].farm_Governorate = farm_Governorate;
        farmer[account].farm_City = farm_City;
        farmer[account].farm_Address = farm_Address;
        farmer[account].farm_Lat = farm_Lat;
        farmer[account].farm_Long = farm_Long;
    }
    function more_Farm_info (
        uint256 farm_area,
        string memory type_soil,
        uint8 number_of_wells, 
        uint8 number_of_boreholes) public onlyFarmer{
        address account = _msgSender();
        farmer[account].farm_area = farm_area;
        farmer[account].type_of_soil =  type_soil;
        farmer[account].number_of_wells = number_of_wells;
        farmer[account].number_of_boreholes = number_of_boreholes;
    }

    // Define an internal function '_removeDistributor' to remove this role, called by 'removeFarmer'
    function _removeFarmer (address account) internal {
        Farmers.remove(account);
        delete farmer[account];
        emit FarmerRemoving(account);
    }
        
        function fetch_farmer_First_Name(address account)internal view returns(string memory farmer_First_Name){
            return (farmer[account].farmer_First_Name);
        }

        function fetch_farmer_Last_Name(address account)internal view returns(string memory farmer_Last_Name){
            return (farmer[account].farmer_Last_Name);
        }
        
        function fetch_farmer_phone(address account)internal view returns(string memory farmer_phone){
            return (farmer[account].farmer_phone);
        }

        function fetch_farmer_Address(address account)internal view returns(string memory farmer_Address){
            return (farmer[account].farmer_Address);
        }

        function fetch_farm_Country(address account)internal view returns(string memory farm_Country){
            return (farmer[account].farm_Country);
        }
        
        function fetch_farm_Governorate(address account)internal view returns(string memory farm_Governorate){
            return (farmer[account].farm_Governorate);
        }

        function fetch_farm_City(address account)internal view returns(string memory farm_City){
            return (farmer[account].farm_City);
        }

        function fetch_farm_Address(address account)internal view returns(string memory farm_Address){
            return (farmer[account].farm_Address);
        }

        function fetch_farm_area(address account)internal view returns(uint256 farm_area){
            return (farmer[account].farm_area);
        }

        function fetch_type_of_soil(address account)internal view returns(string memory type_of_soil){
            return (farmer[account].type_of_soil);
        }

        function fetch_number_of_wells(address account)internal view returns(uint8 number_of_wells){
            return (farmer[account].number_of_wells);
        }

        function fetch_number_of_boreholes(address account)internal view returns(uint8 number_of_boreholes){
            return (farmer[account].number_of_boreholes);
        }

        function fetch_farm_Lat(address account)internal view returns(uint256 farm_Lat){
            return (farmer[account].farm_Lat);
        }

        function fetch_farm_Long(address account)internal view returns(uint256 farm_Long){
            return (farmer[account].farm_Long);
        }
}
