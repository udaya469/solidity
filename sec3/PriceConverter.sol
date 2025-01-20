// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter {

    function getPrice() internal  view returns(uint256) {
        // address:   0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI: imported

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
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
