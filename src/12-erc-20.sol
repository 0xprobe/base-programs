// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {

  using EnumerableSet for EnumerableSet.AddressSet;
  
  uint256 public constant maxSupply = 1_000_000;
  
  error TokensClaimed();
  error AllTokensClaimed();
  error NoTokensHeld();
  error QuorumTooHigh(uint256 quorum);
  error AlreadyVoted();
  error VotingClosed();
    
  enum Vote {
    AGAINST,
    FOR,
    ABSTAIN
  }
    
  struct Issue {
    EnumerableSet.AddressSet voters;
    string issueDesc;
    uint256 votesFor;
    uint256 votesAgainst;
    uint256 votesAbstain;
    uint256 totalVotes;
    uint256 quorum;
    bool passed;
    bool closed;
  }
    
  struct ReturnableIssue {
    address[] voters;
    string issueDesc;
    uint256 votesFor;
    uint256 votesAgainst;
    uint256 votesAbstain;
    uint256 totalVotes;
    uint256 quorum;
    bool passed;
    bool closed;
  }
    
  Issue[] issues;
  mapping(address => bool) private hasClaimed;
    
  constructor() ERC20("WeightedVoting", "WV") {
    issues.push();
    issues[0].closed = true;
  }
    
  function claim() public {
    if (totalSupply() >= maxSupply) {
      revert AllTokensClaimed();
    }
    
    if (hasClaimed[msg.sender]) {
      revert TokensClaimed();
    }
    
    uint256 claimAmount = 100;
    if (totalSupply() + claimAmount > maxSupply) {
      claimAmount = maxSupply - totalSupply();
    }
    
    hasClaimed[msg.sender] = true;
    _mint(msg.sender, claimAmount);
  }
    
  function createIssue(string calldata _issueDesc, uint256 _quorum) 
    external 
    returns (uint256) 
  {
    if (balanceOf(msg.sender) == 0) {
      revert NoTokensHeld();
    }
      
    if (_quorum > totalSupply()) {
      revert QuorumTooHigh(_quorum);
    }
      
    issues.push();
    uint256 issueId = issues.length - 1;
    
    issues[issueId].issueDesc = _issueDesc;
    issues[issueId].quorum = _quorum;
    issues[issueId].passed = false;
    issues[issueId].closed = false;
    
    return issueId;
  }
    
  function getIssue(uint256 _id) external view returns (ReturnableIssue memory) {
    require(_id < issues.length, "Issue does not exist");
      
    Issue storage issue = issues[_id];
      
    uint256 voterCount = issue.voters.length();
    address[] memory voterArray = new address[](voterCount);
    for (uint256 i = 0; i < voterCount; i++) {
      voterArray[i] = issue.voters.at(i);
    }
      
    return ReturnableIssue({
      voters: voterArray,
      issueDesc: issue.issueDesc,
      votesFor: issue.votesFor,
      votesAgainst: issue.votesAgainst,
      votesAbstain: issue.votesAbstain,
      totalVotes: issue.totalVotes,
      quorum: issue.quorum,
      passed: issue.passed,
      closed: issue.closed
    });
  }
    
  function vote(uint256 _issueId, Vote _vote) public {
    require(_issueId < issues.length, "Issue does not exist");
    require(balanceOf(msg.sender) > 0, "No tokens held");
      
    Issue storage issue = issues[_issueId];
      
    
    if (issue.closed) {
      revert VotingClosed();
    }
      
    if (issue.voters.contains(msg.sender)) {
      revert AlreadyVoted();
    }
      
    issue.voters.add(msg.sender);
      
    uint256 voterTokens = balanceOf(msg.sender);
      
    if (_vote == Vote.FOR) {
      issue.votesFor += voterTokens;
    } else if (_vote == Vote.AGAINST) {
      issue.votesAgainst += voterTokens;
    } else {
      issue.votesAbstain += voterTokens;
    }
      
    issue.totalVotes += voterTokens;
      
    if (issue.totalVotes >= issue.quorum) {
      issue.closed = true;
        
      if (issue.votesFor > issue.votesAgainst) {
        issue.passed = true;
      }
    }
  }
    
  function hasAddressClaimed(address _address) external view returns (bool) {
    return hasClaimed[_address];
  }
    
  function getIssueCount() external view returns (uint256) {
    return issues.length;
  }
  
}