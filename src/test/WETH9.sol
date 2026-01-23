// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IWETH.sol";

contract WETH9 is IWETH {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    
    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint value) public {
        require(balanceOf[msg.sender] >= value, "WETH: insufficient");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        payable(msg.sender).transfer(value);
        emit Withdrawal(msg.sender, value);
    }

    function approve(address spender, uint value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) external returns (bool) {
        return transferFrom(msg.sender, to, value);
    }

    function transferFrom(address from, address to, uint value) public returns (bool) {
        if (from != msg.sender) {
            uint allowed = allowance[from][msg.sender];
            if (allowed != type(uint).max) {
                allowance[from][msg.sender] = allowed - value;
            }
        }

        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
        return true;
    }
}
