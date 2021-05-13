// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
//importation
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Birthday {
    //librairies
    //using Address for address payable;
    
    //status des variables
    address private _owner;
    mapping(address => uint256) private _balances;
    
    // evenements
    event Transfered(address indexed sender, address indexed recipient, uint256 amount);
    
    //constructeur
    constructor(address owner_) {
        _owner = owner_;
    }
    
    //modifieurs
    modifier onlyOwner() {
        require(msg.sender == _owner, "Birthday: Only owner can call this function");
        _;
    }
    
    //fonctions
    function offer() public payable {
        _balances[msg.sender] += msg.value;
        _balances[msg.sender] -= msg.value;
        _balances[_owner] += msg.value;
        emit Transfered(msg.sender, _owner, msg.value);
    }
    
    function getPresent() public onlyOwner {
        require(_balances[_owner] > 0, "SmartWallet: can not withdraw 0 ether");
        uint256 amount = _balances[_owner];
        _balances[_owner] = 0;
        payable(msg.sender).transfer(amount);
    }
    
    function owner() public view returns(address) {
        return _owner;
    }
    
    /*
    function balance(address account) public view returns(uint256) {
        return _balances[account];
    }
    */
    
    function balanceOwner() public view returns(uint256) {
        return _balances[_owner];
    }
    
    function total() public view returns (uint256) {
        return address(this).balance;
    }
}