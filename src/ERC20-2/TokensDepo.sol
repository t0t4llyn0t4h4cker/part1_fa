// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { bToken } from "./bToken.sol";

contract TokensDepo {
    mapping(address => IERC20) $depoTokens;
    mapping(address => bToken) $bTokens;

    constructor(address aaveAddress, address uniAddress, address wethAddress) {
        // setup interface for depositable tokens
        $depoTokens[aaveAddress] = IERC20(aaveAddress);
        $depoTokens[uniAddress] = IERC20(uniAddress);
        $depoTokens[wethAddress] = IERC20(wethAddress);
        // deploy collateral token contracts
        $bTokens[aaveAddress] = new bToken("bAave","bAave",aaveAddress);
        $bTokens[uniAddress] = new bToken("bUni","bUni",aaveAddress);
        $bTokens[wethAddress] = new bToken("bWeth","bWeth",aaveAddress);
    }

    function depositTokens(address depoToken, uint256 dAmount) external {
        //depo tokens to smart contract
        require(address($depoTokens[depoToken]) != address(0));
        (bool success) = $depoTokens[depoToken].transferFrom(msg.sender, address(this), dAmount);
        require(success, "Token transfer failed");
        // mint depo respective collateral tokens
        $bTokens[depoToken].mint(msg.sender, dAmount);
    }

    function withdrawTokens(address withdrawToken, uint256 bAmount) external {
        require(address($depoTokens[withdrawToken]) != address(0));
        // require(bAmount <= $bTokens[withdrawToken].balanceOf(msg.sender)); performed at _burn()
        $bTokens[withdrawToken].burn(msg.sender, bAmount);
        (bool success) = $depoTokens[withdrawToken].transfer(msg.sender, bAmount);
        require(success, "Token transfer failed");
    }
}
