// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase {
    address public owner;
    mapping (address => uint) public addressToAmountPaid;
    address payable[] public payers;
    AggregatorV3Interface priceFeed;

    enum LOTTERY_STATE{
        OPEN,
        CLOSED,
        SPECIFYING_WINNER
    }

    LOTTERY_STATE public lottery_state;

    bytes32 internal keyHash;
    uint256 internal fee;    
    uint256 public randomResult;
    address payable recentWinner;
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Rinkeby
     * Chainlink VRF Coordinator address: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
     * LINK token address:                0x01BE23585060835E02B77ef475b0Cc51aA1e0709
     * Key Hash: 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311
     */

    constructor()  VRFConsumerBase( 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
                                     0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
                                    )
        {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
                            }

    // function getRandomNumber() public returns (bytes32 requestId) {
    //     require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
    //     return requestRandomness(keyHash, fee);
    // }

    /**
     * Callback function used by VRF Coordinator
     */





    modifier isowner{
        require(msg.sender == owner);
        _;
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (uint) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return uint(price*1e10);
    }

    function getConversionRate(uint ethAmount) public view returns (uint){
        uint ethPrice = getLatestPrice();
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

    function enter() public payable {
        require(lottery_state == LOTTERY_STATE.OPEN,'the lottery is closed!');
        uint minimumUSD = 50 * 1e18;
    	// 18 digit number to be compared with donated amount , 
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more Ether!");
        payers.push(payable(msg.sender));
        addressToAmountPaid[msg.sender] += msg.value;
    }

    function startLottery() public isowner() {
        require(lottery_state == LOTTERY_STATE.CLOSED,'lottery is already open!');
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public isowner() {
        require(lottery_state == LOTTERY_STATE.OPEN,'lottery is already closed!');
        lottery_state = LOTTERY_STATE.SPECIFYING_WINNER;
        bytes32 requestId = requestRandomness(keyHash, fee);
    }   

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        
        require(lottery_state == LOTTERY_STATE.SPECIFYING_WINNER,'lottery not ended yet!');
        // randomResult = randomness;
        require(randomResult > 0 ,'no random number provided!');
        uint winnerIndex = randomness % payers.length;
        recentWinner =  payers[winnerIndex];
        recentWinner.transfer(address(this).balance);

        payers = new address payable[](0);
        lottery_state = LOTTERY_STATE.CLOSED;

    }
}