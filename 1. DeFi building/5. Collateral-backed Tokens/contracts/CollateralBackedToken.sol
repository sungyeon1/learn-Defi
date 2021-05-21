pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract CollateralBackedToken is ERC20 {
  IERC20 public collateral;//collateral smart contract
  uint price = 1;
  constructor(address _collateral) ERC20('Collateral Backed Token', 'CBT') {
    collateral = IERC20(_collateral);
  }

  function deposit(uint collateralAmount) external {
    collateral.transferFrom(msg.sender, address(this), collateralAmount);//to our smart contract
    _mint(msg.sender, collateralAmount * price);//cf. wrapped ether 1 ether = 1 wrapped ether token
  }

  function withdraw(uint tokenAmount) external {
    require(balanceOf(msg.sender) >= tokenAmount, 'balance too low');
    _burn(msg.sender, tokenAmount);
    collateral.transfer(tokenAmount / price);//?where is to the sender?
  }
}
