// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./IERC20.sol";
contract TokenSwap {
    AggregatorV3Interface internal priceFeed;
    uint8 decimals;
    uint248 swapIndex;
    int256 currentRate;
    address internal daiAddress = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
    address internal usdcAddress = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    struct Swap {
        uint256 amountIn;
        address owner;
        uint8 currencyDecimal;
        bool status;
    }
    mapping (uint => Swap) swapOrder;
    IERC20 DAI = IERC20(daiAddress);
    IERC20 USDC = IERC20(usdcAddress);

    // 0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D* Network: polygon * Pair Name: DAI / USD *   
    constructor(address _address) {
        priceFeed = AggregatorV3Interface(
         _address
        );
    }

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
             decimals = priceFeed.decimals();
    }    
    function getRate() public view returns(int256, uint8) {
        return(currentRate, decimals);
    }   
    function swapDaiToUSDC(address _fromAddress, address _toAddress, uint256 _amount) public {
        uint256 swapAmount = (_amount * uint256(currentRate))/10**decimals;
        require(DAI.balanceOf(_fromAddress) >= swapAmount, "Insufficient amount");
        Swap storage swap_ = swapOrder[swapIndex];
        swap_.amountIn = _amount;
        swap_.currencyDecimal = decimals;
        swap_.owner = _fromAddress;
        ++swapIndex;
        (bool status) = DAI.transferFrom(_fromAddress, msg.sender, _amount);
        require(status,"Failed transaction");
        (bool status1) = USDC.transfer(_toAddress, swapAmount);
        require(status1, "Failed Transaction");
    }
    function retrieveOrder(uint256 index) public view returns(Swap memory) {
        Swap storage swap_ = swapOrder[index];
        return(swap_);
    }


}
