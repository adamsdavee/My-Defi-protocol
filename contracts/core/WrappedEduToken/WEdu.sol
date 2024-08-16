// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WrappedEdutoken is ERC20 {
    constructor() ERC20("WrappedEdu", "WEDU") {}

    function deposit(uint256 amount) public payable {
        _mint(msg.sender, amount);
    }

    // TODO: transfer to burn
}
