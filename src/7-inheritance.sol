// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

/*
Deploy your Salesperson and EngineeringManager contracts.
You don’t need to separately deploy the other contracts.
Use the following values:
​
Salesperson
Hourly rate is 20 dollars an hour
Id number is 55555
Manager Id number is 12345
​
Manager
Annual salary is 200,000
Id number is 54321
Manager Id is 11111

deploy InheritanceSubmission using the addresses of your Salesperson and EngineeringManager contracts.
*/


abstract contract Employee {
  uint public idNumber;
  uint public managerId;
  
  constructor(uint _idNumber, uint _managerId) {
    idNumber = _idNumber;
    managerId = _managerId;
  }
    
  function getAnnualCost() public view virtual returns (uint);
}

contract Salaried is Employee {
  uint public annualSalary;
  
  constructor(uint _idNumber, uint _managerId, uint _annualSalary) 
    Employee(_idNumber, _managerId) {
    annualSalary = _annualSalary;
  }
  
  function getAnnualCost() public view override returns (uint) {
    return annualSalary;
  }
}

contract Hourly is Employee {
  uint public hourlyRate;
  
  constructor(uint _idNumber, uint _managerId, uint _hourlyRate) 
      Employee(_idNumber, _managerId) {
      hourlyRate = _hourlyRate;
  }
    
  function getAnnualCost() public view override returns (uint) {
      return hourlyRate * 2080;
  }
}

contract Manager {
  uint[] public employeeIds;
  
  function addReport(uint _employeeId) public {
    employeeIds.push(_employeeId);
  }
  
  function resetReports() public {
    delete employeeIds;
  }
}

contract Salesperson is Hourly {
  constructor(uint _idNumber, uint _managerId, uint _hourlyRate) 
    Hourly(_idNumber, _managerId, _hourlyRate) {
  }
}

contract EngineeringManager is Salaried, Manager {
  constructor(uint _idNumber, uint _managerId, uint _annualSalary) 
    Salaried(_idNumber, _managerId, _annualSalary) {
  }
}

contract InheritanceSubmission {
  address public salesPerson;
  address public engineeringManager;

  constructor(address _salesPerson, address _engineeringManager) {
    salesPerson = _salesPerson;
    engineeringManager = _engineeringManager;
  }
  
}