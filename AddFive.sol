// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import{SimpleStorage} from "./SimpleStorage.sol";

//inheritance
contract AddFive is SimpleStorage{
    function hello(string memory s) public pure returns(string memory){  // pure??
        return string(abi.encodePacked("Hello ", s));  //concat str
    }

    function store(uint256 n) public override  {
        favNum = n+5;
        
    }
}
