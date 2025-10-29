// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract UnburnableToken {
    
  error TokensClaimed();
  error AllTokensClaimed();
  error UnsafeTransfer(address recipient);
    
  mapping(address => uint256) public balances;
  uint256 public totalSupply;
  uint256 public totalClaimed;
    
  mapping(address => bool) private hasClaimed;
    
  uint256 private constant CLAIM_AMOUNT = 1000;
    
  constructor() {
    totalSupply = 100_000_000;
  }
    
  function claim() public {

    if (totalClaimed >= totalSupply) {
      revert AllTokensClaimed();
    }
    
    if (hasClaimed[msg.sender]) {
      revert TokensClaimed();
    }
    
    uint256 claimAmount = CLAIM_AMOUNT;
    if (totalClaimed + CLAIM_AMOUNT > totalSupply) {
      claimAmount = totalSupply - totalClaimed;
    }
    
    hasClaimed[msg.sender] = true;
    balances[msg.sender] += claimAmount;
    totalClaimed += claimAmount;

  }
    
  function safeTransfer(address _to, uint256 _amount) public {

    if (_to == address(0)) {
      revert UnsafeTransfer(_to);
    }
    
    if (_to.balance == 0) {
      revert UnsafeTransfer(_to);
    }
    
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    
    balances[msg.sender] -= _amount;
    balances[_to] += _amount;

  }
    
  function balanceOf(address _address) public view returns (uint256) {
    return balances[_address];
  }
    
  function hasAddressClaimed(address _address) public view returns (bool) {
    return hasClaimed[_address];
  }
    
  function remainingTokens() public view returns (uint256) {
    return totalSupply - totalClaimed;
  }
    
  function remainingClaims() public view returns (uint256) {
    return remainingTokens() / CLAIM_AMOUNT;
  }

}