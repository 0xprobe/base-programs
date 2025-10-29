// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";


contract AddressBook is Ownable {
    
  error ContactNotFound(uint256 id);
  
  struct Contact {
    uint256 id;
    string firstName;
    string lastName;
    uint256[] phoneNumbers;
  }
    
  mapping(uint256 => Contact) private contacts;
  uint256[] private contactIds;
  uint256 private nextId = 1;
    
  constructor(address _initialOwner) Ownable(_initialOwner) {}
    
  function addContact(
    string memory _firstName,
    string memory _lastName,
    uint256[] memory _phoneNumbers
  ) public onlyOwner returns (uint256) {
    uint256 contactId = nextId;
    nextId++;
      
    contacts[contactId] = Contact({
      id: contactId,
      firstName: _firstName,
      lastName: _lastName,
      phoneNumbers: _phoneNumbers
    });
      
    contactIds.push(contactId);
      
    return contactId;
  }
    
  function deleteContact(uint256 _id) public onlyOwner {

    if (contacts[_id].id == 0) {
      revert ContactNotFound(_id);
    }
      
    delete contacts[_id];
      
    for (uint256 i = 0; i < contactIds.length; i++) {
      if (contactIds[i] == _id) {
        contactIds[i] = contactIds[contactIds.length - 1];
        contactIds.pop();
        break;
      }
    }
  }
    
  function getContact(uint256 _id) public view returns (Contact memory) {
    if (contacts[_id].id == 0) {
      revert ContactNotFound(_id);
    }
    return contacts[_id];
  }
    
  function getAllContacts() public view returns (Contact[] memory) {
    Contact[] memory allContacts = new Contact[](contactIds.length);
      
    for (uint256 i = 0; i < contactIds.length; i++) {
      allContacts[i] = contacts[contactIds[i]];
    }
      
    return allContacts;
  }
    
  function getContactCount() public view returns (uint256) {
    return contactIds.length;
  }
}

contract AddressBookFactory {
    
  address[] public deployedAddressBooks;
    
  function deploy() public returns (address) {

    AddressBook newAddressBook = new AddressBook(msg.sender);      
    address newAddressBookAddress = address(newAddressBook);
    deployedAddressBooks.push(newAddressBookAddress);
      
    return newAddressBookAddress;
  }
    
  function getDeployedCount() public view returns (uint256) {
    return deployedAddressBooks.length;
  }
    
  function getDeployedAddressBooks() public view returns (address[] memory) {
    return deployedAddressBooks;
  }
}