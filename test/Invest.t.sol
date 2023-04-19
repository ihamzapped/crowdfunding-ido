pragma solidity >=0.8;

import {BaseSetup} from "./BaseSetup.t.sol";
import {console, stdStorage, StdStorage} from "forge-std/Test.sol";

contract Test_Invest is BaseSetup {
    // using stdStorage for StdStorage;

    // StdStorage private stdstore;

    function test_claimAmount() public {
        approveIdo();

        skip(ido.saleStart());

        vm.startPrank(dev);
        ido.invest{value: 1 ether}();
        ido.invest{value: 1 ether}();

        uint _claims = ido.s_claims(dev);

        assertEq(_claims, 200 ether);
    }

    function test_amounts(uint _amount) public {
        vm.assume(_amount <= ido.investMax() && _amount >= ido.investMin());

        approveIdo();

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

    function approveIdo() private {
        vm.startPrank(owner);
        token.approve(address(ido), ido.hardcap());
        vm.stopPrank();
    }
}
