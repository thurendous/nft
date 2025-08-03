// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

contract showMeAddress is Script {
    function run() public {
        vm.startBroadcast();
        uint256 PRIVATE_KEY = vm.envUint("DEV_PRIVATE_KEY");
        address deployer = vm.addr(PRIVATE_KEY);
        address dotenvDeployer = vm.envAddress("DEV_ADDRESS");
        console.log("deployer is", deployer);
        console.log("dotenv deployer is", dotenvDeployer);
        vm.stopBroadcast();
    }
}
