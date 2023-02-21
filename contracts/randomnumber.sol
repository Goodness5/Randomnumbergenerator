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
        uint256 no_of_request;
    }

    mapping (address => requeststatus) Request;

    // Counters.Counter private nonce;
    uint256 nonce;


    constructor(uint64 subscriptionId) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        owner = msg.sender;
        s_subscriptionId = 10097;
        s_keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
        uint32 callbackGasLimit = 40000;
        uint16 requestConfirmations = 3;
        uint32 numWords =  1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event RequestFulfilled(address indexed);

    // This function is copied from VRFConsumerBase
     function requestRandomWords()external onlyOwner returns (uint256 requestId){
        requestId = 
        COORDINATOR.requestRandomWords(s_keyHash, s_subscriptionId, requestConfirmations, callbackGasLimit, numWords );
        
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }
}
