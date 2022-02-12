const { expect } = require("chai");
const { ethers } = require("hardhat");
const whitelist = require("../whitelist.json");
const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

let merkleFactory;
let merkle;
let mappingFactory;
let map;
let whitelistedMinter = whitelist[0];
let minterLeaf;
let proofs;

describe("Test Merkle Tree whitelist NFT", () => {
  before(async () => {
    merkleFactory = await ethers.getContractFactory("MerkleNFT");
    merkle = await merkleFactory.deploy();
    await merkle.deployed();

    //merkle tree genreation
    minterLeaf = keccak256(whitelistedMinter);
    const leafNodes = whitelist.map((address) => keccak256(address));
    const merkleTree = new MerkleTree(leafNodes, keccak256, {
      sortPairs: true,
    });
    proofs = merkleTree.getHexProof(minterLeaf);
  });

  it("shoud be able to mint with proofs", async () => {
    await merkle.claimWhitelist(proofs, 1);
  });
});

describe("Test Mapping or Array whitelist NFT", async () => {
  before(async () => {
    mappingFactory = await ethers.getContractFactory("MappingNFT");
    map = await mappingFactory.deploy();
    await map.deployed();
  });

  it("shoud be able to add whitelist in to the smart contract", async () => {
    await map.addWhitelist(whitelist);
  });

  it("should be able to mint with mapping whitelist", async () => {
    await map.claimWhitelist(2);
  });
});
