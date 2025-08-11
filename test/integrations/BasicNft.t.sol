// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console2 } from "forge-std/Test.sol";
import { DeployBasicNft } from "../../script/DeployBasicNft.s.sol";
import { BasicNft } from "../../src/BasicNft.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract BasicNftTest is Test {
    string public constant PUG_URL =
        "https://ipfs.io/ipfs/QmYx6Gs7mPGSiG2PxvxtzMJpn9zTis6tz88d7dpx8tJ9d?filename=pug.png";

    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public user = makeAddr("user");
    address public minter = makeAddr("minter");
    address private DEFAULT_FOUNDRY_DEPLOYER = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
    address private ORIGINAL_MINTER_OWNER = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
        console2.log("owner is : ", basicNft.owner());

        // 在 fork 测试中，使用实际的合约拥有者
        address actualOwner = basicNft.owner();

        // 转移所有权到 DEFAULT_FOUNDRY_DEPLOYER
        vm.prank(actualOwner);
        basicNft.transferOwnership(DEFAULT_FOUNDRY_DEPLOYER);

        vm.prank(DEFAULT_FOUNDRY_DEPLOYER);
        basicNft.mintNft(PUG_URL);
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assertEq(expectedName, actualName);
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "DOGIE";
        string memory actualSymbol = basicNft.symbol();
        assertEq(expectedSymbol, actualSymbol);
    }

    function testTokenURIIsCorrect() public view {
        string memory expectedUri = PUG_URL;
        string memory actualUri = basicNft.tokenURI(0);
        assertEq(expectedUri, actualUri);
        assert(keccak256(abi.encodePacked(expectedUri)) == keccak256(abi.encodePacked(actualUri)));
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(DEFAULT_FOUNDRY_DEPLOYER);
        basicNft.mintNft(PUG_URL);
        assertEq(basicNft.balanceOf(DEFAULT_FOUNDRY_DEPLOYER), 2);
    }

    function testAnyoneCanMint() public {
        // Test that anyone can mint NFTs
        vm.prank(user);
        basicNft.mintNft(PUG_URL);
        assertEq(basicNft.balanceOf(user), 1);
        assertEq(basicNft.tokenURI(1), PUG_URL);
    }
}
