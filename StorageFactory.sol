// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory{

    SimpleStorage[] public listOFSimpleStorage;

    function createSimpleStorage() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        listOFSimpleStorage.push(simpleStorage);
    }

    function sfStore(uint256 _index , uint256 _num) public{
        // address
        //ABI - Applicatin Binary Interface
        listOFSimpleStorage[_index].store(_num);
    }

    function sfDisplay(uint256 _index) public view returns(uint256) {
        return listOFSimpleStorage[_index].display();
    }
}
