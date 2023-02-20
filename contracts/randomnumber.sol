// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract VRFD20 is VRFConsumerBaseV2 {
    
    uint64 s_subscriptionId;
    address owner;
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    VRFCoordinatorV2Interface COORDINATOR;


    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        owner = msg.sender;
        s_subscriptionId = ;
        bytes32 s_keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
        uint32 callbackGasLimit = 40000;
        uint16 requestConfirmations = 3;
        uint32 numWords =  1;
    }

    //...
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


     function getSubscription(uint64 subId) external view returns 
            (uint96 balance, uint64 reqCount, address owner, address[] memory consumers);


    }