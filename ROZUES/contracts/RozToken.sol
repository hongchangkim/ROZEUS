pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
                                        
contract RozToken is StandardToken, Pausable {

  string public name = "ROZEUS";
  string public symbol = "ROZ";
  uint8 public decimals = 8 ;
  uint256 _totalSupply = 10000000000;  

  bool public minted = false;

  struct BusinessPartner {
    uint256 account_total;
    uint256 set_date;
    uint8 set_period;
    uint8 set_num;    
    uint256 account_withdraw;
  }

  mapping (address => BusinessPartner ) m_bp;
  BusinessPartner bp;  
  
  event LockupStep(address indexed target, string log, uint256 en, uint256 _t1, uint256 _t2 );
  event Mint(address indexed to, uint256 amount);
  event e_mintable();
  event e_unmintable();
  
  modifier whenNotTeam() {
    require(m_bp[msg.sender].account_total == 0);
    _;
  }

  modifier whenMinted() {    
    require(minted);
    _;
  }
       
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
  
  function setBusinessPartner(address _addr, uint256 _acc_tot, uint256 _date, uint8 _period, uint8 _num, uint256 _acc_with ) public onlyOwner returns (bool) {    
    require(m_bp[_addr].account_total == 0 ) ;
    bp = BusinessPartner(_acc_tot, _date , _period, _num, _acc_with);    
    m_bp[_addr] = bp;
    return true;    
  }  
  
  function getBusinessPartner(address _addr ) view public returns (uint256,uint256,uint8,uint8,uint256) {    
    return (m_bp[_addr].account_total,m_bp[_addr].set_date, m_bp[_addr].set_period, m_bp[_addr].set_num , m_bp[_addr].account_withdraw);
  }

  function transfer( address to, uint256 value ) public whenNotPaused returns (bool)  {
    uint256 current_step = 0;
    if(m_bp[msg.sender].account_total > 0) {
      uint256 setday = m_bp[msg.sender].set_period * 30 days;
      uint256 elapsed_time = now-m_bp[msg.sender].set_date;      
      current_step = elapsed_time/setday;

      uint256 account_total_mod = m_bp[msg.sender].account_total % m_bp[msg.sender].set_num;
      uint256 account_total_sub = m_bp[msg.sender].account_total;
      if(account_total_mod>0) account_total_sub = m_bp[msg.sender].account_total - account_total_mod;
      
      uint256 enable_balance = (account_total_sub.div(m_bp[msg.sender].set_num)).mul(current_step) + account_total_mod;
      emit LockupStep(msg.sender,": enable_balance!!!." , enable_balance , current_step , account_total_sub );  
    }
    require(m_bp[msg.sender].account_total == 0 || (enable_balance >= value && enable_balance.sub(m_bp[msg.sender].account_withdraw) >= value) ) ;    
     
    if(super.transfer(to, value)) {
      if(m_bp[msg.sender].account_total > 0) m_bp[msg.sender].account_withdraw += value ;
      return true;
    } else {
      return false;
    }
  }

  function transferFrom(address from, address to, uint256 value ) public whenNotPaused returns (bool) {
    return super.transferFrom(from, to, value);
  }

  function approve(address spender, uint256 value ) public whenNotTeam whenNotPaused returns (bool) {
    return super.approve(spender, value);
  }
   
  function increaseApproval( address _spender, uint256 _addedValue ) public whenNotTeam whenNotPaused returns (bool)  {    
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval( address _spender, uint256 _subtractedValue ) public whenNotTeam whenNotPaused returns (bool) {    
    return super.decreaseApproval( _spender, _subtractedValue );
  }
  
  function mintable() public onlyOwner {
    minted = true;
    emit e_mintable(); 
  }

  function unmintable() public onlyOwner {
    minted = false;
    emit e_unmintable();
  }
  
  function mint( address _to, uint256 _amount ) public whenNotPaused whenMinted onlyOwner returns (bool) {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }
}