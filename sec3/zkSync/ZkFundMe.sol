// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter {

    function getPrice() internal  view returns(uint256) {
        // address:   0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        // ABI: imported

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        //price of eth in usd      8 decimals

        //3641_584773030000000000
        return uint256(answer * 1e10 );
    }

    function getConversionRate(uint256 ethAmount) internal  view returns(uint256){

        uint256 ethPrice = getPrice();
        //                         3641_e18 *  1e18   / 1e18 = 3641                    
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }    

    function convertUsdtoEth(uint256 usdAmount) internal view returns (uint256){

        usdAmount *= 1e18; 
        uint256 ethPrice = getPrice();
        uint256 usdAmountInEth = usdAmount / ethPrice;

        return usdAmountInEth;
    }  
}



error NotOwner();

contract ZkFundMe{

    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    address public immutable i_owner;

    uint256 public currentPrice_ethToUsd;

    mapping(address funder => uint256 amtFunded) public addressToAmtFunded;

    // uint256 usdToEth;

    constructor(){
        i_owner = msg.sender;
        currentPrice_ethToUsd = (PriceConverter.getPrice()) / 1e18;
    }


    // function updateUsdToEth(uint256 usdAmount)  public  returns (uint256){
    //     usdToEth = usdAmount.convertUsdtoEth();
    //     return usdToEth;
    // }


    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        return priceFeed.version();
    }


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
