// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./PlatziPunksDNA.sol";

contract PlatziPunks is ERC721, ERC721Enumerable, Ownable, PlatziPunksDNA {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    mapping(uint256 => uint256) public tokenDNA;
    address _owner;

    constructor(uint256 _maxSupply) ERC721("PlatziPunks", "PLZPNKS") {
        maxSupply = _maxSupply;
        _owner = msg.sender;
    }

    function mint() public {
        // require(msg.value >= 0.1 ether, "Insuficient funds");
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No PlatziPunks left :(");
        tokenDNA[current] = deterministicPseudoRandomDNA(current, msg.sender);
        // payable(_owner).transfer(msg.value);
        _safeMint((msg.sender), current);
        _idCounter.increment();

    }

    function _baseURI() internal pure override returns(string memory) {
        return "https://avataaars.io";
    }

    function _paramsURI(uint256 _dna) internal view returns(string memory) {
        string memory params;
        params = string(
                abi.encodePacked(
                    "accessoriesType=",
                    getAccessoriesType(_dna),
                    "&clotheColor=",
                    getClotheColor(_dna),
                    "&clotheType=",
                    getClotheType(_dna),
                    "&eyeType=",
                    getEyeType(_dna),
                    "&eyebrowType=",
                    getEyeBrowType(_dna),
                    "&facialHairColor=",
                    getFacialHairColor(_dna),
                    "&facialHairType=",
                    getFacialHairType(_dna),
                    "&hairColor=",
                    getHairColor(_dna),
                    "&hatColor=",
                    getHatColor(_dna),
                    "&graphicType=",
                    getGraphicType(_dna),
                    "&mouthType=",
                    getMouthType(_dna),
                    "&skinColor=",
                    getSkinColor(_dna)
                )
            );
        return string(abi.encodePacked(params,  "&topType=", getTopType(_dna)));
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "ERC721 Metadata: URI query for nonexistent token");

        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);

       bytes memory jsonURI = abi.encodePacked(
            '{ "name" : "Platzi Punks #', 
            Strings.toString(tokenId),
            '", "description" : "Randomized Avatars", "image" : ',
            image,
            '"background_color": "80ed99"',
             '"attributes": [{"Accessories Type": "" ,"Clothe Color": "","Clothe Type":"","Eye Type":"","Eye Brow Type":"","Facial Hair Color":"","Facial Hair Type":"","Hair Color":"","Hat Color":"","Graphic Type":"","Mouth Type":"","Skin Color":"","Top Type":"",}]',
            '"}'
        ); 

        return string (
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(jsonURI)
            )   
        );
     }

    function imageByDNA(uint256 _dna) public view returns (string memory) {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string (abi.encodePacked(baseURI, "?", paramsURI));
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
