// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";



contract randomnumber {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    uint64 s_subscriptionId;
    address owner;
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D; 
    VRFCoordinatorV2Interface COORDINATOR;
    bytes32 s_keyHash;
    bytes32 internal s_requestId;
    uint256 internal s_fee;
    uint256 internal randomNumber;
    address linkcontract = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;

    struct requeststatus {
        bool requestfulfilled;
        uint256[] randomvalue;
    }

    mapping (uint256 => requeststatus) Request;

    // Counters.Counter private nonce;
    uint256 nonce;
    uint16 requestConfirmations;
    uint32 numvalue;
    uint32 callbackGasLimit;

    uint256[] public requestID;

    


    constructor() {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        owner = msg.sender;
        s_subscriptionId = 10097;
        s_keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
        callbackGasLimit = 40000;
        requestConfirmations = 3;
        numvalue =  1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event RequestFulfilled(uint256 requestId, uint256[] randomWords);
    event RequestSent(uint256 requestId, uint256 numWords);

   
     function requestRandomWords()external onlyOwner returns (uint256 requestId){
        requestId = 
        COORDINATOR.requestRandomWords(s_keyHash, s_subscriptionId, requestConfirmations, callbackGasLimit, numvalue );
        
        Request[requestId] = requeststatus({
            randomvalue: new uint256[](0),
            requestfulfilled: false
        });
        requestID.push(requestId);
        emit RequestSent(requestId, numvalue);
        return requestId;
    }

    function fulfillRandomWords(uint256 _requestId,uint256[] memory _randomWords) internal {
        // require(Request[_requestId].exists, "request not found");
        Request[_requestId].requestfulfilled = true;
        Request[_requestId].randomvalue = _randomWords;

        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {

        // require(Request[_requestId].requestfulfilled, "request not found");

        requeststatus memory request = Request[_requestId];
        return (request.requestfulfilled, request.randomvalue);
    }
}
