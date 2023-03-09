// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Marketplace {
    /**
     * Enumerator defining package shipping status
     */
	enum ShippingStatusEnum {Pending, Shipped, Delivered}

    /**
     * Status of the current ship
     */
    ShippingStatusEnum private status;

    /**
     * Customer address setted in constructor
     */
    address private customerAddress;

    /**
     * The owner's address is the address of the person who deployed the SC.
     */
    address private ownerAddress;
    constructor(address _customerAddress) {
        status = ShippingStatusEnum.Pending; // Setting default value for shipping
        ownerAddress = msg.sender; // Setting owner address using deployer address
        customerAddress = _customerAddress;  // Setting customer address provided in parameter
    }


    /**
     * Modifier to restrict the usage of a function to the owner
     */
    modifier onlyOwner(){
        require(msg.sender == ownerAddress, 'Not owner');
        _;
    }

    /**
     * Modifier to restrict the usage of a function to the customer
     */
    modifier onlyCustomer(){
        require(msg.sender == customerAddress, 'Not customer');
        _;
    }

    /**
     * Modifier to check if the user sent fees
     */
    modifier requiresFee(uint fee) {
        require(msg.value > fee, 'No fees provided');
        _;
    }

    /**
     * Event emitted when shipment status changes
     */
    event MissionComplete(string message);

    /**
     * Function that is accessible only by the owner which sets the shipment status to "Shipped" and emits MissionComplete on success
     */
    function shipped() public onlyOwner {
        status = ShippingStatusEnum.Shipped;
        emit MissionComplete("The package has been shipped");
    }

    /**
     * Function that is accessible only by the owner which sets the shipment status to "Delivered" and emits MissionComplete on success
     */
    function delivered() public onlyOwner {
        status = ShippingStatusEnum.Delivered;
        emit MissionComplete("The package has arrived");
    }

    /**
     * Function that is accessible only by the owner which returns the shipment status
     */
    function getStatus() public onlyOwner view returns (string memory) {
        return statusToString();
    }

    /**
     * Function that is accessible only by the customer returnts the shipment status if he send fees
     */
    function getStatusCustomer() public onlyCustomer payable requiresFee(0) returns (string memory) {
        return statusToString();
    }

    /**
     * Function that returns a string describing the shipment status
     */
    function statusToString() private view returns (string memory) {
        if (status == ShippingStatusEnum.Pending){
            return "Pending";
        } else if (status == ShippingStatusEnum.Shipped) {
            return "Shipped";
        } else if (status == ShippingStatusEnum.Delivered) {
            return "Delivered";
        } else {
            return "No valid status provided";
        }
    }
}
