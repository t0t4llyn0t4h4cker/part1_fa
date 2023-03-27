// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address private $owner;

    modifier OnlyOwner() {
        require(msg.sender == $owner, "Not Owner");
        _;
    }

    constructor() ERC20("TOKEN", "TT") {
        $owner = msg.sender;
    }

    function mint(address to, uint256 amount) external OnlyOwner {
        _mint(to, amount);
    }
}
