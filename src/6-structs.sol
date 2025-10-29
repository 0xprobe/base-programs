// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract GarageManager {
    
	error BadCarIndex(uint256 index);
    
	struct Car {
		string make;
		string model;
		string color;
		uint256 numberOfDoors;
	}
    
	mapping(address => Car[]) public garage;
    
	function addCar(
		string memory _make,
		string memory _model,
		string memory _color,
		uint256 _numberOfDoors
	) public {
		Car memory newCar = Car({
			make: _make,
			model: _model,
			color: _color,
			numberOfDoors: _numberOfDoors
		});
		
		garage[msg.sender].push(newCar);
	}
    
	function getMyCars() public view returns (Car[] memory) {
			return garage[msg.sender];
	}
    
	function getUserCars(address _userAddress) public view returns (Car[] memory) {
		return garage[_userAddress];
	}
    
	function updateCar(
		uint256 _index,
		string memory _make,
		string memory _model,
		string memory _color,
		uint256 _numberOfDoors
	) public {
		
		if (_index >= garage[msg.sender].length) {
				revert BadCarIndex(_index);
		}

		garage[msg.sender][_index] = Car({
			make: _make,
			model: _model,
			color: _color,
			numberOfDoors: _numberOfDoors
		});
	}
	
	function resetMyGarage() public {
		delete garage[msg.sender];
	}

}