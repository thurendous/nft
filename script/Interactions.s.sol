// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "./DeployBasicNft.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public user = makeAddr("user");
    address public minter = makeAddr("minter");
    address private DEFAULT_FOUNDRY_DEPLOYER = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
    address private ORIGINAL_MINTER_OWNER = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() public {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        basicNft = BasicNft(payable(mostRecentlyDeployed));
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(payable(contractAddress)).mintNft(PUG);
        vm.stopBroadcast();
    }
}
