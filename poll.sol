pragma solidity ^0.5.1;
contract Poll{
    address owner;
    struct Candidate{
        bytes name;
        uint votes;
    }
    Candidate[] candidates;
    mapping(address => bool) voters;

    constructor() public{
        owner = msg.sender;
        
    } 

    function addCandidate(bytes memory candidateName) public{
        require(msg.sender == owner);
        Candidate memory _candidate;
        _candidate.name = candidateName;
        _candidate.votes = 0;
        candidates.push(_candidate);
    }


}