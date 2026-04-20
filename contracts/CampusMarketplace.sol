// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./CampusCoin.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CampusMarketplace is Ownable {

    CampusCoin public token;

    struct Item {
        string name;
        uint price;
        bool active;
    }

    uint public itemCount;

    mapping(uint => Item) public items;

    event Redeemed(address user, uint itemId);

    constructor(address _token) {
        token = CampusCoin(_token);
    }

    function addItem(string memory name, uint price) external onlyOwner {
        items[itemCount] = Item(name, price, true);
        itemCount++;
    }

    function redeem(uint itemId) external {

        Item memory item = items[itemId];

        require(item.active, "Item not available");

        require(
            token.balanceOf(msg.sender) >= item.price,
            "Insufficient tokens"
        );

        token.transferFrom(msg.sender, address(this), item.price);

        emit Redeemed(msg.sender, itemId);
    }
}