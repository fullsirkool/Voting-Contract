// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Voting {
    struct Voter {
        bool canVote;
        bool voted;
        uint vote;
    }

    struct Candidate {
        bytes32 name;
        uint voteCount;
    }

    address public creator;

    mapping(address => Voter) public voters;

    Candidate[] public candidates;

    constructor(bytes32[] memory _candidateName) {
        creator = msg.sender;
        for (uint i = 0; i < _candidateName.length; i++) {
            candidates.push(Candidate({name: _candidateName[i], voteCount: 0}));
        }
    }

    function grantVotingPermission(address voter) external {
        require(msg.sender == creator);
        require(!voters[voter].voted);
        voters[voter].canVote = true;
    }

    function vote(uint candidateNumber) external{
        Voter storage sender = voters[msg.sender];
        require(sender.canVote == true);
        require(!sender.voted);
        sender.voted = true;
        sender.vote = candidateNumber;
        candidates[candidateNumber].voteCount++;
    }

    function getWinner() public view returns (uint winner_) {
        uint winnerVoteCount = 0;
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winnerVoteCount) {
                winnerVoteCount = candidates[i].voteCount;
                winner_ = i;
            }
        }
    }

    function getWinnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = candidates[getWinner()].name;
    }
}
