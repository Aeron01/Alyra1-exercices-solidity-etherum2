// SPDX-License-Identifier: MIT

// testnet : Rinkeby
// n° contract: 0xC7cE2Aa99D4e3DaAfc78D33c8D31f0583AEC7e34
// address owner : 0xe39D23Bf5b87cb6a8DCE793631E2848A4EF1E95c

pragma solidity ^0.8.0;

//importation


contract Birthday {
    //librairies
    
    //status des variables
    address private _owner;
    uint256 private _timeStamp;
    
    // evenements
    event Transfered(address indexed sender, uint256 amount);
    event Offred(address indexed sender, uint256 amount);
    
    //constructeur
    constructor(address owner_, uint256 birthday_) {
        _owner = owner_;
        _timeStamp = block.timestamp+(birthday_ * 1 days);
    }
    
    //modifieurs
    modifier onlyOwner() {
        require(msg.sender == _owner, "Birthday: Only owner can call this function");
        _;
    }
    
    //fonctions
    receive() external payable {
        _offer(msg.sender, msg.value);
    }
    
    fallback() external {
        
    }
    
    function offer() external payable {
        require(msg.value > 0, "Birthday: can not offer 0 ether");
        _offer(msg.sender, msg.value);
        emit Transfered(msg.sender, msg.value);
    }
    
    function getPresent() public onlyOwner {
        require(block.timestamp > _timeStamp, "This is not your birthday yet.");
        require(address(this).balance > 0, "Birthday: can not withdraw 0 ether");
        payable(msg.sender).transfer(address(this).balance);
    }
    
    function owner() public view returns(address) {
        return _owner;
    }
    
    function myBirthday() public view returns(uint256){
        return _timeStamp;
    }
    
    function total() public view returns (uint256) {
        return address(this).balance;
    }
    
    function _offer(address sender, uint256 amount) private {
        emit Offred(sender, amount);
    }
}