// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";
// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import {Base64} from "./libraries/base64New.sol";

contract MyEpicNFT is ERC721URIStorage {
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='url(#gradient-fill)' />";

    //<defs><linearGradient id='gradient-fill' x1='0' y1='0' x2='800' y2='0' gradientUnits='userSpaceOnUse'><stop offset='0' stop-color='#3b2133' /><stop offset='0.16666666666666666' stop-color='#412639' /><stop offset='0.3333333333333333' stop-color='#4f3547' /><stop offset='0.5' stop-color='#614c5a' /><stop offset='0.6666666666666666' stop-color='#73666f' /><stop offset='0.8333333333333333' stop-color='#817d80' /><stop offset='1' stop-color='#878787' /></linearGradient></defs>

    // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever!
    string[] firstWords = [
        "Chaos",
        "Blessed",
        "True",
        "Worried",
        "Curious",
        "Quiet"
    ];
    string[] secondWords = [
        "Dusk",
        "Core",
        "Eclipse",
        "Twilight",
        "Shadow",
        "Dream"
    ];

    string[] thirdWords = ["Gemini", "Aries", "Ra", "Onyx", "Raijin", "Joker"];

    string[] Colors = [
        "<defs><linearGradient id='gradient-fill' x1='0' y1='0' x2='800' y2='0' gradientUnits='userSpaceOnUse'><stop offset='0' stop-color='#3b2133' /><stop offset='0.16666666666666666' stop-color='#412639' /><stop offset='0.3333333333333333' stop-color='#4f3547' /><stop offset='0.5' stop-color='#614c5a' /><stop offset='0.6666666666666666' stop-color='#73666f' /><stop offset='0.8333333333333333' stop-color='#817d80' /><stop offset='1' stop-color='#878787' /></linearGradient></defs>",
        "<defs><linearGradient id='gradient-fill' x1='0' y1='0' x2='800' y2='0' gradientUnits='userSpaceOnUse'><stop offset='0' stop-color='#a1107f' /><stop offset='0.16666666666666666' stop-color='#a51594' /><stop offset='0.3333333333333333' stop-color='#9524ae' /><stop offset='0.5' stop-color='#7139bb' /><stop offset='0.6666666666666666' stop-color='#5650c7' /><stop offset='0.8333333333333333' stop-color='#647fd0' ><stop offset='1' stop-color='#6c92d4' /></linearGradient></defs>",
        "<defs><linearGradient id='gradient-fill' x1='0' y1='0' x2='800' y2='0' gradientUnits='userSpaceOnUse'><stop offset='0' stop-color='#cff2ff' /><stop offset='0.16666666666666666' stop-color='#bee1f0' /><stop offset='0.3333333333333333' stop-color='#96b8cb' /><stop offset='0.5' stop-color='#67849c' /><stop offset='0.6666666666666666' stop-color='#40546c' /><stop offset='0.8333333333333333' stop-color='#263347' /><stop offset='1' stop-color='#1d2738' /></linearGradient></defs>",
        "<defs><linearGradient id='gradient-fill' x1='0' y1='0' x2='800' y2='0' gradientUnits='userSpaceOnUse'><stop offset='0' stop-color='#0aff9d' /><stop offset='0.16666666666666666' stop-color='#17f0ac' /><stop offset='0.3333333333333333' stop-color='#30cbbb' /><stop offset='0.5' stop-color='#428d9c' /><stop offset='0.6666666666666666' stop-color='#41596c' /><stop offset='0.8333333333333333' stop-color='#353b47' /><stop offset='1' stop-color='#2d3038' /></linearGradient></defs>",
        "<defs><linearGradient id='gradient-fill' x1='0' y1='0' x2='800' y2='0' gradientUnits='userSpaceOnUse'><stop offset='0' stop-color='#000000' /><stop offset='0.16666666666666666' stop-color='#051011' /><stop offset='0.3333333333333333' stop-color='#12373a' /><stop offset='0.5' stop-color='#236b70' /><stop offset='0.6666666666666666' stop-color='#339ea6' /><stop offset='0.8333333333333333' stop-color='#49bec7' /><stop offset='1' stop-color='#5ac4cc' /></linearGradient></defs>",
        "<defs><linearGradient id='gradient-fill' x1='0' y1='0' x2='800' y2='0' gradientUnits='userSpaceOnUse'><stop offset='0' stop-color='#21184a' /><stop offset='0.16666666666666666' stop-color='#2b1b55' /><stop offset='0.3333333333333333' stop-color='#4b2271' /><stop offset='0.5' stop-color='#832a96' /><stop offset='0.6666666666666666' stop-color='#bc31a9' /><stop offset='0.8333333333333333' stop-color='#d0409a' /><stop offset='1' stop-color='#d44a93' /></linearGradient></defs>"
    ];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("Initializing NFT Mint System!");
    }

    // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(
                abi.encodePacked("BACKGROUND_COLOR", Strings.toString(tokenId))
            )
        );
        rand = rand % Colors.length;
        return Colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // A function our user will hit to get their NFT.
    function makeAnEpicNFT() public {
        //set Maximum limit of NFTs to be minted
        require(_tokenIds.current() < 50, "No More NFTs cant be Minted");
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        // We go and randomly grab one word from each of the three arrays.
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory color = pickRandomColor(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        // I concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(
            abi.encodePacked(
                baseSvg,
                color,
                "<text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>",
                combinedWord,
                "</text></svg>"
            )
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "Collection of linear gradient squares with rare words, and color patterns, for unique design and phrase!", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log(finalTokenUri);
        console.log("--------------------\n");

        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFTs data.
        _setTokenURI(newItemId, finalTokenUri);
        //Mega man  NFT => "data:application/json;base64,eyJuYW1lIjoiRXBpY0xvcmRIYW1idXJnZXIiLCJkZXNjcmlwdGlvbiI6IkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStRbUZ1WVc1aFQzVjBVWFZwWTJzOEwzUmxlSFErQ2p3dmMzWm5QZz09In0="
        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // Increment the counter for when the next NFT is minted.

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function getTokenId() public view returns (uint256) {
        return _tokenIds.current();
    }
}

//Basic Beginning to a contract
// pragma solidity ^0.8.0;

// import "hardhat/console.sol";

// contract MyEpicNFT {
//     constructor() {
//         console.log("This is my NFT contract. Whoa!");
//     }
// }
