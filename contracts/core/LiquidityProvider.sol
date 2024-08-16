// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IFactory.sol";
import "./interfaces/IPool.sol";
import "./interfaces/IWedu.sol";

error LiquidityProvider__InsufficientAmount();

contract LiquidityProvider {
    address private immutable factoryAddress;
    address private immutable WEDU;

    constructor(address _factoryAddress, address _WEDU) {
        factoryAddress = _factoryAddress;
        WEDU = _WEDU;
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

    function addLiquidity(address tokenA, address tokenB) external returns(uint256 amountA, uint256 amountB, uint256 liquidity) {
        // TODO: (amountA, amountB) = _addLiquidity();
        address pair = IFactory(factoryAddress).getPairAddress(tokenA, tokenB);
        IERC20(tokenA).transferFrom(msg.sender, pair, amountA);
        IERC20(tokenB).transferFrom(msg.sender, pair, amountB);
        liquidity = IPool(pair).mint(msg.sender);
    }

    function addLiquidityEdu(address tokenA) external returns(uint256 amountA, uint256 amountEDU, uint256 liquidity) {
        // TODO (amountA, amountEDU) = _addLiquidity();
        address pair = IFactory(factoryAddress).getPairAddress(tokenA, WEDU);
        IERC20(tokenA).transferFrom(msg.sender, pair, amountA);
        IWEDU(WEDU).deposit{value: amountEDU}();
        assert(IWEDU(WEDU).transfer(pair, amountEDU));
        liquidity = IPool(pair).mint(msg.sender);

        if(msg.value > amountEDU) (bool success,) = msg.sender.call{value:value}("");
        if(!success) revert LiquidityProvider__EDUTransferFailed();
    }

    // TODO: Remove liquidity & liquidityEdu



    // Swapppp

    function

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
