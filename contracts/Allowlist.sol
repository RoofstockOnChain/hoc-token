// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Allowlist is Ownable {
    mapping(address => uint256) private allowed;
    event Allowed(address indexed account);
    event Disallowed(address indexed account);

    function isAllowed(address _address) public view returns(bool) {
        return allowed[_address] > block.timestamp;
    }

    function allow(address _address, uint256 expiration) public onlyOwner {
        allowed[_address] = expiration;
        emit Allowed(_address);
    }

    function disallow(address _address) public onlyOwner {
        allowed[_address] = block.timestamp;
        emit Disallowed(_address);
    }
}
