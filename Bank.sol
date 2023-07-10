// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

//import "hardhat/console.sol";

contract Bank {
    address payable public owner_address;
    uint256 public account_balance;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    constructor(uint initBalance) payable {
        owner_address = payable(msg.sender);
        account_balance = initBalance;
    }

    
    function getBalance() public view returns(uint256){
        return account_balance;
    }

    function deposit(uint256 _amount) public payable {
        uint previous_Balance = account_balance;

        // make sure this is the owner
        require(msg.sender == owner_address, "You are not the owner of this account");

        // perform transaction
        account_balance += _amount;

        // assert transaction completed successfully
        assert(account_balance == previous_Balance + _amount);

        // emit the event
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 account_balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner_address, "You are not the owner of this account");
        uint previous_Balance = account_balance;
        if (account_balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: account_balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // withdraw the given amount
        account_balance -= _withdrawAmount;

        // assert the balance is correct
        assert(account_balance == (previous_Balance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);
    }
}
