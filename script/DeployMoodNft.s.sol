// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { MoodNft } from "../src/MoodNft.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { console } from "forge-std/console.sol";

contract DeployMoodNft is Script {
    function run() public returns (MoodNft) {
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");
        string memory sadSvgUri = toSvgImageUri(sadSvg);
        string memory happySvgUri = toSvgImageUri(happySvg);
        console.log("sadSvgUri", sadSvgUri);
        console.log("happySvgUri", happySvgUri);

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(happySvgUri, sadSvgUri);
        vm.stopBroadcast();
        return moodNft;
    }

    function toSvgImageUri(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));

        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
