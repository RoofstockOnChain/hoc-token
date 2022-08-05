// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Allowlist is Ownable {
    mapping(address => bool) private allowed;
    event Allowed(address indexed account);
    event Disallowed(address indexed account);

    function isAllowed(address _address) public view returns(bool) {
        return allowed[_address];
    }

    function allow(address _address) public onlyOwner {
        allowed[_address] = true;
        emit Allowed(_address);
    }

    function disallow(address _address) public onlyOwner {
        allowed[_address] = false;
        emit Disallowed(_address);
    }
}
