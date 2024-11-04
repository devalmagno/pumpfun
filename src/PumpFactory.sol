// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {PumpToken} from "./PumpToken.sol";
import {PumpPair} from "./PumpPair.sol";

contract PumpFactory {
    mapping(address dev => address token) private devTokens;
    mapping(address token => address pair) private tokenPair;

    IERC20 public immutable weth;
    uint256 private MINT_AMOUNT = 1_000_000_000e18;

    constructor(address _weth) {
        weth = IERC20(_weth);
    }

    function createToken(
        string memory _name,
        string memory _symbol
    ) external returns (PumpToken, PumpPair) {
        PumpToken token = new PumpToken(_name, _symbol);
        PumpPair pair = new PumpPair(token, weth);
        token.mint(address(pair), MINT_AMOUNT);

        devTokens[msg.sender] = address(token);
        tokenPair[address(token)] = address(pair);

        return (token, pair);
    }
}
