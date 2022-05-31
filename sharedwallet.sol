// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';


contract sharedWallet is Ownable{

    constructor(uint _allowance) {
        allowance = _allowance;
        // owner = msg.sender;
    }

    // address owner;
    uint allowance;
    
    function Withdraw(uint amount) public {
        if (msg.sender == owner())
            payable(msg.sender).transfer(amount);

        else if (amount <= allowance)
            payable(msg.sender).transfer(amount);
        
        else
            revert ('you are not allowed to withdraw over your allowance!');

    }

    function changeAllowance(uint amount) public onlyOwner{
        allowance = amount;
    }

    function contractBalance() public view returns(uint){
        return address(this).balance;
    }

    receive() external payable{
        // msg.value;
    }

}
