pragma solidity ^0.5.1;
import './tools.sol';

contract Poll{
    address public owner;
    struct Candidate{
        string name;
        uint votes;
    }

    Candidate[] candidates;
    mapping(address => bool) voters;
    bool pollStarted = false;
    bool pollFinished = false;

    modifier isOwner() {
        require(msg.sender == owner, 'you are not the owner!');
        _;
    }

    constructor() public{
        owner = msg.sender;
    } 

    function addCandidate(string memory candidateName) public isOwner() {
        require(! pollStarted,'the poll has started');
        require(! isNameRepeated(candidateName));
        Candidate memory _candidate;
        _candidate.name = candidateName;
        _candidate.votes = 0;
        candidates.push(_candidate);
    }

    function isNameRepeated(string memory name) private view returns(bool){
        for (uint i; i < candidates.length; i++)
            if (Tools.equalstrings(candidates[i].name, name))
                return true;
        return false;
    }

    function showCandidates() public view returns(string memory){
        require(pollStarted,'the poll is not started yet!');
        string memory str = '';
        for (uint i; i < candidates.length; i++){
            str = Tools.append(str, candidates[i].name);
            if (i < candidates.length - 1)
                str = Tools.append(str, ', ');
        }
        return str;
    }

    function startPoll() public isOwner() {
        require(!pollStarted,'poll has already started!');
        require(candidates.length >= 2);
        pollStarted = true;
    }

    function finishPoll() public isOwner() {
        require(pollStarted,'poll has not started yet!');
        require(! pollFinished,'poll has already finished!');
        pollFinished = true;
    }

    function Vote(uint candidatenum) public{
        require(! voters[msg.sender],'you have voted before!');
        require(pollStarted,'the poll is not started yet!');
        require(! pollFinished,'the poll has ended!');
        require((candidatenum>=0) && (candidatenum < candidates.length), 'out of number of candidates');
        candidates[candidatenum].votes++;
        voters[msg.sender]=true;
    }

    function showVotes() public view returns(string memory){
        require(pollFinished, 'the poll is not finished yet!');
        string memory str = '';
        for (uint i; i < candidates.length; i++){
            str = Tools.append(str, candidates[i].name);
            str = Tools.append(str,': ');
            str = Tools.append(str, Tools.uint2str(candidates[i].votes));
            if (i < candidates.length - 1)
                str = Tools.append(str, ', ');
        }
        return str;
    }

    function showWinner () public view isOwner() returns(string memory)  {
        require(pollFinished,'poll has not finished yet!');
        uint largest = 0;
        uint index;
        for(uint i = 0; i < candidates.length; i++)
            if(candidates[i].votes > largest){
                largest = candidates[i].votes;
                index = i;
            } 
        return candidates[index].name;
    }

}