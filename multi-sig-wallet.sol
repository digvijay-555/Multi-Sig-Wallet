//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract multi_sig_wallet{
    uint256 total_owners;
    uint256 minimum_stake;


    constructor(uint256 _total_owners, uint256 min_stake){
        total_owners=_total_owners;
        minimum_stake=min_stake;
    }
    
    uint256 curr_owners = 0;
    address[] public owners;
    mapping(address => bool) check_owner;

    function add_owner() public payable{
        require(msg.value>=minimum_stake, "More stake required");
        require(!check_owner[msg.sender], "Already an owner");
        require(curr_owners<total_owners, "Maximum owner limit reached");
        curr_owners++;
        check_owner[msg.sender]=true;
        owners.push(msg.sender);
    }

    function send(address payable to, uint256 amount) public payable{
        require(check_owner[msg.sender], "Not an owner");
        require(amount<=address(this).balance, "Not enough balance");
        to.transfer(amount);
    }

    function withdraw(uint256 amount) public {
        require(amount<=address(this).balance, "Not enough amount");
        require(check_owner[msg.sender], "Not an owner");
        payable(msg.sender).transfer(amount);
    }




}
