// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "./Allowlist.sol";

contract HomeOnChainToken is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, AccessControlUpgradeable, PausableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIdCounter;

    string private _baseTokenURI;
    address private _allowlistContractAddress;
    event AllowlistContractAddressChanged(address indexed allowlistContractAddress);

    mapping(uint256 => uint256) private sellable;
    event SellableExpirationChanged(uint256 indexed tokenId, uint256 indexed expiration);

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    function initialize(address allowlistContractAddress)
        initializer
        public
    {
        __ERC721_init("Home onChain", "HoC");
        __ERC721Enumerable_init();
        __AccessControl_init();

        _baseTokenURI = "https://onchain.roofstock.com/metadata/";

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);

        setAllowlistContractAddress(allowlistContractAddress);
    }

    function mint(address to)
        public
        onlyRole(MINTER_ROLE)
    {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function burn(uint256 tokenId)
        public
        virtual
        onlyRole(BURNER_ROLE)
    {
        _burn(tokenId);
    }

    function setAllowlistContractAddress(address allowlistContractAddress)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(allowlistContractAddress != address(0), "HomeOnChainToken: Allowlist smart contract address must exist");
        _allowlistContractAddress = allowlistContractAddress;
        emit AllowlistContractAddressChanged(allowlistContractAddress);
    }

    function pause()
        public
        onlyRole(PAUSER_ROLE)
    {
        _pause();
    }

    function unpause()
        public 
        onlyRole(PAUSER_ROLE)
    {
        _unpause();
    }

    function _baseURI()
        internal
        view
        override(ERC721Upgradeable)
        returns (string memory)
    {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseTokenURI)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _baseTokenURI = baseTokenURI;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        require(to == address(0) || isAllowed(to), "HomeOnChainToken: To address must be on the allowlist");
        require(from == address(0) || isSellable(tokenId), "HomeOnChainToken: TokenId must be sellable");
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function isAllowed(address _address)
        private
        view
        returns (bool)
    {
        Allowlist allowlistContract = Allowlist(_allowlistContractAddress);
        return allowlistContract.isAllowed(_address);
    }

    function setSellableExpiration(uint256 tokenId, uint256 expiration)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(_exists(tokenId), "HomeOnChainToken: TokenId must exist");
        sellable[tokenId] = expiration;
        emit SellableExpirationChanged(tokenId, expiration);
    }

    function getSellableExpiration(uint256 tokenId)
        public
        view
        returns (uint256)
    {
        return sellable[tokenId];
    }

    function isSellable(uint256 tokenId)
        private
        view
        returns (bool)
    {
        return sellable[tokenId] > block.timestamp;
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
