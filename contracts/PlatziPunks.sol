// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PlatziPunks is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    address _owner;

    constructor(uint256 _maxSupply) ERC721("PlatziPunks", "PLZPNKS"){
        maxSupply = _maxSupply;
        _owner = msg.sender;
    }

    function mint() public payable {
        require (msg.value >= 0.1 ether, "Insuficient funds");
        uint256 current =_idCounter.current();
        require (current < maxSupply, "No PlatziPunks left :(");
        payable(_owner).transfer(msg.value);
        _idCounter.increment();
        _safeMint((msg.sender), current);
    }

      function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
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