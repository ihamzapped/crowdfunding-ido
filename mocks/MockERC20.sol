// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import {IERC20} from "../interfaces/IERC20.sol";

contract ERC20 is IERC20 {
    bytes10 public constant name = "Mock Token";
    bytes3 public constant symbol = "MTK";

    uint public constant decimals = 18;
    uint public constant totalSupply = 1_000_000 * (10 ** decimals);

    address public immutable owner;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;

    constructor() {
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    function balanceOf(address _owner) external view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) external returns (bool success) {
        require(balances[msg.sender] >= _value, "!bal");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success) {
        require(balances[_from] >= _value, "!bal");
        require(allowances[_from][msg.sender] >= _value, "!alwnc");

        balances[_from] -= _value;
        allowances[_from][msg.sender] -= _value;

        balances[_to] += _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) external returns (bool success) {
        require(_value > 0);
        require(balances[msg.sender] >= _value);

        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) external view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
}
