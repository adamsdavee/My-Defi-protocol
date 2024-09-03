// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CherryToken is ERC20 {
    constructor() ERC20("Cherry", "CHT") {}

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }

    // TODO: transfer to burn
}
