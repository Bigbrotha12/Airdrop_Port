// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/// @title AirdropClaim
/// @notice Allows user to claim ERC20 token if part of Merkle Tree within
/// owner-specified deadline.
contract AirdropSample {

    //------------------ STATE VARIABLES ---------------------------------------

    mapping(address => bytes32) public merkleRoot; // Root of tree containing valid address
    address public owner; // Contract administrator
    ERC20 public demoToken;
    uint256 public limit;
    mapping(address => mapping(address => bool)) public hasClaimed; // Records if user has already claimed

    //----------------------- EVENTS -------------------------------------------

    event Claimed(address indexed to, uint256 amount);

    //--------------------  CONSTRUCTOR ----------------------------------------

    /// @notice Creates a new AirdropDemo contract.
    /// @param _limit the maximum amount of token to airdrop per-transaction.
    /// @param _token of the DemoToken contract to be used for minting. 
    constructor(uint256 _limit, ERC20 _token) {
        limit = _limit;
        demoToken = _token;
        owner = msg.sender;
    }

    //-------------------- MUTATIVE FUNCTIONS ----------------------------------

    /// @notice Creates a new Airdrop merkle root. Security checks are disabled for Demo.
    /// @param _root Merkle root of airdrop data.
    function createAirdrop(bytes32 _root) external {
        merkleRoot[msg.sender] = _root;
    }

    function setToken(ERC20 _token) external {
        require(msg.sender == owner, "AirdropDemo: Unauthorized.");

        demoToken = _token;
    }

    /// @notice Allows user to claim token if address is part of merkle tree
    /// @dev A valid claim should revert if contract has insufficient funds
    /// @param _to address of claimee
    /// @param _amount of tokens owed to claimee
    /// @param _proof merkle proof to prove address and amount are in tree
    function claim(
        address _creator,
        address _to,
        uint256 _amount,
        bytes32[] calldata _proof
    ) external {
        // Check if airdrop still active and address hasn't already claimed tokens
        require(!hasClaimed[_creator][_to], "AirdropDemo: Already claimed.");
        require(_amount <= limit, "AirdropDemo: Claim amount greater than limit.");

        // Verify merkle proof, or revert if not in tree
        bytes32 leaf = keccak256(abi.encodePacked(_to, _amount));
        bool isValidLeaf = MerkleProof.verify(
            _proof,
            merkleRoot[_creator],
            leaf
        );
        if (!isValidLeaf) revert("AirdropDemo: Invalid data.");

        // Send tokens to claimee
        hasClaimed[_creator][_to] = true;
        demoToken.transfer(_to, _amount);
        emit Claimed(_to, _amount);
    }

    /// @notice Prevent accidental ETH deposits
    receive() external payable {
        revert();
    }
}
