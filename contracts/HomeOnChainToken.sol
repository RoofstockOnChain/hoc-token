// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "./extensions/ERC721AllowlistTransfer.sol";
import "./extensions/ERC721BaseURI.sol";
import "./extensions/ERC721Burnable.sol";
import "./extensions/ERC721Mintable.sol";

contract HomeOnChainToken is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, AccessControlUpgradeable, ERC721AllowlistTransfer, ERC721BaseURI, ERC721Mintable, ERC721Burnable {
    function initialize(address allowlistContractAddress)
        initializer
        public
    {
        __ERC721_init("Home onChain", "HoC");
        __ERC721BaseURI_init("https://onchain.roofstock.com/metadata/");
        __ERC721Enumerable_init();
        __AccessControl_init();
        __ERC721Mintable_init();
        __ERC721Burnable_init();
        __ERC721AllowlistTransfer_init(allowlistContractAddress);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable, AccessControlUpgradeable, ERC721AllowlistTransfer, ERC721BaseURI, ERC721Mintable, ERC721Burnable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public
        override(ERC721AllowlistTransfer, ERC721Upgradeable, IERC721Upgradeable)
    {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data)
        public
        override(ERC721AllowlistTransfer, ERC721Upgradeable, IERC721Upgradeable)
    {
        return super.safeTransferFrom(from, to, tokenId, _data);
    }

    function _baseURI()
        internal
        view
        override(ERC721BaseURI, ERC721Upgradeable)
        returns (string memory)
    {
        return super._baseURI();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
