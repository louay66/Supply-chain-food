// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Roles.sol";
import "../utils/Context.sol";

// define RetailerRole to manage the adding , rmoving and check a Retailer 
contract RetailerRole is Context {
    using Roles for Roles.Role;

    struct Retailer_info{
        address retailerID;
        string name_Retailer_store;
        string website_Retailer;
        string address_Retailer_store;
    }

    mapping (address=> Retailer_info) Retailer;

//define two event one for add and another for remove Retailer
    event RetailerAdding(address indexed account);
    event RetailerRemoving(address indexed account);

    Roles.Role private Retailers;

    constructor ()  {
    }
    //
    modifier onlyRetailer(){
       require(isRetailer(_msgSender()));
       _;
    }
    function isRetailer(address account) public view returns (bool){
        return Retailers.has(account);
    }
    //define a public function to remove Retailer
    function removeRetailer(address account) public onlyRetailer{
        _removeRetailer(account);
    }
    // Define an internal function '_addRetailer' to add this role, called by 'addNewRetailer'
    function addRetailer (
        string memory name_Retailer_store,
        string memory website_Retailer,
        string memory address_Retailer_store) public {
        address account = _msgSender();
        Retailers.add(account);
        Retailer_info memory info;
        
        info.retailerID = account;
        info.name_Retailer_store = name_Retailer_store;
        info.website_Retailer = website_Retailer;
        info.address_Retailer_store = address_Retailer_store;
        Retailer[account] = info;
        emit RetailerAdding(account);
    }
    // Define an internal function '_removeRetailer' to remove this role, called by 'removeRetailer'
    function _removeRetailer (address account) internal {
        Retailers.remove(account);
        delete Retailer[account];
        emit RetailerRemoving(account);
    }

    function fetch_name_Retailer_store(address account)internal view returns(string memory name_Retailer_store){
            return (Retailer[account].name_Retailer_store);
        }
    function fetch_website_Retailer(address account)internal view returns(string memory website_Retailer){
            return (Retailer[account].website_Retailer);
        }
    function fetch_address_Retailer_store(address account)internal view returns(string memory address_Retailer_store){
            return (Retailer[account].address_Retailer_store);
        }

}