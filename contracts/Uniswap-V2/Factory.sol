// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.5.16;

import "@uniswap/v2-core/contracts/UniswapV2Factory.sol";

contract Factory is UniswapV2Factory {
    constructor(address _feeToSetter) public UniswapV2Factory(_feeToSetter) {}

    function getPairAddress(
        address _tokenA,
        address _tokenB
    ) public view returns (address) {
        return getPair[_tokenA][_tokenB];
    }
}
