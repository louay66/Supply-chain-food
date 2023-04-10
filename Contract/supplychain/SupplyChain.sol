// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../users/Farmer.sol";
import "../users/Distributor.sol";
import "../users/Retailer.sol";
import "../users/Consumer.sol";
import "../Ownership/Ownable.sol";
import "../utils/Strings.sol";


contract SupplyChain is 
FarmerRole,
DistributorRole,
RetailerRole,
ConsumerRole,
Ownable,
utilString
 {

    address owner;

    uint256 prudactCode;


    // define mapping 'items' of prudact code to item info 
    mapping(uint256 => Item) items;

    // define mapping "itemsHistory" of prudactcode to transtion block 
    //to track prodct journey through the supply chain
    mapping(uint256 => Txblocks) itemsHistory;

    // define enum with 12  steps of prudact cycle
    enum State {
        ProduceByFarmer, // 0
        ForSaleByFarmer, // 1
        PurchasedByDistributor, // 2
        ShippedByFarmer, // 3
        ReceivedByDistributor, // 4
        ProcessedByDistributor, // 5
        PackageByDistributor, // 6
        ForSaleByDistributor, // 7
        PurchasedByRetailer, // 8
        ShippedByDistributor, // 9
        ReceivedByRetailer, // 10
        ForSaleByRetailer, // 11
        PurchasedByConsumer // 12
    }
    // Define a struct 'Item' with the following fields:
    struct Item {
        uint256 stockUnit; 
        uint256 productCode; 
        address ownerID; // Metamask-Ethereum address of the current owner as the product moves through 8 stages
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
        // product information 
        string productID;
        string product_name;
        string plant_type;
        string productDate; 
        uint256 productPrice;
        //Distributor information 
        string name_Distribution_company;
        string phone_Distribution;
        string website_Distribution;
        string address_Distribution_company;
        // Retailer information
        string name_Retailer_store;
        string website_Retailer;
        string address_Retailer_store;

        State itemState; 
        address distributorID; // Metamask-Ethereum address of the Distributor
        address retailerID; // Metamask-Ethereum address of the Retailer
        address consumerID; // Metamask-Ethereum address of the Consumer // ADDED payable
    }

    // Block number stuct
    struct Txblocks {
        uint256 FTD; // blockfarmerToDistributor
        uint256 DTR; // blockDistributorToRetailer
        uint256 RTC; // blockRetailerToConsumer
    }
    
    event ProduceByFarmer(uint256 productCode); //1
    event ForSaleByFarmer(uint256 productCode); //2
    event PurchasedByDistributor(uint256 productCode); //3
    event ShippedByFarmer(uint256 productCode); //4
    event ReceivedByDistributor(uint256 productCode); //5
    event ProcessedByDistributor(uint256 productCode); //6
    event PackagedByDistributor(uint256 productCode); //7
    event ForSaleByDistributor(uint256 productCode); //8
    event PurchasedByRetailer(uint256 productCode); //9
    event ShippedByDistributor(uint256 productCode); //10
    event ReceivedByRetailer(uint256 productCode); //11
    event ForSaleByRetailer(uint256 productCode); //12
    event PurchasedByConsumer(uint256 productCode); //13



    modifier only_Owner() {
        require(_msgSender() == owner);
        _;
    }
    // Define a modifer that verifies the Caller
    modifier verifyCaller(address _address) {
        require(_msgSender() == _address);
        _;
    }
    
    //Item State Modifiers
    modifier producedByFarmer(uint256 _productCode) {
        require(items[_productCode].itemState == State.ProduceByFarmer);
        _;
    }

    modifier forSaleByFarmer(uint256 _productCode) {
        require(items[_productCode].itemState == State.ForSaleByFarmer);
        _;
    }

    modifier purchasedByDistributor(uint256 _productCode) {
        require(items[_productCode].itemState == State.PurchasedByDistributor);
        _;
    }

    modifier shippedByFarmer(uint256 _productCode) {
        require(items[_productCode].itemState == State.ShippedByFarmer);
        _;
    }

    modifier receivedByDistributor(uint256 _productCode) {
        require(items[_productCode].itemState == State.ReceivedByDistributor);
        _;
    }

    modifier processByDistributor(uint256 _productCode) {
        require(items[_productCode].itemState == State.ProcessedByDistributor);
        _;
    }

    modifier packagedByDistributor(uint256 _productCode) {
        require(items[_productCode].itemState == State.PackageByDistributor);
        _;
    }

    modifier forSaleByDistributor(uint256 _productCode) {
        require(items[_productCode].itemState == State.ForSaleByDistributor);
        _;
    }

    modifier shippedByDistributor(uint256 _productCode) {
        require(items[_productCode].itemState == State.ShippedByDistributor);
        _;
    }

    modifier purchasedByRetailer(uint256 _productCode) {
        require(items[_productCode].itemState == State.PurchasedByRetailer);
        _;
    }

    modifier receivedByRetailer(uint256 _productCode) {
        require(items[_productCode].itemState == State.ReceivedByRetailer);
        _;
    }

    modifier forSaleByRetailer(uint256 _productCode) {
        require(items[_productCode].itemState == State.ForSaleByRetailer);
        _;
    }

    modifier purchasedByConsumer(uint256 _productCode) {
        require(items[_productCode].itemState == State.PurchasedByConsumer);
        _;
    }

    // constructor setup owner productCode
    constructor() {
        owner = _msgSender();
        prudactCode = 1;
    }

    /*
    1st step in supplychain
    Allows farmer to create product
    */
     function _1_produceItemByFarmer(
        string memory product_name,
        uint256 stockUnit,
        string memory plant_type,
        uint256  productPrice
        )public  onlyFarmer {
        
        address distributorID; // Empty distributorID address
        address retailerID; // Empty retailerID address
        address consumerID; // Empty consumerID address
        Item memory newItem; // Create a new struct Item in memory
        newItem.productCode = prudactCode;
        newItem.stockUnit = stockUnit;
        newItem.ownerID = _msgSender();
        newItem.farmerID = _msgSender();
        newItem.farmer_First_Name = fetch_farmer_First_Name(_msgSender());
        newItem.farmer_Last_Name = fetch_farmer_Last_Name(_msgSender());
        newItem.farmer_phone = fetch_farmer_phone(_msgSender());
        newItem.farmer_Address = fetch_farmer_Address(_msgSender());
        newItem.farm_Country = fetch_farm_Country(_msgSender());
        newItem.farm_Governorate = fetch_farm_Governorate(_msgSender());
        newItem.farm_City = fetch_farm_City(_msgSender());
        newItem.farm_Address = fetch_farm_Address(_msgSender());
        newItem.farm_area = fetch_farm_area(_msgSender());
        newItem.type_of_soil = fetch_type_of_soil(_msgSender());
        newItem.number_of_wells = fetch_number_of_wells(_msgSender());
        newItem.number_of_boreholes = fetch_number_of_boreholes(_msgSender());
        newItem.farm_Lat = fetch_farm_Lat(_msgSender());
        newItem.farm_Long = fetch_farm_Long(_msgSender());
        newItem.farm_Long = fetch_farm_Long(_msgSender());
        newItem.product_name = product_name;
        newItem.plant_type = plant_type;
        newItem.productPrice = productPrice;
        newItem.productDate=timestampToDate(block.timestamp);
        newItem.itemState = State.ProduceByFarmer;
        newItem.distributorID = distributorID;
        newItem.retailerID = retailerID;
        newItem.consumerID = consumerID;
        newItem.productID = generateProductId(newItem.farm_Governorate,
                                                            newItem.farm_City,
                                                            newItem.farmer_First_Name,
                                                            newItem.productCode);
        items[prudactCode] = newItem;
        Txblocks memory txBlock; // create new txBlock struct
        txBlock.FTD = 0; // assign value
        txBlock.DTR = 0;
        txBlock.RTC = 0;
        itemsHistory[prudactCode] = txBlock;
        // Emit the appropriate event
        emit ProduceByFarmer(prudactCode);
        //Increment stockUnit
        prudactCode++;
        }
    /*
    2nd step in supplychain
    Allows farmer to sell product
    */
    function _2_sellItemByFarmer(uint256 _productCode, uint256 _price)
        public
        onlyFarmer // check _msgSender() belongs to farmerRole
        producedByFarmer(_productCode) // check items state has been produced
        verifyCaller(items[_productCode].ownerID) // check _msgSender() is owner
    {
        items[_productCode].itemState = State.ForSaleByFarmer;
        items[_productCode].productPrice = _price;
        emit ForSaleByFarmer(_productCode);
    }

    /*
    3rd step in supplychain
    Allows distributor to purchase product
    */
    function _3_purchaseItemByDistributor(uint256 _productCode)
        public
        payable
        onlyDistributor // check _msgSender() belongs to distributorRole
        forSaleByFarmer(_productCode)
        
    {
        items[_productCode].ownerID = _msgSender(); // update owner
        items[_productCode].distributorID = _msgSender(); // update distributor
        items[_productCode].itemState = State.PurchasedByDistributor; // update state
        items[_productCode].name_Distribution_company= fetch_name_Distribution_company(_msgSender());
        items[_productCode].phone_Distribution= fetch_phone_Distribution(_msgSender());
        items[_productCode].website_Distribution= fetch_website_Distribution(_msgSender());
        items[_productCode].address_Distribution_company= fetch_address_Distribution_company(_msgSender());
        itemsHistory[_productCode].FTD = block.number; 
        emit PurchasedByDistributor(_productCode);
    }
     
  /*
  4th step in supplychain
  Allows farmer to ship product purchased by distributor
  */
    function _4_shippedItemByFarmer(uint256 _productCode)
        public
        payable
        onlyFarmer // check _msgSender() belongs to FarmerRole
        purchasedByDistributor(_productCode)
        verifyCaller(items[_productCode].farmerID) // check _msgSender() is originFarmID
    {
        items[_productCode].itemState = State.ShippedByFarmer; // update state
        emit ShippedByFarmer(_productCode);
    }
   
    /*
  5th step in supplychain
  Allows distributor to receive product
  */
    function _5_receivedItemByDistributor(uint256 _productCode)
        public
        onlyDistributor // check _msgSender() belongs to DistributorRole
        shippedByFarmer(_productCode)
        verifyCaller(items[_productCode].ownerID) 
    {
        items[_productCode].itemState = State.ReceivedByDistributor; // update state
        emit ReceivedByDistributor(_productCode);
    }

    /*
  6th step in supplychain
  Allows distributor to process product
  */
    function _6_processedItemByDistributor(uint256 _productCode)
        public
        onlyDistributor // check _msgSender() belongs to DistributorRole
        receivedByDistributor(_productCode)
        verifyCaller(items[_productCode].ownerID)
    {
        items[_productCode].itemState = State.ProcessedByDistributor; // update state
        emit ProcessedByDistributor(_productCode);
    }
    /*
  7th step in supplychain
  Allows distributor to package product
  */
    function _7_packageItemByDistributor(uint256 _productCode)
        public
        onlyDistributor // check _msgSender() belongs to DistributorRole
        processByDistributor(_productCode)
        verifyCaller(items[_productCode].ownerID) // check _msgSender() is owner
    {
        items[_productCode].itemState = State.PackageByDistributor;
        emit PackagedByDistributor(_productCode);
    }

    /*
  8th step in supplychain
  Allows distributor to sell product
  */
    function _8_sellItemByDistributor(uint256 _productCode, uint256 _price)
        public
        onlyDistributor // check _msgSender() belongs to DistributorRole
        packagedByDistributor(_productCode)
        verifyCaller(items[_productCode].ownerID) // check _msgSender() is owner
    {
        items[_productCode].itemState = State.ForSaleByDistributor;
        items[_productCode].productPrice = _price;
        emit ForSaleByDistributor(_productCode);
    }
    /*
  9th step in supplychain
  Allows retailer to purchase product
  */
    function _9_purchaseItemByRetailer(uint256 _productCode)
        public
        payable
        onlyRetailer // check _msgSender() belongs to RetailerRole
        forSaleByDistributor(_productCode)
    {
        items[_productCode].ownerID = _msgSender();
        items[_productCode].retailerID = _msgSender();
        items[_productCode].itemState = State.PurchasedByRetailer;
        items[_productCode].name_Retailer_store = fetch_name_Retailer_store(_msgSender());
        items[_productCode].website_Retailer = fetch_website_Retailer(_msgSender());
        items[_productCode].address_Retailer_store = fetch_address_Retailer_store(_msgSender());
        itemsHistory[_productCode].DTR = block.number;
        emit PurchasedByRetailer(_productCode);
    }

    /*
  10th step in supplychain
  Allows Distributor to
  */
    function _10_shippedItemByDistributor(uint256 _productCode)
        public
        onlyDistributor // check _msgSender() belongs to DistributorRole
        purchasedByRetailer(_productCode)
        verifyCaller(items[_productCode].distributorID) // check _msgSender() is distributorID
    {
        items[_productCode].itemState = State.ShippedByDistributor;
        emit ShippedByDistributor(_productCode);
    }
    /*
  11th step in supplychain
  Allows Retailer to receive product
  */
    function _11_receivedItemByRetailer(uint256 _productCode)
        public
        onlyRetailer // check _msgSender() belongs to RetailerRole
        shippedByDistributor(_productCode)
        verifyCaller(items[_productCode].ownerID) // check _msgSender() is ownerID
    {
        items[_productCode].itemState = State.ReceivedByRetailer;
        emit ReceivedByRetailer(_productCode);
    }

    /*
  12th step in supplychain
  Allows Retailer to sell product
  */
    function _12_sellItemByRetailer(uint256 _productCode, uint256 _price)
        public
        onlyRetailer // check _msgSender() belongs to RetailerRole
        receivedByRetailer(_productCode)
        verifyCaller(items[_productCode].ownerID) // check _msgSender() is ownerID
    {
        items[_productCode].itemState = State.ForSaleByRetailer;
        items[_productCode].productPrice = _price;
        emit ForSaleByRetailer(_productCode);
    }
    /*
  13th step in supplychain
  */
    function _13_purchaseItemByConsumer(uint256 _productCode)
        public
        payable
        onlyConsumer // check _msgSender() belongs to ConsumerRole
        forSaleByRetailer(_productCode)
    {
        items[_productCode].ownerID = _msgSender();
        items[_productCode].consumerID = _msgSender();
        items[_productCode].itemState = State.PurchasedByConsumer;
        itemsHistory[_productCode].RTC = block.number;
        emit PurchasedByConsumer(_productCode);
    }
    
    // Define a function 'fetchItemBufferOne' that fetches the data
    function fetchItemFarmerINfo(uint256 _productCode)
        public
        view
        returns (
            address ownerID,
            address farmerID,
            string memory farmer_First_Name,
            string memory farmer_Last_Name,
            string memory farmer_phone,
            string memory farmer_Address
        )
    {
        Item memory item = items[_productCode];

        return (
            item.ownerID,
            item.farmerID,
            item.farmer_First_Name,
            item.farmer_Last_Name,
            item.farmer_phone,
            item.farmer_Address
        );
    }

    // Define a function 'fetchFarmINfo' that fetches the data
    function fetchFarmINfo(uint256 _productCode)
        public
        view
        returns (
            address ownerID,
            address farmerID,
            string memory farm_Country,
            string memory farm_Governorate,
            string memory farm_City,
            string memory farm_Address,
            uint256 farm_area,
            string memory type_of_soil,
            uint8 number_of_wells,
            uint8 number_of_boreholes,
            uint256 farm_Lat,
            uint256 farm_Long
        )
    {
        Item memory item = items[_productCode];

        return (
            item.ownerID,
            item.farmerID,
            item.farm_Country,
            item.farm_Governorate,
            item.farm_City,
            item.farm_Address,
            item.farm_area,
            item.type_of_soil,
            item.number_of_wells,
            item.number_of_boreholes,
            item.farm_Lat,
            item.farm_Long
        );
    }
    // Define a function 'fetchProductINfo' that fetches the data
    function fetchProductINfo(uint256 _productCode)
        public
        view
        returns (
            string memory productID,
            string memory product_name,
            string memory plant_type,
            string memory productDate,
            uint256 productPrice
        )
    {
        Item memory item = items[_productCode];

        return (
            item.productID,
            item.product_name,
            item.plant_type,
            item.productDate,
            item.productPrice
        );
    }
    // Define a function 'fetchProductINfo' that fetches the data
    function fetchDistrebuter_Raitelair_custumer_INfo(uint256 _productCode)
        public
        view
        returns (
            address ownerID,
            address distributorID,
            address retailerID,
            address consumerID,
            string memory name_Distribution_company,
            string memory phone_Distribution,
            string memory website_Distribution,
            string memory address_Distribution_company,
            string memory name_Retailer_store,
            string memory website_Retailer,
            string memory address_Retailer_store
            
        )
    {
        Item memory item = items[_productCode];

        return (
            item.ownerID,
            item.distributorID,
            item.retailerID,
            item.consumerID,
            item.name_Distribution_company,
            item.phone_Distribution,
            item.website_Distribution,
            item.address_Distribution_company,
            item.name_Retailer_store,
            item.website_Retailer,
            item.address_Retailer_store
        );
    }


    // Define a function 'fetchItemHistory' that fetaches the data
    function fetchitemHistory(uint256 _productCode)
        public
        view
        returns (
            uint256 blockfarmerToDistributor,
            uint256 blockDistributorToRetailer,
            uint256 blockRetailerToConsumer
        )
    {
        // Assign value to the parameters
        Txblocks memory txblock = itemsHistory[_productCode];
        return (txblock.FTD, txblock.DTR, txblock.RTC);
    }



}
