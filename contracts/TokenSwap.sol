// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract TokenSwap {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Pair Name: DAI / ETH	
     18	
     0x22B58f1EbEDfCA50feF632bD73368b2FdA96D5414e99
     */
    constructor() {
        priceFeed = AggregatorV3Interface(
            0x22B58f1EbEDfCA50feF632bD73368b2FdA96D541
        );
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int256) {
        (
            ,
            /*uint80 roundID*/
            int256 price,
            ,
            ,

        ) = /*uint startedAt*/
            /*uint timeStamp*/
            /*uint80 answeredInRound*/
            priceFeed.latestRoundData();
        return price;
    }
}
