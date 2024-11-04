// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {PumpToken} from "./PumpToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PumpPair {
    error PumpPair__MustApproveTransfer();
    error PumpPair__TransferFromFailed();
    error PumpPair__TransferFailed();
    error PumpPair__BuyAmountTooLow();

    PumpToken private immutable pumpToken;
    IERC20 private immutable weth;

    uint256 private INITIAL_FAKE_WETH_IN_POOL = 2608750473e12;
    uint256 public constant INITIAL_PUMP_TOKEN_IN_BONDING_CURVE =
        793_100_000e18;

    constructor(PumpToken _pumpToken, IERC20 _weth) {
        pumpToken = _pumpToken;
        weth = _weth;
    }

    function buy(uint256 _amount) external {
        require(_amount > 0, PumpPair__BuyAmountTooLow());
        uint256 requiredWeth = _calculateWethAmount(_amount);
        weth.approve(address(this), requiredWeth);
        require(
            weth.transferFrom(msg.sender, address(this), requiredWeth),
            PumpPair__TransferFromFailed()
        );
        require(
            pumpToken.transfer(msg.sender, _amount),
            PumpPair__TransferFailed()
        );
    }

    function _calculateWethAmount(
        uint256 _amount
    ) internal view returns (uint256) {
        uint256 pumpTokenBalance = pumpToken.balanceOf(address(this));
        uint256 wethBalance = weth.balanceOf(address(this));
        uint256 wethAmountInPool = wethBalance + INITIAL_FAKE_WETH_IN_POOL;

        uint256 wethAmount = (_amount * wethAmountInPool) /
            (pumpTokenBalance + _amount);
        return wethAmount;
    }
}
