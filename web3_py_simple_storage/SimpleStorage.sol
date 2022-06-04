// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 favoriteNumber;

    struct People {
        string name;
        uint256 favoriteNumber;
    }

    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve(uint256 i)
        public
        view
        returns (string memory name, uint256 num)
    {
        name = people[i].name;
        num = people[i].favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_name, _favoriteNumber));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
