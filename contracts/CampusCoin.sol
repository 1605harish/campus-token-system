// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CampusCoin is ERC20, Ownable {

    mapping(address => bool) public authorizedMinters;

    constructor() ERC20("Campus Coin", "CCOIN") {}

    function setMinter(address _minter, bool _status) external onlyOwner {
        authorizedMinters[_minter] = _status;
    }

    function mint(address to, uint256 amount) external {
        require(authorizedMinters[msg.sender], "Not authorized");
        _mint(to, amount);
    }
}