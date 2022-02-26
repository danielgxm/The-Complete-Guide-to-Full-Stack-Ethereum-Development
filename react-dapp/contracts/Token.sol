//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Token {
    //Token名称
    string public name = "DanielGao Token";
    //Token代码
    string public symbol = "DGT";
    //Token总量
    uint256 public totalSupply = 1_000_000;
    //地址余额
    mapping(address => uint256) balances;

    //构造函数
    constructor() {
        balances[msg.sender] = totalSupply;
    }

    //发送Token
    function transfer(address to, uint256 count) external {
        require(balances[msg.sender] >= count, "Not enough token");
        balances[msg.sender] -= count;
        balances[to] += count;
    }

    //查看地址余额
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
