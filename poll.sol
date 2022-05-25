pragma solidity ^0.5.1;

contract Tools{
    function equalstrings (string memory a, string memory b) 
    internal pure returns(bool){
        if (bytes(a).length != bytes(b).length)
            return false;
        else
            for (uint i=0; i < bytes(a).length; i++){
                if (bytes(a)[i] != bytes(b)[i])
                    return false;
            }
            return true;
    }

    function append(string memory a, string memory b)
    internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
    if (_i == 0) {
        return "0";
    }
    uint j = _i;
    uint len;
    while (j != 0) {
        len++;
        j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len - 1;
    while (_i != 0) {
        bstr[k--] = byte(uint8(48 + _i % 10));
        _i /= 10;
    }
    return string(bstr);
    }
}

contract Poll is Tools{
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
            if (equalstrings(candidates[i].name, name))
                return true;
        return false;
    }

    function showCandidates() public view returns(string memory){
        require(pollStarted,'the poll is not started yet!');
        string memory str = '';
        for (uint i; i < candidates.length; i++){
            str = append(str, candidates[i].name);
            if (i < candidates.length - 1)
                str = append(str, ', ');
        }
        return str;
    }

    function startPoll() public isOwner() {
        require(!pollStarted,'poll has already started!');
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
            str = append(str, candidates[i].name);
            str = append(str,': ');
            str = append(str, uint2str(candidates[i].votes));
            if (i < candidates.length - 1)
                str = append(str, ', ');
        }
        return str;
    }

}