// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Roles.sol";
import "../utils/Context.sol";

// define DistributorRole to manage the adding , rmoving and check a Distributor 
contract DistributorRole is Context {
    using Roles for Roles.Role;


    struct Distributor_info{
        address distributorID;
        string name_Distribution_company;
        string phone_Distribution;
        string website_Distribution;
        string address_Distribution_company;
    }

    mapping (address=> Distributor_info) Distributor;
//define two event one for add and another for remove Distributor
    event DistributorAdding(address indexed account);
    event DistributorRemoving(address indexed account);

    Roles.Role private Distributors;

    constructor ()  {
    }
    //
    modifier onlyDistributor(){
       require(isDistributor(_msgSender()));
       _;
    }
    // Define an internal function '_addDistributor' to add this role, called by 'addNewDistributor'
    function addDistributor (
    string memory name_Distribution_company,
    string memory phone_Distribution,
    string memory website_Distribution,
    string memory address_Distribution_company) public {
        address account = _msgSender();
        Distributors.add(account);
        Distributor_info memory info;
        info.distributorID = account;
        info.name_Distribution_company = name_Distribution_company;
        info.phone_Distribution = phone_Distribution;
        info.website_Distribution = website_Distribution;
        info.address_Distribution_company = address_Distribution_company;
        Distributor[account] = info;

        emit DistributorAdding(account);
    }

    
    function isDistributor(address account) public view returns (bool){
        return Distributors.has(account);
    }
    
    //define a public function to remove Distributor
    function removeDistributor(address account) public onlyDistributor{
        _removeDistributor(account);
    }
    // Define an internal function '_removeDistributor' to remove this role, called by 'removeDistributor'
    function _removeDistributor (address account) internal {
        Distributors.remove(account);
        delete Distributor[account];
        emit DistributorRemoving(account);
    }

    function fetch_name_Distribution_company(address account)internal view returns(string memory name_Distribution_company){
            return (Distributor[account].name_Distribution_company);
        }
    
    function fetch_phone_Distribution(address account)internal view returns(string memory phone_Distribution){
            return (Distributor[account].phone_Distribution);
        }
    function fetch_website_Distribution(address account)internal view returns(string memory website_Distribution){
            return (Distributor[account].website_Distribution);
        }
    function fetch_address_Distribution_company(address account)internal view returns(string memory address_Distribution_company){
            return (Distributor[account].address_Distribution_company);
        }
}