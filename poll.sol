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
        require(! isNameRepeat(candidateName));
        Candidate memory _candidate;
        _candidate.name = candidateName;
        _candidate.votes = 0;
        candidates.push(_candidate);
    }

    function equalstrings (bytes memory a, bytes memory b) 
    private pure returns(bool){
        if (a.length != b.length)
            return false;
        else
            for (uint i=0; i < a.length; i++){
                if (a[i] != b[i])
                    return false;
            }
            return true;
    }

    function isNameRepeat(bytes memory name) private view returns(bool){
        for (uint i; i < candidates.length; i++)
            if (equalstrings(candidates[i].name, name))
                return true;
        return false;
    }
}