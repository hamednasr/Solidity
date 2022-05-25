pragma solidity ^0.5.1;

library Tools{
    
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

    function append(string memory a, string memory b, string memory c)
    internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }

    function append(string memory a, string memory b, string memory c, string memory d)
    internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d));
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