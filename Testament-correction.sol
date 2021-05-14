// SPDX-License-Identifier: MIT

// testnet : 
// n° contract: 
// address owner : 

pragma solidity ^0.8.0;

//importation
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Testament {
    //librairies
    using Address for address payable;
    //status des variables
    address private _owner;
    address private _doctor;
    bool private _contractEnd;
    mapping (address => uint256) private _legacy;
    
    
    //constructeur
    constructor(address owner_, address doctor_) {
        require(owner_ != doctor_, "Testament: You cannot define the owner and the doctor as the same person.");
        _owner = owner_;
    }
    
    // evenements
    event Bequeath(address indexed account, uint256 amount);
    event DoctorChanged(address indexed doctor);
    event ContractEnded(address indexed doctor);
    event LegacyWithdrew(address indexed account, uint256 indexed amount);
    
    //modifieurs
    modifier onlyOwner() {
        require(msg.sender == _owner, "Testament: Only owner can call this function");
        _;
    }
    
    modifier onlyDoctor() {
        require(msg.sender == _doctor, "Testament: Only owner can call this function");
        _;
    }
    
    modifier contractOver() {
        require(_contractEnd == true, "Testament: The contract has not yet over.");
        _;
    }
    
    //fonctions
    function bequeath(address account) external payable onlyOwner {
        _legacy[account]+msg.value;
        emit Bequeath(account, msg.value);
    }
    
    function setDoctor(address account) public onlyOwner {
        require(msg.sender != account, "Testament: you cannot be set as doctor.");
        _doctor = account;
        emit DoctorChanged(account);
    }
    
    function contractEnded() public onlyDoctor {
        require(_contractEnd == false, "Testament:");
        _contractEnd = true;
        emit ContractEnded(msg.sender);
    }

    function withdraw() public contractOver {
        require(_legacy[msg.sender] != 0, "Testament: can not offer 0 ether");
        uint256 amount = _legacy[msg.sender];
        _legacy[msg.sender] = 0;
        payable(msg.sender).sendValue(amount);
        emit LegacyWithdrew(msg.sender, amount);
    }
    
    function owner() public view returns(address) {
        return _owner;
    }
    
    function legacyOf(address account) public view returns (uint256) {
        return _legacy[account];
    }
    
    function doctor() public view returns (address) {
        return _doctor;
    }
    
    function isContractOver() public view returns (bool) {
        return _contractEnd;
    }
}