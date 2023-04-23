pragma solidity >=0.8;

import {IDO, Token} from "../contracts/IDO.sol";
import {CommonBase} from "./CommonBase.t.sol";
import {IDO} from "./IDO.t.sol";
import {ERC20} from "../contracts/mocks/MockERC20.sol";
import {console, stdStorage, StdStorage} from "forge-std/Test.sol";

contract Test_IDOusdt is CommonBase {
    function setUp() public virtual override {
        super.setUp();
        vm.startPrank(owner);
        token = new ERC20(6);
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

    function test_invest(uint _amount) public {
        _investTest(_amount);
    }

    function test_claim() public {
        _claimsTest();
    }
}
