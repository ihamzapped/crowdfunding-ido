// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import {IERC20} from "../interfaces/IERC20.sol";

contract IDO {
    uint public constant price = 0.001 ether; // 1 erc20 = 0.001 eth
    uint public constant hardcap = 500 ether;
    uint public constant investMax = 5 ether;
    uint public constant investMin = 0.01 ether;

    address public immutable owner;
    address public immutable idoToken;

    uint public immutable claimStart;
    uint public immutable saleStart = block.timestamp + 1 hours;
    uint public immutable saleEnd = block.timestamp + 1 weeks;

    bool public s_halted;
    uint public s_raised;
    address payable public s_deposit;
    mapping(address => uint) public s_claims;

    constructor(address payable _deposit, address _idoToken) {
        owner = msg.sender;
        idoToken = _idoToken;
        s_deposit = _deposit;
        claimStart = saleEnd + 1 weeks;
    }

    function invest() public payable {
        require(!s_halted);
        require(block.timestamp >= saleStart);
        require(block.timestamp <= saleEnd);
        require(s_raised < hardcap);
        require(msg.value >= investMin);
        require(msg.value <= investMax);

        uint _claimAmount = msg.value / price;

        IERC20(idoToken).transferFrom(owner, address(this), _claimAmount); // This contract assumes IDO contract and Erc20 contract have same owner

        s_claims[msg.sender] += _claimAmount;
        s_deposit.transfer(msg.value);
    }

    receive() external payable {
        invest();
    }

    function setDeposit(address payable _addr) external Owner {
        s_deposit = _addr;
    }

    function halt() external Owner {
        s_halted = true;
    }

    function resume() external Owner {
        s_halted = false;
    }

    modifier Owner() {
        _isOwner();
        _;
    }

    function _isOwner() internal view {
        require(msg.sender == owner);
    }
}
