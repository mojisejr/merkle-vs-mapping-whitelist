//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleNFT is ERC721Enumerable {

    uint8 maxWhitelistMint = 2; 
    bytes32 whitelistRootHash = 0xd28e8860b2ebd608c02124274c0d9988d526a48f7f6ac34b51edd7e187e04610;
    mapping(address => uint256) claimedWhitelist;

    constructor() ERC721("NFTMerkle", "MKNFT") {}

    function claimWhitelist(bytes32[] memory proofs, uint256 tokenId) public {
        require(proofs.length > 0, 'no proof included');
        bytes32 leafNode = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(proofs, whitelistRootHash, leafNode), 'you are not in the whitelist');
        require(claimedWhitelist[msg.sender] < maxWhitelistMint, 'your whitelist is completed');
        _safeMint(msg.sender, tokenId);
        claimedWhitelist[msg.sender] += 1;
    }
}