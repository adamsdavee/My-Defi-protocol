// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IPool {
    // event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function init(address _tokenA, address _tokenB) external;
}
