// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import '../interfaces/IERC721.sol';
import '../interfaces/IERC721Errors.sol';
import '../interfaces/IERC721Receiver.sol';

contract MyERC721Token is ERC721, IERC721Errors {

    address private _contactOwner;

    mapping(uint256 tokenId => address) private _owners;

    mapping(address owner => uint256) private _balances;

    mapping(uint256 tokenId => address) private _tokenApprovals;

    mapping(address owner => mapping(address operator => bool)) private _operatorApprovals;

    mapping(uint256 tokenId => string) private _tokenURIs;

    uint256 private _nextId = 1;

    constructor () {
        _contactOwner = msg.sender;
    }

    function name() public pure returns (string memory) {
        return "Task 2 Examle Of ERC721 Token";
    }

    function symbol() public pure returns (string memory) {
        return "T2EOE721T";
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function balanceOf(
        address owner
    ) external view override returns (uint256) {
        if (owner == address(0)) {
            revert ERC721InvalidOwner(address(0));
        }
        return _balances[owner];
    }

    function ownerOf(
        uint256 tokenId
    ) external view override returns (address) {
        address owner = _owners[tokenId];
        if (owner == address(0)) {
            revert ERC721NonexistentToken(tokenId);
        }
        return owner;
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override {
        transferFrom(from, to, tokenId);
        _checkOnERC721Received(msg.sender, from, to, tokenId, data);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        address owner = _owners[tokenId];
        if (to == address(0)) {
            revert ERC721InvalidReceiver(address(0));
        }
        if (owner != from) {
            revert ERC721IncorrectOwner(from, tokenId, owner);
        }
        _update(to, tokenId, msg.sender);
    }


    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal {
        address from = _owners[tokenId];

        if (from != address(0)) {

            if (!_isAuthorized(from, auth, tokenId)) {
                revert ERC721InsufficientApproval(from, tokenId);
            }

            _approve(address(0), tokenId, address(0), false);

            unchecked {
                _balances[from] -= 1;
            }
        }

        if (to != address(0)) {
            unchecked {
                _balances[to] += 1;
            }
        }

        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function approve(
        address approved,
        uint256 tokenId
    ) public override {
        _approve(approved, tokenId, msg.sender, true);
    }

    function _approve(address to, uint256 tokenId, address auth, bool emitEvent) internal {
        if (emitEvent || auth != address(0)) {
            address owner = _owners[tokenId];

            if (auth != address(0) && owner != auth && !isApprovedForAll(owner, auth)) {
                revert ERC721InvalidApprover(auth);
            }

            if (emitEvent) {
                emit Approval(owner, to, tokenId);
            }
        }

        _tokenApprovals[tokenId] = to;
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) external override {
          address owner = msg.sender;
          if (operator == address(0)) {
              revert ERC721InvalidOperator(operator);
          }
          _operatorApprovals[owner][operator] = approved;
          emit ApprovalForAll(owner, operator, approved);
    }

    function getApproved(
        uint256 tokenId
    ) public view override returns (address) {
        return _owners[tokenId];
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    modifier onlyOwner() {
        address sender = msg.sender;
        if (sender != _contactOwner) {
            revert ERC721InvalidSender(sender);
        }
        _;
    }

    function safeMint(
        address to,
        string memory uri
    ) public onlyOwner  {
        uint256 tokenId = uint256(keccak256(abi.encodePacked(block.timestamp, _nextId)));
        _tokenURIs[tokenId] = uri;
        _update(to, tokenId, address(0));
        _nextId++;
    }

    function _isContract(
        address addr
    ) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function _isAuthorized(
        address owner,
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        return
            spender != address(0) &&
            (
                owner == spender ||
                isApprovedForAll(owner, spender) ||
                getApproved(tokenId) == spender
            );
    }

    function _checkOnERC721Received(
        address operator,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(operator, from, tokenId, data) returns (bytes4 retval) {
                if (retval != IERC721Receiver.onERC721Received.selector) {
                    revert IERC721Errors.ERC721InvalidReceiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert IERC721Errors.ERC721InvalidReceiver(to);
                } else {
                    assembly ("memory-safe") {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
    }
}