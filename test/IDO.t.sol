pragma solidity >=0.8;

import {IDO, Token} from "../contracts/IDO.sol";
import {CommonBase} from "./CommonBase.t.sol";
import {ERC20} from "../mocks/MockERC20.sol";
import {console, stdStorage, StdStorage} from "forge-std/Test.sol";

contract Test_IDO is CommonBase {
    function setUp() public virtual override {
        super.setUp();
        vm.startPrank(owner);
        token = new ERC20(18);
        ido = new IDO(
            dev,
            Token(address(token), token.decimals()),
            price,
            50000 ether,
            5 ether,
            0.01 ether
        );
        vm.stopPrank();
    }

    function test_claimAmount(uint _amount) public {
        _claimAmount(_amount);
    }

    function test_amounts(uint _amount) public {
        vm.assume(_amount <= ido.investMax() && _amount >= ido.investMin());

        approveIdo(token.decimals());

        skip(ido.saleStart());

        vm.prank(dev);
        ido.invest{value: _amount}();
    }

    function test_saleEnded() public {
        skip(ido.saleEnd());
        vm.expectRevert();
        ido.invest{value: 1 ether}();
    }

    function test_beforeStart() public {
        vm.expectRevert();
        ido.invest{value: 1 ether}();
    }
}
