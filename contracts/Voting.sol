// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.9;

contract Voting {
    mapping(address => bool) public voters;
    struct Choice {
        uint id;
        string name;
        uint votes;
    }
    struct Ballot {
        uint id;
        string name;
        Choice[] choices;
        uint end;
    }
    mapping(uint => Ballot) public ballots;

    Ballot[] allBallot;
  
    uint nextBallotId;
    address public admin;

    mapping(address => mapping(uint => bool)) votes;
  
    constructor() {
        admin = msg.sender;
    }
  
    function addVoters(address[] calldata _voters) external onlyAdmin() {
        for(uint i = 0; i < _voters.length; i++) {
            voters[_voters[i]] = true;
        }
    }

    function createBallot(
        string memory name,
        string[] memory _choices
    ) external onlyAdmin() {
        ballots[nextBallotId].id = nextBallotId;
        ballots[nextBallotId].name = name;
        // Since the duration is removed, the ballot end time is not set
        // The end time will be determined by the contract's logic or manual intervention
        for(uint i = 0; i < _choices.length ; i++) {
            ballots[nextBallotId].choices.push(Choice(i, _choices[i], 0));
        }
        nextBallotId++;
    }

    function vote(uint ballotId, uint choiceId) external {
        require(voters[msg.sender] == true, 'only voters can vote');
        require(votes[msg.sender][ballotId] == false, 'voter can only vote once for a ballot');
        // Check if the ballot has ended or not is removed
        votes[msg.sender][ballotId] = true;
        ballots[ballotId].choices[choiceId].votes++;
    }

    function results(uint ballotId) 
        view 
        external 
        returns(Choice[] memory) {
        // The check for ballot end time is removed from the results function
        return ballots[ballotId].choices;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, 'only admin');
        _;
    }
}
