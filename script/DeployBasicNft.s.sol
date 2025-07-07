// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract DeployBasicNft is Script {
    address public deployer;

    function run() public returns (BasicNft) {
        if (block.chainid == 11155111) {
            uint256 PRIVATE_KEY = vm.envUint("DEV_PRIVATE_KEY");
            deployer = vm.envAddress("DEV_ADDRESS");
            vm.startBroadcast(PRIVATE_KEY);
            BasicNft basicNft = new BasicNft(deployer);
            vm.stopBroadcast();
            console2.log("minter is: ", msg.sender);
            address owner = basicNft.owner();
            console2.log("owner is: ", owner);
            return basicNft;
        } else {
            vm.startBroadcast();
            BasicNft basicNft = new BasicNft(msg.sender);
            vm.stopBroadcast();
            console2.log("minter is: ", msg.sender);
            address owner = basicNft.owner();
            console2.log("owner is: ", owner);
            return basicNft;
        }
    }
}
