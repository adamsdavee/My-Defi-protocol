// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.9;

// import "./interfaces/IPool.sol";
// import "./Pool.sol";

// error MiniUniswapFactory__IdenticalAddress();
// error MiniUniswapFactory__ZERO_ADDRESS();
// error MiniUniswapFactory__PairExists();

// contract MiniUniswapFactory {
//     // address public feeTo;
//     // address public feeToSetter;

//     mapping(address => mapping(address => address)) public getPair;
//     address[] public allPairs;

//     event PairCreated(
//         address indexed token0,
//         address indexed token1,
//         address pair,
//         uint
//     );

//     // constructor(address _feeToSetter) public {
//     //     feeToSetter = _feeToSetter;
//     // }

//     function allPairsLength() external view returns (uint) {
//         return allPairs.length;
//     }

//     function createPair(
//         address tokenA,
//         address tokenB
//     ) external returns (address poolPair) {
//         if (tokenA == tokenB) revert MiniUniswapFactory__IdenticalAddress();
//         (address token0, address token1) = tokenA < tokenB
//             ? (tokenA, tokenB)
//             : (tokenB, tokenA);
//         if (token0 == address(0)) revert MiniUniswapFactory__ZERO_ADDRESS();
//         if (getPair[token0][token1] != address(0))
//             MiniUniswapFactory__PairExists();
//         bytes memory bytecode = type(MiniUniswapPool).creationCode;
//         assembly {
//             poolPair := create2(0, add(bytecode, 32), mload(bytecode))
//         }
//         IPool(poolPair).init(token0, token1);
//         getPair[token0][token1] = poolPair;
//         getPair[token1][token0] = poolPair;
//         allPairs.push(poolPair);
//         emit PairCreated(token0, token1, poolPair, allPairs.length);
//     }

//     function getPairAddress(
//         address _tokenA,
//         address _tokenB
//     ) public view returns (address) {
//         return getPair[_tokenA][_tokenB];
//     }

//     // function setFeeTo(address _feeTo) external {
//     //     require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
//     //     feeTo = _feeTo;
//     // }

//     // function setFeeToSetter(address _feeToSetter) external {
//     //     require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
//     //     feeToSetter = _feeToSetter;
//     // }

//     function
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./interfaces/IPool.sol";
import "./Pool.sol";

error PoolFactory__IdenticalAddress();
// error PoolFactory__ZERO_ADDRESS();
// error PoolFactory__PairExists();

contract PoolFactory {

    mapping(address => mapping(address => address)) private getPairs;
    address[] private allPairs;

    event PoolCreated(address tokenA, address tokenB, address poolAddress);

    function createPool(address tokenA, tokenB) external returns(address poolAddress) {
        if(tokenA == tokenB) revert PoolFactory__IdenticalAddress();
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        // since tokenA is the smaller address we can check if its == address(0);
        if(token0 == address(0)) revert PoolFactory__ZeroAddress();
        if(getPairs[token0][token1] != address(0)) revert PoolFactory__PoolExists();

        bytes memory bytecode = type(Pool).creationCode;

        assembly {
            poolAddress := create2(0, add(bytecode, 32), mload(bytecode));
        }

        getPairs[token0][token1] = poolAddress;
        getPairs[token1][token0] = poolAddress;
        allPairs.push(poolAddress);

        emit PoolCreated(token0, token1, poolAddress);
    }
}
