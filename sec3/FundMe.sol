// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe{

    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    address public immutable i_owner;

    uint256 public currentPrice_ethToUsd;

    mapping(address funder => uint256 amtFunded) public addressToAmtFunded;

    uint256 usdToEth;

    constructor(){
        i_owner = msg.sender;
        currentPrice_ethToUsd = (PriceConverter.getPrice()) / 1e18;
    }


    // function updateUsdToEth(uint256 usdAmount)  public  returns (uint256){
    //     usdToEth = usdAmount.convertUsdtoEth();
    //     return usdToEth;
    // }


    // payable to make pay 
    function fund() public payable {

        // require(msg.value >= getConversionRate(minimumUsd) , "Not enough ETH"); // 1e18 = 1ETH = 1 * 10 ** 18 wei 
        require(msg.value.getConversionRate() >= MINIMUM_USD , "Not enough ETH. Minimum 5 USD"); // 1e18 = 1ETH = 1 * 10 ** 18 wei
        // 18 decimals

        funders.push(msg.sender);
        addressToAmtFunded[msg.sender] = addressToAmtFunded[msg.sender] + msg.value;
    }





    function withdraw() public onlyOwner {

        for (uint256 fundIndex = 0; fundIndex < funders.length; fundIndex++) 
        {
            address funder = funders[fundIndex];
            addressToAmtFunded[funder] = 0;
        }

        funders = new  address[](0);

        // transfer send(b) call(b,by)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"call failed");


    }

    modifier onlyOwner() {
        // require(i_owner == msg.sender , "Your not owner");
        if(msg.sender != i_owner){ revert NotOwner(); }
        _;
    }

    receive() external payable { 
        fund();
    }

    fallback() external payable { 
        fund();
    }

}   
