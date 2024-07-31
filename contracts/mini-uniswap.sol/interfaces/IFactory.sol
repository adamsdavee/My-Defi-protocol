// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IFactory {
    function getPairAddress(
        address tokenA,
        address tokenB
    ) external returns (address);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address poolPair);
}
