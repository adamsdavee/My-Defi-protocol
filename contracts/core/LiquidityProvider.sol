// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IFactory.sol";
import "./interfaces/IPool.sol";

error LiquidityProvider__InsufficientAmount();

contract LiquidityProvider {
    address private immutable factoryAddress;

    constructor(address _factoryAddress) {
        factoryAddress = _factoryAddress;
    }

    function _addLiquidity(
        address _tokenA,
        address _tokenB,
        uint256 amountOfTokenADesired,
        uint256 amountOfTokenBDesired,
        uint256 minTokenA,
        uint256 minTokenB
    ) external returns (uint256 amountA, uint256 amountB) {
        address memory pair = IFactory(factoryAddress).getPair(
            _tokenA,
            _tokenB
        );
        if (pair == address(0))
            pair = IFactory(factoryAddress).createPair(_tokenA, _tokenB);

        (uint256 reserveA, uint256 reserveB) = IPool(pair).getReserves();

        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountOfTokenADesired, amountOfTokenBDesired);
        } else {
            uint256 optimalAmountOfTokenB = quote(
                amountOfTokenADesired,
                reserveA,
                reserveB
            );
            if (optimalAmountOfTokenB <= amountOfTokenBDesired) {
                if (optimalAmountOfTokenB < minTokenB)
                    revert LiquidityProvider__InsufficientAmount();
                (amountA, amountB) = (amountOfTokenADesired, amountBOptimal);
            } else {
                uint256 amountAOptimal = quote(
                    amountOfTokenBDesired,
                    reserveB,
                    reserveA
                );
                assert(amountAOptimal <= amountADesired);
                if (amountAOptimal < minTokenA)
                    revert LiquidityProvider__InsufficientAmount();
                (amountA, amountB) = (amountAOptimal, amountOfTokenBDesired);
            }
        }
    }

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) internal pure returns (uint amountB) {
        require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
        require(
            reserveA > 0 && reserveB > 0,
            "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
        );
        amountB = (amountA * reserveB) / reserveA;
    }
}
