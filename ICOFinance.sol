pragma solidity ^0.5.1;

contract ICOFinance{
    uint shareValue = 1e15;
    uint sharesNeeded = 1e9;
    uint Deadline = now + 30 days;
    bool EnoughSharesAquired = false;
    struct ShareHolder {
        uint shares;
    } 
    mapping (address => ShareHolder) ShareHolders;

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
        // ShareHolder memory sh = ShareHolder({shares: msg.value/shareValue});
        if ((address(this).balance +msg.value) /shareValue == sharesNeeded)
            EnoughSharesAquired = true;
    }

    function giveRefund() external {
        require(ShareHolders[msg.sender].shares > 0,'you dont have any shares!');
        require(now > Deadline,'deadline not reached');
        require(! EnoughSharesAquired,'refund not possible');
        ShareHolders[msg.sender].shares = 0; 
        msg.sender.transfer(ShareHolders[msg.sender].shares * shareValue);
    }  
} 
