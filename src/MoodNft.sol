// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721, ERC721URIStorage, Ownable {
    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    mapping(uint256 => Mood) private s_tokenIdToMood;

    enum Mood {
        HAPPY,
        SAD
    }

    event CreatedNFT(uint256 indexed tokenId);
    event MoodFlipped(uint256 indexed tokenId, Mood mood);

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri)
        ERC721("Mood NFT", "MN")
        Ownable(msg.sender)
    {
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function mintNft() public {
        // how would you require payment for this NFT?
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;

        emit CreatedNFT(tokenCounter);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function flipMood(uint256 tokenId) public {
        // fetch the onwer of the token
        address owner = ownerOf(tokenId);
        // Only want the owner of NFT to change the mood
        _checkAuthorized(owner, msg.sender, tokenId);

        // flip the mood
        s_tokenIdToMood[tokenId] = s_tokenIdToMood[tokenId] == Mood.HAPPY ? Mood.SAD : Mood.HAPPY;

        // emit the event
        emit MoodFlipped(tokenId, s_tokenIdToMood[tokenId]);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        string memory tokenMetadata = string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );

        return tokenMetadata;
    }
}
