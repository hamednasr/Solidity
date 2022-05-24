pragma solidity ^0.5.0;

contract Awake{
    address owner;
    // address[] members; 
    // address[] awakes; 
    uint memberCount = 0;
    uint awakeCount = 0;
    uint share = 0;
    uint wakeTime;
    uint duration;
    bytes x;

    struct Member{
        bool member;
        bool awake;
        bool paid;
    }
    mapping (address => Member) members;
    
    constructor (uint _wakeTime, uint _duration) public{
        owner = msg.sender;
        wakeTime = _wakeTime;
        duration = _duration;
    }

    function IamIn() public payable{
        require(msg.value == 1e18, 'pay exactly 1 Ether');
        require(!members[msg.sender].member,'you are already in!');
        require(now < wakeTime); 

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
        require(now > wakeTime && now < wakeTime+duration);//between 4:00 and 4:05 am
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
        require(now > wakeTime + duration);
        if(share == 0 && awakeCount>0)
            share = address(this).balance / awakeCount;
        if (share>0){
            members[msg.sender].paid = true;
            msg.sender.transfer(share);
        }
    }

    function PayNothing() public{
        require(msg.sender == owner, 'you are not the owner!');
        require(true);
        selfdestruct(msg.sender);

    }
}