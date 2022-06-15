// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// import '@openzeppelin/contracts/ownership/Ownable.sol';
// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   // getRoundData and latestRoundData should both raise "No data present"
//   // if they do not have data to report, instead of returning unset values
//   // which could be misinterpreted as actual reported values.
//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
// }


contract Lottery {
    address public owner;
    mapping (address => uint) public addressToAmountPaid;
    address[] public payers;
    AggregatorV3Interface priceFeed;

    enum LOTTERY_STATE{
        OPEN,
        CLOSED,
        SPECIFYING_WINNER
    }

    LOTTERY_STATE public lottery_state;

    modifier isowner{
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
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
        payers.push(msg.sender);
        addressToAmountPaid[msg.sender] += msg.value;
    }

    function startLottery() public isowner() {
        require(lottery_state == LOTTERY_STATE.CLOSED,'lottery is already open!');
        lottery_state = LOTTERY_STATE.OPEN;


    }

    function endLottery() public isowner() {
        require(lottery_state == LOTTERY_STATE.OPEN,'lottery is already closed!');
        
        lottery_state = LOTTERY_STATE.CLOSED;

    }
}