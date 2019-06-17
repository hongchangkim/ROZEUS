pragma solidity ^0.5.9;

import "./StandardToken.sol";
import "./Pausable.sol";
                                        
contract RozToken is StandardToken, Pausable {

  string public name = "ROZEUS";
  string public symbol = "ROZ";
  uint8 public decimals = 8 ;
  uint256 _totalSupply = 10000000000;  
       
  constructor() public {
    totalSupply_ = _totalSupply * 10**uint(decimals);
    
    uint256 sale_fund = 2500000000 * 10**uint(decimals);
    uint256 team_fund = 500000000 * 10**uint(decimals);
    uint256 platform_fund = 4000000000 * 10**uint(decimals);
    uint256 ecosystem_fund = 2000000000 * 10**uint(decimals);
    uint256 bounty_fund = 1000000000 * 10**uint(decimals);

    balances[0x3B71AB34A2d5e28B5E3E2B6248D4D45D12f664CC] = sale_fund;
    balances[0x297f0a58e006A121C7af4F7B4Dd8a98383DC402C] = team_fund;
    balances[0x3dd7Ad80806F59dD62dfFd51c4D078c4AdbB048f] = platform_fund;
    balances[0x93f77A45933A22FA4bc43A9ceE3D707d2E537E2a] = ecosystem_fund;
    balances[0x16C5EB21D3441eF11815CFbF2B34861264F87924] = bounty_fund;
    
    emit Transfer(address(0), 0x3B71AB34A2d5e28B5E3E2B6248D4D45D12f664CC, sale_fund);
    emit Transfer(address(0), 0x297f0a58e006A121C7af4F7B4Dd8a98383DC402C, team_fund);
    emit Transfer(address(0), 0x3dd7Ad80806F59dD62dfFd51c4D078c4AdbB048f, platform_fund);
    emit Transfer(address(0), 0x93f77A45933A22FA4bc43A9ceE3D707d2E537E2a, ecosystem_fund);
    emit Transfer(address(0), 0x16C5EB21D3441eF11815CFbF2B34861264F87924, bounty_fund);
  }  

  function transfer( address to, uint256 value ) public whenNotPaused returns (bool)  {   
    return super.transfer(to, value);      
  }

  function transferFrom(address from, address to, uint256 value ) public whenNotPaused returns (bool) {
    return super.transferFrom(from, to, value);
  }

  function approve(address spender, uint256 value ) public whenNotPaused returns (bool) {
    return super.approve(spender, value);
  }
   
  function increaseApproval( address _spender, uint256 _addedValue ) public whenNotPaused returns (bool)  {    
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval( address _spender, uint256 _subtractedValue ) public whenNotPaused returns (bool) {    
    return super.decreaseApproval( _spender, _subtractedValue );
  }
}