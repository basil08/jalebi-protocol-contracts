// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract JalebiProtocol {
    address public tokenAddress;

    uint256 public MAX_MODULUS = 100000000000000000;
    uint256 public MIN_VALUE = 10;

    uint256 public tokenSupply = 10000000000000000000;

    // seed for random counter
    uint256 counter = 1;

    enum MATCH_STATE { NOT_CHALLENGED, NOT_ACCEPTED, ACCEPTED }

    mapping (address => mapping (address => MATCH_STATE)) matchTable; 
    // mapping (address => uint256) gameIds;
    // mapping (address => uint256) challengees;
    // mapping (uint256 => bool) acks;

    constructor(address _tokenAddress) {
        require(_tokenAddress != address(0), "Token address must be a valid address");

        tokenAddress = _tokenAddress;
    }

    function getTokenAddress() view public returns (address) {
        return tokenAddress;
    }

    function challenge(address challengeTarget) public {
        require(matchTable[msg.sender][challengeTarget] == MATCH_STATE.NOT_CHALLENGED, "You have already challenged this player!");

        matchTable[msg.sender][challengeTarget] = MATCH_STATE.NOT_ACCEPTED;
    } 

    function accept(address challengeFrom) public {
        require(matchTable[challengeFrom][msg.sender] == MATCH_STATE.NOT_ACCEPTED, "You either don't have any challenge or you have already accepted challenge from this player!");

        matchTable[challengeFrom][msg.sender] = MATCH_STATE.ACCEPTED;
    }

    /*
    * @amount uint256 - amount to be lost by battle initiator in this POC
    */
    function battle(address player, uint256 amount) public payable {
        require(IERC20(tokenAddress).balanceOf(msg.sender) >= MIN_VALUE,
                        "Please send minimum amount of Jalebis to start battle!");

        require(IERC20(tokenAddress).balanceOf(player) >= MIN_VALUE,
                        "Other player has insufficient Jalebis!");

        require(IERC20(tokenAddress).balanceOf(msg.sender) >= amount,
                        "Please send minimum amount of Jalebis to start battle!");

        require(IERC20(tokenAddress).balanceOf(msg.sender) >= amount,
                        "Please send minimum amount of Jalebis to start battle!");


        require(matchTable[msg.sender][player] == MATCH_STATE.ACCEPTED || 
                matchTable[player][msg.sender] == MATCH_STATE.ACCEPTED,
                "You don't have an accepted challenge from this player!");

        // insert custom gameplay logic
        // in this POC, the challenger ALWAYS loses
        IERC20(tokenAddress).transferFrom(msg.sender, player, amount);
    }
    

    // placeholder function for completeness, ideally swapping should happen on a DEX
    // via aggregator like 1inch
    function getJalebis(uint256 swapEth, uint256 _amount) public payable {
        require(swapEth > address(msg.sender).balance, "Insufficient funds");
        // require(_amount > tokenSupply, "Insufficient Jalebis");

        IERC20(tokenAddress).transfer(msg.sender, _amount);

    }

    function _random() internal returns (uint) {
        counter++;
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp,counter))) % MAX_MODULUS;
    }


}
