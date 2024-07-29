// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CherryToken is ERC20 {
    constructor() ERC20("CHERRYCOIN", "CYN") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
