// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./CampusCoin.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CampusRewards is Ownable {

    CampusCoin public token;

    mapping(address => bool) public organizers;

    // Prevent duplicate rewards
    mapping(bytes32 => bool) public rewarded;

    event RewardIssued(address student, uint amount, string eventId);

    constructor(address _token) {
        token = CampusCoin(_token);
    }

    function setOrganizer(address _org, bool _status) external onlyOwner {
        organizers[_org] = _status;
    }

    function rewardStudent(
        address student,
        uint amount,
        string memory eventId
    ) external {

        require(organizers[msg.sender], "Not organizer");

        bytes32 rewardHash = keccak256(
            abi.encodePacked(student, eventId)
        );

        require(!rewarded[rewardHash], "Already rewarded");

        rewarded[rewardHash] = true;

        token.mint(student, amount);

        emit RewardIssued(student, amount, eventId);
    }
}