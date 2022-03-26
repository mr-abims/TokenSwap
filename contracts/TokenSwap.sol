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
    function swapDaiToUSDC(address _fromAddress, uint256 _amount) public {
        uint256 swapAmount = (_amount * uint256(currentRate))/10**decimals;
        require(DAI.balanceOf(_fromAddress) >= swapAmount, "Insufficient amount");
        Swap storage swap_ = swapOrder[swapIndex];
        swap_.amountIn = _amount;
        swap_.currencyDecimal = decimals;
        swap_.owner = _fromAddress;
        swapIndex++;
        (bool status) = DAI.transferFrom(_fromAddress, address(this), _amount);
        require(status,"Failed transaction");
        (bool status1) = USDC.transfer(_fromAddress, swapAmount);
        require(status1, "Failed Transaction");
    }
     // addLiquidity add Tokens to contract for permissionless swap
    function addLiquidity(
        address _address,
        address _tokenAddress,
        uint256 amount
    ) public returns (bool success) {
        success = IERC20(_tokenAddress).transferFrom(
            _address,
            address(this),
            amount
        );

        require(success != true, "transfer not successful");
    }
    /// Check Balance of a particular token in the contract
    function checkTokenBalance(address _tokenAddress)
        external
        view
        returns (uint256 _Balance)
    {
        _Balance = IERC20(_tokenAddress).balanceOf(address(this));
    }
    function retrieveOrder(uint256 index) public view returns(Swap memory) {
        Swap storage swap_ = swapOrder[index];
        return(swap_);
    }


}
