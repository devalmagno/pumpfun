// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {PumpToken} from "./PumpToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PumpPair {
    PumpToken private immutable pumpToken;
    IERC20 private immutable weth;

    uint256 private s_currentPumpTokenInPool = 1_000_000_000e18;
    uint256 private s_currentWethBalanceInPool = 2608750473e12;

    constructor(address _pumpToken, address _weth) {
        pumpToken = PumpToken(_pumpToken);
        weth = IERC20(_weth);
    }

    function buy(uint256 _amount) external {
        require(_amount > 0);
        uint256 requiredWeth = _calculateWethAmount(_amount);
        weth.approve(address(this), requiredWeth);
        weth.transferFrom(msg.sender, address(this), requiredWeth);
        pumpToken.transfer(msg.sender, _amount);
    }

    function _calculateWethAmount(uint256 _amount) internal view returns (uint256) {
        uint256 wethAmount = s_currentPumpTokenInPool * s_currentWethBalanceInPool / s_currentPumpTokenInPool + _amount;
        return wethAmount;
    }
}
