// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Marketplace {
	enum ShippingStatusEnum {Pending, Shipped, Delivered}
    ShippingStatusEnum status;

    address ownerAddress = 0xBEEB605B26Ebe6BdFB588fC7d5D8cC25bDFE5bAB;
    constructor() {
        status = ShippingStatusEnum.Pending;
    }

    modifier onlyOwner(){
        require(msg.sender == ownerAddress);
        _;
    }

    modifier onlyCustomer(){
        require(msg.sender != ownerAddress);
        _;
    }

    modifier requiresFee(uint fee) {
        if (msg.value < fee) { 
            revert();
        }
        _;
    }

    event MissionComplete(string message);
    function shipped() public onlyOwner {
        status = ShippingStatusEnum.Shipped;
    }

    function delivered() public onlyOwner {
        status = ShippingStatusEnum.Delivered;
        emit MissionComplete("The package has arrived");
    }

    function getStatus() public onlyOwner view returns (string memory) {
        return statusToString();
    }

    function getStatusCustomer() public payable onlyCustomer requiresFee(0.001 ether) returns (string memory) {
        return statusToString();
    }

    function statusToString() private view returns (string memory) {
        if (status == ShippingStatusEnum.Pending){
            return "Pending";
        } else if (status == ShippingStatusEnum.Shipped) {
            return "Shipped";
        } else {
            return "Delivered";
        }
    }
}
