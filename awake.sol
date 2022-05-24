pragma solidity ^0.5.0;

contract Awake{
    address owner;
    // address[] members; 
    // address[] awakes; 
    uint memberCount = 0;
    uint awakeCount = 0;
    uint share = 0;

    struct Member{
        bool member;
        bool awake;
        bool paid;
    }
    mapping (address => Member) members;
    
    constructor () public{
        owner = msg.sender;
    }

    function IamIn() public payable{
        require(msg.value == 1e18, 'pay exactly 1 Ether');
        require(!members[msg.sender].member,'you are already in!');

        // bool found = false;
        // for (uint i = 0; i < members.length; i++)
        //     if (msg.sender == members[i]){
        //         found = true;
        //         break;
        //     }
        // require(!found);
        require(true);//before 4:00 am
        // members.push(msg.sender);
        members[msg.sender].awake = false;
        members[msg.sender].member = true;
        memberCount++;
    }
 
    function IamAwake() public{
        require(true);//between 4:00 and 4:05 am
        require(members[msg.sender].member,'you are not in the list');
        // bool found = false;
        // for (uint i = 0; i < members.length; i++)
        //     if (msg.sender == members[i]){
        //         found = true;
        //         break;
        //     }
        // require(found, 'you are not in the list');
        // awakes.push(msg.sender);
        members[msg.sender].awake = true;
        awakeCount++;
    }

    function PayMyQuote() public{
        require(members[msg.sender].awake,'you are not in the list!');
        require(! members[msg.sender].paid,'you were paid before!');
        if(share == 0 && awakeCount>0)
            share = address(this).balance / awakeCount;
        
        members[msg.sender].paid = true;
        msg.sender.transfer(share);
    }
}