//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MappingNFT is ERC721Enumerable, Ownable {
    
    uint256 private _whiteListMaxMint = 6;
    mapping(address => bool) private _whiteList;
    mapping(address => uint256) private _whiteListClaimed;

    constructor() ERC721("Mapping NFT", "MPNFT") {}

    function addWhitelist(address[] calldata _addresses) external onlyOwner { 
        for (uint256 i = 0; i < _addresses.length; i++) {
          require(_addresses[i] != address(0), "Can't add the null address"); 
          _whiteList[_addresses[i]] = true; 
        } 
    }

    function claimWhitelist(uint256 tokenId) public payable {
        // @dev checking directly from the arrays to reduce gas
        require(_whiteList[msg.sender],                                     "This address is not in the whitelist");
        require(_whiteListClaimed[msg.sender] <= _whiteListMaxMint,   "Claim exceeds max allowed per wallet");  
        _whiteListClaimed[msg.sender] += 1; 
        _safeMint( msg.sender, tokenId ); 
    } 
}