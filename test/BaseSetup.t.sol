// SPDX-License-Identifier: MIT
pragma solidity >=0.8;

import {Utils} from "./Utils.sol";
import {ERC20} from "../contracts/ERC20.sol";
import {stdStorage, StdStorage, Test, console, StdAssertions} from "forge-std/Test.sol";

contract BaseSetup is Test {
    Utils internal utils;
    ERC20 internal token;

    address payable[] internal users;
    address internal owner;
    address internal dev;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(10);
        owner = users[0];
        dev = users[1];

        hoax(owner);
        token = new ERC20();
    }

    function test_setup() public {
        assertEq(token.totalSupply(), token.balanceOf(owner));
    }
}
