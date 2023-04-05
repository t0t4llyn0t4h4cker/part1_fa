// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract bToken is ERC20 {
    address public $owner;
    address public $tokenAddress;

    // TODO: Complete this contract functionality

    modifier OnlyOwner() {
        require(msg.sender == $owner, "Only Owner");
        _;
    }

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        address tokenAddress
    )
        ERC20(tokenName, tokenSymbol)
    {
        require(tokenAddress != address(0));
        $owner = msg.sender;
        tokenAddress = tokenAddress;
    }

    function mint(address to, uint256 amount) external OnlyOwner {
        // internal fn performs checks
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external OnlyOwner {
        // internal fn performs checks
        _burn(from, amount);
    }
}
