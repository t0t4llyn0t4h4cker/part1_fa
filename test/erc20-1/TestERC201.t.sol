// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import "../../src/ERC20-1/MyToken.sol";

contract TestERC201 is PRBTest, StdCheats {
    MyToken myToken;
    address owner;
    address user1;
    address user2;
    address user3;

    uint256 constant DEPLOYER_MINT = 100_000;
    uint256 constant USER_MINT = 5000;
    uint256 constant USER2_TRANSFER = 100;
    uint256 constant USER3_APPROVE = 1000;

    function setUp() public {
        // setup accounts and contract
        myToken = new MyToken();
        owner = address(1);
        user1 = address(2);
        user2 = address(3);
        user3 = address(4);
        // mint
        myToken.mint(owner, DEPLOYER_MINT);
        myToken.mint(user1, USER_MINT);
        myToken.mint(user2, USER_MINT);
        myToken.mint(user3, USER_MINT);

        assertEq(myToken.balanceOf(owner), DEPLOYER_MINT);
        assertEq(myToken.balanceOf(user1), USER_MINT);
        assertEq(myToken.balanceOf(user2), USER_MINT);
        assertEq(myToken.balanceOf(user3), USER_MINT);
    }

    /// @dev Simple test. Run Forge with `-vvvv` to see console logs.
    function test_Transfer() external {
        // user2 transfer to user3
        vm.prank(user2);
        myToken.transfer(user3, USER2_TRANSFER);
        // user3 approve user1
        vm.prank(user3);
        myToken.approve(user1, USER3_APPROVE);
        // user1 sends with approval transferFrom
        vm.prank(user1);
        myToken.transferFrom(user3, user1, USER3_APPROVE);
        //verify
        assertEq(myToken.balanceOf(user1), USER_MINT + USER3_APPROVE);
        assertEq(myToken.balanceOf(user2), USER_MINT - USER2_TRANSFER);
        assertEq(myToken.balanceOf(user3), USER_MINT + USER2_TRANSFER - USER3_APPROVE);
    }
}
