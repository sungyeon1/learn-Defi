pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';//interface of ERC20

interface ContractB {
  function deposit(uint amount) external;
  function withdraw(uint amount) external;
}//inside contractA forward to another contract B(from smartcontract add to another smart contract add)

contract ContractA {
  IERC20 public token; 
  ContractB public contractB; //pointers

  constructor(address _token, address _contractB) {
    token = IERC20(_token);
    contractB = ContractB(_contractB); 
  }

  function deposit(uint amount) external { //call address(this) controled by private key in js
    token.transferFrom(msg.sender, address(this), amount);
    token.approve(address(contractB), amount);
    contractB.deposit(amount);
  }

  function withdraw(uint amount) external {
    contractB.withdraw(amount);
    token.transfer(msg.sender, amount);
  }
}
