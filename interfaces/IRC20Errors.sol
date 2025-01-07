// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

interface IRC20Errors {

    error InvalidReceiver(address receiver);

    error InvalidSpender(address spender);

    error InsufficientBalance(address sender, uint256 balance, uint256 needed);

    error InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    
}