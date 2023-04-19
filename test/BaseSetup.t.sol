// SPDX-License-Identifier: MIT
pragma solidity >=0.8;

import {Utils} from "./Utils.sol";
import {ERC20} from "../mocks/MockERC20.sol";
import {IDO} from "../contracts/IDO.sol";
import {stdStorage, StdStorage, Test, console, StdAssertions} from "forge-std/Test.sol";

contract BaseSetup is Test {
    Utils internal utils;
    ERC20 internal token;
    IDO internal ido;

    address payable[] internal users;
    address payable internal owner;
    address payable internal dev;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(10);
        owner = users[0];
        dev = users[1];

        startHoax(owner);
        token = new ERC20();
        ido = new IDO(dev, address(token));
        vm.stopPrank();
    }

    function test() public view {}
}
