// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract sharedWallet{

    constructor(uint _allowance) {
        allowance = _allowance;
        owner = msg.sender;
    }

    address owner;
    uint allowance;

    function Withdraw(uint amount) public {
        if (msg.sender == owner)
            payable(msg.sender).transfer(amount);

        else if (amount <= allowance)
            payable(msg.sender).transfer(amount);
        
        else
            revert ('you are not allowed to withdraw over your allowance!');

    }

    function changeAllowance(uint amount) public {
        require(msg.sender == owner,'you cannot chage this!');
        allowance = amount;
    }

    function contractBalance() public view returns(uint){
        return address(this).balance;
    }
    
    receive() external payable{
        // msg.value;
    }

}
