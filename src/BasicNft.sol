// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

error BasicNft__TokenDoesNotExist();

contract BasicNft is ERC721URIStorage, Ownable {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    constructor(address _owner) ERC721("Dogie", "DOGIE") Ownable(_owner) {
        // s_tokenCounter = 0;
    }

    // anyone can mint an NFT and make it look like whatever they want
    function mintNft(string memory uri) public {
        s_tokenIdToUri[s_tokenCounter] = uri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (tokenId >= s_tokenCounter) {
            revert BasicNft__TokenDoesNotExist();
        }
        return s_tokenIdToUri[tokenId];
    }
}
