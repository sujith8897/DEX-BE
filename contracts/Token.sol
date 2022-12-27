// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract ERC20 {
    // Declare the necessary variables
    address public owner;
    uint256 public _totalSupply;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    // address public exchangeAddress = 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9; // Exchange Address
    address public exchangeAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3; // Exchange Address
    uint256 public defaultExchangeTransferAmount = 1000000000000000000; // 1 Token

    // Constructor function
    constructor() {
        owner = msg.sender;
        // _totalSupply = 1000000;
        _totalSupply = 100000000000000000000; // 100 Tokens
        balances[owner] = _totalSupply;
        transfer(exchangeAddress, defaultExchangeTransferAmount);
    }

    // Returns the total supply of tokens
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // Returns the balance of a given address
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // Transfers tokens from one address to another
    function transfer(address _to, uint256 _value) public {
        require(
            balances[msg.sender] >= _value && _value > 0,
            "Insufficient balance"
        );
        balances[msg.sender] -= _value;
        balances[_to] += _value;
    }

    // function transferToExchange() public {
    //     transfer(exchangeAddress, defaultExchangeTransferAmount);
    // }

    // Transfers tokens from one address to another, with the permission of the owner of the tokens
    function transferFrom(address _from, address _to, uint256 _value) public {
        require(
            balances[_from] >= _value &&
                allowed[_from][msg.sender] >= _value &&
                _value > 0,
            "Insufficient balance or allowance"
        );
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        balances[_to] += _value;
    }

    // Approves another address to transfer a specified amount of tokens on behalf of the owner
    function approve(address _spender, uint256 _value) public {
        allowed[msg.sender][_spender] = _value;
    }

    // Returns the amount of tokens an address is allowed to transfer on behalf of the owner
    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
}
