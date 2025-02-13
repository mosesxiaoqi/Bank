// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.24 <0.9.0;

contract Bank {

    address public owner; // 定义一个地址类型的公共变量 owner
    address[] numbers; // 定义一个数组
    mapping(address => uint) balances; // 定义一个 mapping，存储地址和余额的映射

    constructor() {
        owner = msg.sender; // 在构造函数中初始化 owner
        numbers.push(address(0));
        numbers.push(address(0));
        numbers.push(address(0)); 
    }

    /// 调用者未被授权进行此操作。
    error Unauthorized();

    event Received(address from, uint amount);

    receive() external payable {
        balances[msg.sender] += msg.value;
        updateRanking(msg.sender, balances[msg.sender]);
        emit Received(msg.sender, msg.value);
    } // 允许接收 ETH

    function updateRanking(address _address, uint value) private {
        
        for (uint i = 0; i < 3; i++)
        {
            if (numbers[i] == _address)
            {
                break;
            }
            else if (balances[numbers[i]] < value)
            {
                numbers[i] = _address;
                break;
            }
        }
    }

    function withdraw(uint amount) public {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        if (amount <= address(this).balance) {
            payable(msg.sender).transfer(amount);
        }
    }

    function getTopThreeUserAddressInfo(uint idx) public view returns (address) {
        if (idx >= numbers.length) {
            return address(0);
        }
        return numbers[idx];
    }

}