// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {PumpToken} from "./PumpToken.sol";

contract PumpFactory {
    mapping(address dev => address token) private devTokens;
    mapping(address token => address pair) private tokenPair;

    function createToken(string memory _name, string memory _symbol) external {
        PumpToken token = new PumpToken(_name, _symbol);
    }
}
