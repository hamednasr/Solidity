pragma solidity ^0.5.1;

contract ICOFinance{
    address owner;
    constructor() public{
        owner = msg.sender;
    }
    
    uint shareValue = 1e15;
    // uint public sharesNeeded = 1e9;
    uint public sharesNeeded = 100;
    uint sharesAquired;
    uint Deadline = now + 240 seconds;
    bool EnoughSharesAquired = false;
    bool TransferedtoOwner = false;
    struct ShareHolder {
        uint shares;
        uint refundtime;
    } 
    mapping (address => ShareHolder) ShareHolders;
    address payable[] ShareHolderlist; 

    function PayMyRefund() external {
        require(ShareHolders[msg.sender].shares > 0,'you dont have any shares!');
        require(now > Deadline,'deadline not reached');
        require(! EnoughSharesAquired,'refund not possible');
        ShareHolders[msg.sender].shares = 0; 
        ShareHolders[msg.sender].refundtime = now; 
        msg.sender.transfer(ShareHolders[msg.sender].shares * shareValue);
    }  

    function PayHolderRefund() external {
        require(owner ==msg.sender);
        for (uint i = 0; i < ShareHolderlist.length; i++){
            ShareHolders[ShareHolderlist[i]].shares = 0;
            ShareHolderlist[i].transfer(ShareHolders[ShareHolderlist[i]].shares * shareValue);
            ShareHolders[ShareHolderlist[i]].refundtime = now;
            }
    }

    function TransfertoOwner() external {
        require(EnoughSharesAquired,'not enough shares!');
        require(now > Deadline,'deadline not reached!');
        require(owner ==msg.sender);
        require(!TransferedtoOwner,'money transfered to owner before!');
        TransferedtoOwner = true;
        msg.sender.transfer(address(this).balance);        
    }

    function AquieredFund() external view returns(uint){
        return address(this).balance/shareValue;
    }

    function getStatus() external view returns(string memory) {
        if (!EnoughSharesAquired) return ('fundraising not complete yet!');
        else if (TransferedtoOwner) return ('fundraising complete and paid to owner');
        else if (!TransferedtoOwner) return ('fundraising complete and not paid to owner');
    }

    function() external payable{
        require(!EnoughSharesAquired,'maximum number of shares purchased!');
        require(now <= Deadline);
        require((msg.value % shareValue == 0) && (msg.value > 0), 
                'please send multiply of 0.001 Ether');
        require(sharesNeeded - address(this).balance / shareValue >= msg.value,
                'not enough share to purchase!');
        
        ShareHolder memory sh;
        sh.shares = msg.value/shareValue + ShareHolders[msg.sender].shares ;
        ShareHolders[msg.sender] = sh;

        if (ShareHolders[msg.sender].shares == 0)
            ShareHolderlist.push(msg.sender);

        // ShareHolder memory sh = ShareHolder({shares: msg.value/shareValue});
        if ((address(this).balance +msg.value) /shareValue == sharesNeeded)
            EnoughSharesAquired = true;
    }

} 
