// SPDX-License-Identifier: MIT
pragma solidity >=0.8;

import {Utils} from "./Utils.sol";
import {ERC20} from "../mocks/MockERC20.sol";
import {IDO} from "../contracts/IDO.sol";
import {stdStorage, StdStorage, Test, console, StdAssertions} from "forge-std/Test.sol";

contract CommonBase is Test {
    Utils internal utils;
    ERC20 internal token;
    IDO internal ido;

    uint price = 0.001 ether; // for 1 reward token

    address payable[] internal users;
    address payable internal owner;
    address payable internal dev;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(5);
        owner = users[0];
        dev = users[1];
    }

    function approveIdo(uint _tokenDecimals) internal {
        vm.startPrank(owner);
        token.approve(
            address(ido),
            ((ido.hardcap() / 10 ** 18) * 10 ** _tokenDecimals)
        );
        vm.stopPrank();
    }

    function _claimAmount(uint _amount) internal {
        vm.assume(_amount <= ido.investMax() && _amount >= ido.investMin());
        approveIdo(token.decimals());

        skip(ido.saleStart());

        vm.startPrank(dev);
        ido.invest{value: _amount}();
        ido.invest{value: _amount}();

        uint _claims = ido.s_claims(dev);

        assertEq(_claims, ((_amount / price) * 10 ** token.decimals()) * 2);
    }
}
