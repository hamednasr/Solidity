pragma solidity ^0.5.1;
contract Poll{
    struct Candidate{
        string name;
        uint votes;
    }
    Candidate[] candidates;
    mapping(address => bool) voters;

}