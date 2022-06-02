// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import './SimpleStorage.sol';

contract StorageFactory {

    // uint favoriteNumber;
    SimpleStorage[] public simpleStorageArray;

    function creatSimpleStorageContract() public{
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint _index, uint _favoriteNumber) public {
        simpleStorageArray[_index].store(_favoriteNumber);
    }

    function sfAddPerson(uint _index, string memory _name, uint _favoriteNumber) public {
        simpleStorageArray[_index].addPerson(_name, _favoriteNumber);
    }

}
