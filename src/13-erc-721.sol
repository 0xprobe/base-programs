// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    
  error HaikuNotUnique();
  error NotYourHaiku(uint256 id);
  error NoHaikusShared();
  
  struct Haiku {
    address author;
    string line1;
    string line2;
    string line3;
  }
    
  Haiku[] public haikus;
  mapping(address => uint256[]) public sharedHaikus;
  uint256 public counter = 1;
    
  mapping(bytes32 => bool) private usedLines;
    
  constructor() ERC721("HaikuNFT", "HAIKU") {
    haikus.push(Haiku({
      author: address(0),
      line1: "",
      line2: "",
      line3: ""
    }));
  }
    
  function mintHaiku(
    string memory _line1,
    string memory _line2,
    string memory _line3
  ) external {
    bytes32 line1Hash = keccak256(abi.encodePacked(_line1));
    bytes32 line2Hash = keccak256(abi.encodePacked(_line2));
    bytes32 line3Hash = keccak256(abi.encodePacked(_line3));
      
    if (usedLines[line1Hash] || usedLines[line2Hash] || usedLines[line3Hash]) {
      revert HaikuNotUnique();
    }
      
    usedLines[line1Hash] = true;
    usedLines[line2Hash] = true;
    usedLines[line3Hash] = true;
      
    Haiku memory newHaiku = Haiku({
      author: msg.sender,
      line1: _line1,
      line2: _line2,
      line3: _line3
    });
      
    haikus.push(newHaiku);
      
    _mint(msg.sender, counter);
      
    counter++;
  }
    
  function shareHaiku(address _to, uint256 _haikuId) public {
    if (ownerOf(_haikuId) != msg.sender) {
      revert NotYourHaiku(_haikuId);
    }
      
    sharedHaikus[_to].push(_haikuId);
  }
    
  function getMySharedHaikus() public view returns (Haiku[] memory) {
    uint256[] memory mySharedIds = sharedHaikus[msg.sender];
    
    if (mySharedIds.length == 0) {
      revert NoHaikusShared();
    }
    
    Haiku[] memory sharedHaikuArray = new Haiku[](mySharedIds.length);
    
    for (uint256 i = 0; i < mySharedIds.length; i++) {
      uint256 haikuId = mySharedIds[i];
      sharedHaikuArray[i] = haikus[haikuId];
    }

    return sharedHaikuArray;
  }
    
  function getHaiku(uint256 _haikuId) public view returns (Haiku memory) {
    require(_haikuId > 0 && _haikuId < haikus.length, "Haiku does not exist");
    return haikus[_haikuId];
  }
    
  function getTotalHaikus() public view returns (uint256) {
    return counter - 1; // counter는 다음 ID이므로 -1
  }
    
  function getSharedHaikuIds(address _address) public view returns (uint256[] memory) {
    return sharedHaikus[_address];
  }
    
  function isLineUsed(string memory _line) public view returns (bool) {
    bytes32 lineHash = keccak256(abi.encodePacked(_line));
    return usedLines[lineHash];
  }

}