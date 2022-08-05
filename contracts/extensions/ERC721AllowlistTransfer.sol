// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ERC721AllowlistTransfer is Initializable, ERC721Upgradeable, AccessControlUpgradeable {
    address private _allowlistContractAddress;
    event AllowlistContractAddressChanged(address indexed allowlistContractAddress);

    function __ERC721AllowlistTransfer_init(address allowlistContractAddress)
        internal
        onlyInitializing
    {
        require(allowlistContractAddress != address(0), "ERC721AllowlistTransfer: Allowlist smart contract address must exist");
        _allowlistContractAddress = allowlistContractAddress;
        emit AllowlistContractAddressChanged(allowlistContractAddress);
    }

    function setAllowlistContractAddress(address allowlistContractAddress)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(allowlistContractAddress != address(0), "ERC721AllowlistTransfer: Allowlist smart contract address must exist");
        _allowlistContractAddress = allowlistContractAddress;
        emit AllowlistContractAddressChanged(allowlistContractAddress);
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public
        virtual
        override
    {
        // TODO: Check the allowlist
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data)
        public
        virtual
        override
    {
        // TODO: Check the allowlist
        _safeTransfer(from, to, tokenId, _data);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
