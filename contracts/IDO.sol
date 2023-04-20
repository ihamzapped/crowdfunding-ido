// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import {IERC20} from "../interfaces/IERC20.sol";

struct Token {
    address addr;
    uint decimals;
}

contract IDO {
    address public immutable owner;

    uint public immutable price;
    uint public immutable hardcap;
    uint public immutable investMax;
    uint public immutable investMin;
    uint public immutable claimStart;
    uint public immutable saleStart;
    uint public immutable saleEnd;

    bool public s_halted;
    uint public s_raised;
    Token public s_idoToken;
    address payable public s_deposit;
    mapping(address => uint) public s_claims;

    constructor(
        address payable _deposit,
        Token memory _idoToken,
        uint _price,
        uint _hardcap,
        uint _investMax,
        uint _investMin
    ) {
        owner = msg.sender;
        s_idoToken = _idoToken;
        s_deposit = _deposit;
        saleStart = block.timestamp + 1 hours;
        saleEnd = block.timestamp + 1 weeks;
        claimStart = saleEnd + 1 weeks;

        price = _price;
        hardcap = _hardcap;
        investMax = _investMax;
        investMin = _investMin;
    }

    function invest() public payable notHalted {
        require(block.timestamp >= saleStart, "!started");
        require(block.timestamp <= saleEnd, "ended");
        require(s_raised < hardcap, "raised > hardcap");
        require(msg.value >= investMin, "< min amount");
        require(msg.value <= investMax, "> max amount");

        uint _claimAmount = (msg.value / price) * 10 ** s_idoToken.decimals;

        IERC20(s_idoToken.addr).transferFrom(
            owner,
            address(this),
            _claimAmount
        ); // This contract assumes IDO contract and Erc20 contract have same owner

        s_claims[msg.sender] += _claimAmount;
        s_deposit.transfer(msg.value);
    }

    function claim() external notHalted {
        require(block.timestamp >= claimStart);

        uint _claims = s_claims[msg.sender];

        require(_claims > 0);

        s_claims[msg.sender] = 0;

        IERC20(s_idoToken.addr).transfer(msg.sender, _claims);
    }

    function burn() external {
        require(block.timestamp >= saleEnd);

        /* 
            @notice there is a slight chance that raised amount exceeds hardcap by a 
            maximum of investMax - investMin, so an implicit conversion to int is needed here
         */

        int _toBurn = int(hardcap - s_raised);

        require(_toBurn > 0);

        IERC20(s_idoToken.addr).transferFrom(owner, address(0), uint(_toBurn));
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

    modifier notHalted() {
        require(!s_halted);
        _;
    }

    modifier Owner() {
        _isOwner();
        _;
    }

    function _isOwner() internal view {
        require(msg.sender == owner);
    }
}
