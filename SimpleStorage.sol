// SPDX-License-Identifier: MIT
pragma solidity 0.8.24; 

contract SimpleStorage{
    //basic types: bool, int256, unit256, bytes32, string, address
     uint256 favNum;

    function store (uint256 n) public virtual {
        favNum = n;
    }
    //pure, view 
    function display() public view returns(uint256) {
        return favNum;
    }

    // unit256[] ar;

    struct people{
        string name;
        uint256 num;
    }

    // people p = people("Rey",14);
    // people p = people({name: "Rey",num: 14});
    people[] public listofppl;

    mapping(string => uint256) public nameToNum;

    // memory - change+temp , calldata - unchange+temp , storage - permanent
    // (for ar,struct,maps,str(ar of chr))
    function addppl(string memory _name,uint256 _num) public {
        listofppl.push(people(_name,_num));
        nameToNum[_name] = _num;
    }
}
