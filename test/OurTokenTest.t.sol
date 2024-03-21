//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice"); 

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowances() public{
         uint256 initialAllowance = 1000;

         //Bob approves Alice to spend tokens on his behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransfers() public {
        uint256 initialBalanceAlice = ourToken.balanceOf(alice);
        uint256 initialBalanceBob = ourToken.balanceOf(bob);

        vm.prank(msg.sender);

        ourToken.transfer(bob, 100);

        assertEq(ourToken.balanceOf(alice), initialBalanceAlice);
        assertEq(ourToken.balanceOf(bob), initialBalanceBob + 100);
    }
     function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    
}