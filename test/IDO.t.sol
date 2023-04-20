pragma solidity >=0.8;

import {IDO, Token} from "../contracts/IDO.sol";
import {CommonBase} from "./CommonBase.t.sol";
import {ERC20} from "../mocks/MockERC20.sol";
import {console, stdStorage, StdStorage} from "forge-std/Test.sol";

contract Test_IDO is CommonBase {
    using stdStorage for StdStorage;

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

    function test_claim() public {
        approveIdo(token.decimals());

        skip(ido.saleStart());

        vm.startPrank(dev);
        ido.invest{value: 1 ether}();

        skip(ido.saleEnd());

        vm.expectRevert();
        ido.claim();

        skip(ido.claimStart());

        uint _preBal = token.balanceOf(dev);
        uint _preClaims = ido.s_claims(dev);

        ido.claim();

        uint _postBal = token.balanceOf(dev);
        uint _postClaims = ido.s_claims(dev);

        assertEq(_postClaims, 0);
        assertEq(_postBal, _preClaims + _preBal);
    }

    function test_claimAmount(uint _amount) public {
        _claimAmount(_amount);
    }

    function test_goalReached() public {
        skip(ido.saleStart());

        stdstore.target(address(ido)).sig("s_raised()").checked_write(
            ido.hardcap()
        );

        vm.expectRevert();
        ido.invest{value: 1 ether}();
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
