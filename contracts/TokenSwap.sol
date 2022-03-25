// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./IERC20.sol";
contract TokenSwap {
    AggregatorV3Interface internal priceFeed;
    uint8 decimals;
    int256 currentRate;
    address internal daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    struct Swap {
        uint256 amountIn;
        address owner;
        uint8 currencyDecimal;
        bool status;
    }
    mapping (uint => Swap) swapOrder;
    IERC20 DAI = IERC20(daiAddress);
    IERC20 USDC = IERC20(usdcAddress);

   
    /**  
    0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9 * Network: Mainet * Pair Name: DAI / USD * 
     
     
     */
    constructor() {
        priceFeed = AggregatorV3Interface(
            0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9
        );
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
            ) =
            priceFeed.latestRoundData();
            currentRate = price;
    }    
    function getRate() public view returns(int256, uint8) {
        return(currentRate, decimals);
    }     


}
