// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { TokensDepo } from "../../src/ERC20-2/TokensDepo.sol";
import { bToken } from "../../src/ERC20-2/bToken.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokensDepoTest is PRBTest, StdCheats {
    TokensDepo public tokensDepo;
    address deployer = address(1);
    address aaveHolder = address(0x2eFB50e952580f4ff32D8d2122853432bbF2E204);
    address constant uniHolder = address(0x193cEd5710223558cd37100165fAe3Fa4dfCDC14);
    address constant wethHolder = address(0x741AA7CFB2c7bF2A1E7D4dA2e3Df6a56cA4131F3);

    uint256 initAaveBal;
    uint256 initUniBal;
    uint256 initWethBal;

    address constant AAVE_ADDRESS = address(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9);
    address constant UNI_ADDRESS = address(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
    address constant WETH_ADDRESS = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    uint32 constant AAVE_AMOUNT = 15;
    uint32 constant UNI_AMOUNT = 5231;
    uint32 constant WETH_AMOUNT = 33;

    function setUp() external {
        // deploy contract
        tokensDepo = new TokensDepo(AAVE_ADDRESS,UNI_ADDRESS,WETH_ADDRESS);
        // give accounts eth to pay for gas
        vm.deal(aaveHolder, 1 ether);
        vm.deal(uniHolder, 1 ether);
        vm.deal(wethHolder, 1 ether);
        // set initBals
        initAaveBal = IERC20(AAVE_ADDRESS).balanceOf(aaveHolder);
        initUniBal = IERC20(UNI_ADDRESS).balanceOf(uniHolder);
        initWethBal = IERC20(WETH_ADDRESS).balanceOf(wethHolder);
    }

    function test() external {
        // deposit 15 AAVE
        vm.startPrank(aaveHolder);
        IERC20(AAVE_ADDRESS).approve(address(tokensDepo), AAVE_AMOUNT);
        tokensDepo.depositTokens(AAVE_ADDRESS, AAVE_AMOUNT);
        vm.stopPrank();
        // deposit 5231 uni
        vm.startPrank(uniHolder);
        IERC20(UNI_ADDRESS).approve(address(tokensDepo), UNI_AMOUNT);
        tokensDepo.depositTokens(UNI_ADDRESS, UNI_AMOUNT);
        vm.stopPrank();
        // deposit 33 weth
        vm.startPrank(wethHolder);
        IERC20(WETH_ADDRESS).approve(address(tokensDepo), WETH_AMOUNT);
        tokensDepo.depositTokens(WETH_ADDRESS, WETH_AMOUNT);
        vm.stopPrank();
        // check depo tokens
        assertEq(IERC20(AAVE_ADDRESS).balanceOf(address(tokensDepo)), AAVE_AMOUNT);
        assertEq(IERC20(UNI_ADDRESS).balanceOf(address(tokensDepo)), UNI_AMOUNT);
        assertEq(IERC20(WETH_ADDRESS).balanceOf(address(tokensDepo)), WETH_AMOUNT);
    }
}
