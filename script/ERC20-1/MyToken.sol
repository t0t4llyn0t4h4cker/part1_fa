// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address private owner;

    constructor() ERC20("TOKEN", "TT") {
        owner = msg.sender;
    }

    function mint() external {
        _mint(msg.sender, 1);
    }
}
