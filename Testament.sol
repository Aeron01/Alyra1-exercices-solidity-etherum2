// SPDX-License-Identifier: MIT

// testnet : 
// n° contract: 
// address owner : 

pragma solidity ^0.8.0;

//importation


contract Testament {
    //librairies
    
    //status des variables
    address private _owner;
    uint256 private _timeStamp;
    
    // evenements
    event Transfered(address indexed sender, uint256 amount);
    event inherited(address indexed sender, uint256 amount);
    
    //constructeur
    constructor(address owner_) {
        _owner = owner_;
    }
    
    //modifieurs
    modifier onlyOwner() {
        require(msg.sender == _owner, "Testament: Only owner can call this function");
        _;
    }
    
    //fonctions
    receive() external payable {
        _legacy(msg.sender, msg.value);
    }
    
    fallback() external {
        
    }
    
    function legacy() external payable {
        require(msg.value > 0, "Testament: can not offer 0 ether");
        _legacy(msg.sender, msg.value);
        emit Transfered(msg.sender, msg.value);
    }
    
    function getPresent() public onlyOwner {
        require(block.timestamp > _timeStamp, "Testament: Owner is still alive.");
        require(address(this).balance > 0, "Testament: You cannot transmit an inheritance of 0 ether");
        payable(msg.sender).transfer(address(this).balance);
    }
    
    function owner() public view returns(address) {
        return _owner;
    }
    
        
    function total() public view returns (uint256) {
        return address(this).balance;
    }
    
    function _legacy(address sender, uint256 amount) private {
        emit inherited(sender, amount);
    }
}