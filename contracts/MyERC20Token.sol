// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import '../interfaces/IRC20.sol';
import '../interfaces/IRC20Errors.sol';

contract MyERC20Token is IERC20, IRC20Errors {
    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256)) private _allowances;

    uint256 private _totalSupply = 1_000_000_000 ether;

    constructor() {
        address sender = msg.sender;
        _balances[sender] = 1_000_000_000 ether;
        emit Transfer(address(0), sender, 1_000_000_000);
    }

    function name() public view virtual returns (string memory) {
        return "Task 2 Examle Of ERC20 Token";
    }

    function symbol() public view virtual returns (string memory) {
        return "T2EOET";
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address to,
        uint256 value
    ) external override returns (bool) {
        address sender = msg.sender;
        _transfer(sender, to, value);
        return true;
    }

    function _transfer (
        address from,
        address to,
        uint256 value
    ) internal {
        if (to == address(0)) {
            revert InvalidReceiver(address(0));
        }
        uint256 fromBalance = _balances[from];
        if (fromBalance < value) {
            revert InsufficientBalance(from, fromBalance, value);
        }
        unchecked {
            _balances[from] = fromBalance - value;
        }
        unchecked {
            _balances[to] += value;
        }        
        emit Transfer(from, to, value);
    }

    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 value
    ) external override returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, value);
        return true;
    }

    function _approve(address owner, address spender, uint256 value) internal {
        if (spender == address(0)) {
            revert InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override returns (bool) {
        address spender = msg.sender;
        uint256 currentAllowance = _allowances[from][spender];
        if (currentAllowance < value) {
            revert InsufficientAllowance(spender, currentAllowance, value);
        }
        unchecked {
            _approve(from, spender, currentAllowance - value);
        }
        _transfer(from, to, value);
        return true;
    }
}