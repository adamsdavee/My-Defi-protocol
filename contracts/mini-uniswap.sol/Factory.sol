// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Pool.sol";
import "./interfaces/IPool.sol";

error MiniUniswapFactory__IdenticalAddress();

contract MiniUniswapFactory {
    // address public feeTo;
    // address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    // constructor(address _feeToSetter) public {
    //     feeToSetter = _feeToSetter;
    // }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address poolPair) {
        if (tokenA == tokenB) revert MiniUniswapFactory__IdenticalAddress();
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        if (token0 == address(0)) revert MiniUniswapFactory__ZERO_ADDRESS();
        if (getPair[token0][token1] != address(0))
            MiniUniswapFactory__PairExists();
        bytes memory bytecode = type(Pool).creationCode;
        assembly {
            poolPair := create2(0, add(bytecode, 32), mload(bytecode))
        }
        IPool(poolPair).init(token0, token1);
        getPair[token0][token1] = poolPair;
        getPair[token1][token0] = poolPair;
        allPairs.push(poolPair);
        emit PairCreated(token0, token1, poolPair, allPairs.length);
    }

    function getPairAddress(
        address _tokenA,
        address _tokenB
    ) public view returns (address) {
        return getPair[_tokenA][_tokenB];
    }

    // function setFeeTo(address _feeTo) external {
    //     require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
    //     feeTo = _feeTo;
    // }

    // function setFeeToSetter(address _feeToSetter) external {
    //     require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
    //     feeToSetter = _feeToSetter;
    // }
}
