// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error PoolFactory__IdenticalAddress();
error PoolFactory__ZeroAddress();

library UniswapV2Library {
    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(
        address tokenA,
        address tokenB
    ) internal pure returns (address token0, address token1) {
        if (tokenA == tokenB) revert PoolFactory__IdenticalAddress();
        (token0, token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        // since tokenA is the smaller address we can check if its == address(0);
        if (token0 == address(0)) revert PoolFactory__ZeroAddress();
    }
}
