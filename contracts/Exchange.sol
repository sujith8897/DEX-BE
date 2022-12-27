// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
// import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20.sol";
import "./Token.sol";

contract Exchange {
    // Maps token symbols to token contract addresses
    mapping(string => address) public tokens;
    mapping(string => uint256) public exchangeRate;

    // Add a token to the DEX
    function addToken(
        string memory symbol,
        address contractAddress,
        uint256 tokenExchangeRate
    ) public {
        require(tokens[symbol] == address(0), "Token already exists");
        exchangeRate[symbol] = tokenExchangeRate;
        tokens[symbol] = contractAddress;
    }

    // Remove a token from the DEX
    function removeToken(string memory symbol) public {
        require(tokens[symbol] != address(0), "Token does not exist");
        delete tokens[symbol];
        delete exchangeRate[symbol];
    }

    function getExchangeRateOf(
        string memory symbol
    ) public view returns (uint256) {
        return exchangeRate[symbol];
    }

    function isTokenExists(string memory symbol) public view returns (bool) {
        return tokens[symbol] == address(0);
    }

    // Execute a trade
    function trade(
        string memory sellToken,
        uint256 sellAmount,
        string memory buyToken,
        uint256 buyAmount
    ) public {
        // Ensure that both tokens exist on the DEX
        require(tokens[sellToken] != address(0), "Sell token does not exist");
        require(tokens[buyToken] != address(0), "Buy token does not exist");

        // if(exchangeRate[buyToken] < exchangeRate[sellToken]) {
        //     (sellToken, buyToken) = (buyToken, sellToken);
        //     (sellAmount, buyAmount) = (buyAmount, sellAmount);
        // }

        // require(buyAmount == exchangeRate[sellToken]*exchangeRate[buyToken], "Exchange rate mismatch");

        // Get the sell token contract
        ERC20 sellTokenContract = ERC20(tokens[sellToken]);

        // Ensure that the sell amount is valid
        require(
            sellTokenContract.balanceOf(msg.sender) >= sellAmount,
            "Insufficient sell token balance"
        );

        // Get the buy token contract
        ERC20 buyTokenContract = ERC20(tokens[buyToken]);

        // Calculate the expected buy amount
        uint256 expectedBuyAmount = (sellAmount * buyAmount) / sellAmount;

        // Ensure that the buy amount is valid
        require(
            buyTokenContract.balanceOf(address(this)) >= expectedBuyAmount,
            "Insufficient buy token balance"
        );

        // Execute the trade
        sellTokenContract.transferFrom(msg.sender, address(this), sellAmount);
        buyTokenContract.transfer(msg.sender, expectedBuyAmount);
    }
}
