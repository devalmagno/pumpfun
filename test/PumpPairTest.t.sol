// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {PumpFactory} from "../src/PumpFactory.sol";
import {PumpPair} from "../src/PumpPair.sol";
import {PumpToken} from "../src/PumpToken.sol";

import {MockWETH} from "./mocks/MockWETH.sol";

contract PumpPairTest is Test {
    PumpFactory factory;
    PumpPair pair;
    PumpToken token;
    MockWETH weth;

    address public dev = makeAddr("dev");
    address public user = makeAddr("user");

    function setUp() public {
        weth = new MockWETH();
        factory = new PumpFactory(address(weth));
        vm.prank(dev);
        (token, pair) = factory.createToken("Pump", "FUN");
    }

    function testBuyFromBondingCurve() public {}
}
