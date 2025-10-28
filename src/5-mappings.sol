// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract FavoriteRecords {
    
  error NotApproved(string albumName);
  
  mapping(string => bool) public approvedRecords;
  mapping(address => mapping(string => bool)) public userFavorites;
  
  string[] private approvedAlbumsList;
    
  constructor() {
    
    string[9] memory albums = [
      "Thriller",
      "Back in Black", 
      "The Bodyguard",
      "The Dark Side of the Moon",
      "Their Greatest Hits (1971-1975)",
      "Hotel California",
      "Come On Over",
      "Rumours",
      "Saturday Night Fever"
    ];
    
    for (uint i = 0; i < albums.length; i++) {
      approvedRecords[albums[i]] = true;
      approvedAlbumsList.push(albums[i]);
    }
  }
    
  function getApprovedRecords() public view returns (string[] memory) {
    return approvedAlbumsList;
  }
    
  function addRecord(string memory _albumName) public {

    if (!approvedRecords[_albumName]) {
      revert NotApproved(_albumName);
    }
    
    userFavorites[msg.sender][_albumName] = true;
  }
    
  function getUserFavorites(address _userAddress) public view returns (string[] memory) {

    uint count = 0;
    for (uint i = 0; i < approvedAlbumsList.length; i++) {
      if (userFavorites[_userAddress][approvedAlbumsList[i]]) {
        count++;
      }
    }
    
    string[] memory userFavoritesList = new string[](count);
    uint index = 0;
    
    for (uint i = 0; i < approvedAlbumsList.length; i++) {
      if (userFavorites[_userAddress][approvedAlbumsList[i]]) {
        userFavoritesList[index] = approvedAlbumsList[i];
        index++;
      }
    }
    
    return userFavoritesList;
  }
    
  function resetUserFavorites() public {
    for (uint i = 0; i < approvedAlbumsList.length; i++) {
      userFavorites[msg.sender][approvedAlbumsList[i]] = false;
    }
  }

}