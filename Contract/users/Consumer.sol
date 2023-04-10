// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Roles.sol";
import "../utils/Context.sol";

// define ConsumerRole to manage the adding , rmoving and check a Consumer
contract ConsumerRole is Context {
    using Roles for Roles.Role;

//define two event one for add and another for remove Consumer
    event ConsumerAdding(address indexed account);
    event ConsumerRemoving(address indexed account);

    Roles.Role private Consumers;

//constructor take the address that deploy the contract and add a new Consumer
    constructor ()  {
    }
    //
    modifier onlyConsumer(){
       require(isConsumer(_msgSender()));
       _;
    }
    function isConsumer(address account) public view returns (bool){
        return Consumers.has(account);
    }
    //define a public function to remove Consumer
    function removeConsumer(address account) public onlyConsumer{
        _removeConsumer(account);
    }
    // Define an internal function '_addConsumer' to add this role, called by 'addNewConsumer'
    function addConsumer () public {
        Consumers.add(_msgSender());
        emit ConsumerAdding(_msgSender());
    }
    // Define an internal function '_removeConsumer' to remove this role, called by 'removeConsumer'
    function _removeConsumer (address account) internal {
        Consumers.remove(account);
        emit ConsumerRemoving(account);
    }

}