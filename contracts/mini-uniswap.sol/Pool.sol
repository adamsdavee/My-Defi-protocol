// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Math.sol";

error MiniUniswapFactory__NotOwner();

contract MiniUniswapFactory is ERC20 {
    using Math for uint256;

    address private immutable factory;
    address private immutable tokenA;
    address private immutable tokenB;

    uint256 public constant MINIMUM_LIQUIDITY = 10 ** 3;

    uint256 private reserveA;
    uint256 private reserveB;

    uint256 private totalLpShares;
    uint256 public kLast;

    constructor() ERC20("LiquidityTokens", "LP") {
        factory = msg.sender;
    }

    function init(address _tokenA, address _tokenB) external {
        if (factory != msg.sender) revert MiniUniswapFactory__NotOwner();

        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function _update(uint256 _balanceA, uint256 _balanceB) private {
        reserveA = _reserveA;
        reserveB = _reserveB;
    }

    function mint(address _to, bool feeOn) external {
        (uint256 _reserveA, uint256 _reserveB, ) = getReserves();
        uint256 _balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 _balanceB = IERC20(tokenB).balanceOf(address(this));
        uint256 depositOfTokenA = _balanceA - _reserve0;
        uint256 depositOfTokenB = _balanceB - _reserve1;

        uint256 _totalSupply = totalSupply();
        if (_totalSupply == 0) {
            liquidity =
                Math.sqrt(depositOfTokenA * depositOfTokenB) -
                (MINIMUM_LIQUIDITY);
            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens to avoid the pool being drained
        } else {
            liquidity = Math.min(
                (depositOfTokenA * _totalSupply) / _reserveA,
                (depositOfTokenB * _totalSupply) / _reserveB
            );
        }
        if (liquidity <= 0) revert MiniUniswapFactory__InsufficientLiquidity();
        _mint(_to, liquidity);
        _update(_balanceA, _balanceB);

        if (feeOn) kLast = _reserveA * _reserveB; // reserve0 and reserve1 are up-to-date

        emit Mint(msg.sender, depositOfTokenA, depositOfTokenB);
    }

    // BURN
    function liquidateLpTokens(
        address to
    ) external lock returns (uint amount0, uint amount1) {
        (uint256 _reserve0, uint256 _reserve1, ) = getReserves(); // gas savings
        address _tokenA = tokenA; // gas savings
        address _tokenB = tokenB; // gas savings
        uint balanceA = IERC20(_tokenA).balanceOf(address(this));
        uint balanceB = IERC20(_tokenB).balanceOf(address(this));
        uint liquidity = balanceOf(to);

        uint256 _totalSupply = totalSupply(); // gas savings, must be defined here since totalSupply can update in _mintFee
        amountA = (liquidity * balanceA) / _totalSupply; // using balances ensures pro-rata distribution
        amountB = (liquidity * balanceB) / _totalSupply; // using balances ensures pro-rata distribution
        if (amountA <= 0 && amountB <= 0)
            revert MiniUniswapFactory__InsufficientLiquididty();
        _burn(address(this), liquidity);
        IERC20(_tokenA).transfer(to, amountA);
        IERC20(_tokenB).transfer(to, amountB);
        balanceA = IERC20(_tokenA).balanceOf(address(this));
        balanceB = IERC20(_tokenB).balanceOf(address(this));

        _update(balanceA, balanceB);

        emit Burn(msg.sender, amount0, amountB, to);
    }

    function getTokenReserves() external returns (uint256, uint256) {
        return (reserveA, reserveB);
    }

    // force reserves to match balances
    function sync() external lock {
        _update(
            IERC20(tokenA).balanceOf(address(this)),
            IERC20(tokenB).balanceOf(address(this))
        );
    }
}
