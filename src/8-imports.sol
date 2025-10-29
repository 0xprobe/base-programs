// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

library SillyStringUtils {
  struct Haiku {
    string line1;
    string line2;
    string line3;
  }

  function shruggie(string memory _input) internal pure returns (string memory) {
    return string.concat(_input, unicode" 🤷");
  }
}

contract ImportsExercise {
  using SillyStringUtils for string;
  
  SillyStringUtils.Haiku public haiku;
    
  function saveHaiku(
    string memory _line1,
    string memory _line2,
    string memory _line3
  ) public {
    haiku.line1 = _line1;
    haiku.line2 = _line2;
    haiku.line3 = _line3;
  }
    
  function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
    return haiku;
  }
    
  function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
      
    SillyStringUtils.Haiku memory modifiedHaiku = SillyStringUtils.Haiku({
      line1: haiku.line1,
      line2: haiku.line2,
      line3: SillyStringUtils.shruggie(haiku.line3)  // 라이브러리 함수 사용
    });
      
    return modifiedHaiku;
  }
}