// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

error NotSupported();

contract KycOnChainToken is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, PausableUpgradeable, AccessControlUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIdCounter;

    string private _baseTokenURI;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant KYC_ROLE = keccak256("KYC_ROLE");

    mapping(address => uint256) private expirations;
    event ExpirationUpdated(address indexed _address, uint256 indexed expiration);

    function initialize()
        initializer
        public
    {
        __ERC721_init("KycOnChainToken", "KYC");
        __ERC721Enumerable_init();
        __Pausable_init();
        __AccessControl_init();

        _baseTokenURI = "https://onchain.roofstock.com/kyc/metadata/";

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
        _grantRole(KYC_ROLE, msg.sender);
    }

    function mint(address to, uint256 expiration)
        public
        onlyRole(KYC_ROLE)
    {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        setExpiration(to, expiration);
    }

    function burn(uint256 tokenId)
        public
        onlyRole(BURNER_ROLE)
    {
        _burn(tokenId);
    }

    function getExpiration(address _address)
        public
        view
        returns (uint256)
    {
        return expirations[_address];
    }

    function setExpiration(address _address, uint256 expiration)
        public
        onlyRole(KYC_ROLE)
    {
        expirations[_address] = expiration;
        emit ExpirationUpdated(_address, expiration);
    }

    function expire(address _address)
        public
        onlyRole(KYC_ROLE)
    {
        setExpiration(_address, block.timestamp);
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
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public
        virtual
        override(ERC721Upgradeable, IERC721Upgradeable)
    {
        from;
        to;
        tokenId;
        revert NotSupported();
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data)
        public
        virtual
        override(ERC721Upgradeable, IERC721Upgradeable)
    {
        from;
        to;
        tokenId;
        _data;
        revert NotSupported();
    }

    function approve(address to, uint256 tokenId)
        public
        virtual
        override(ERC721Upgradeable, IERC721Upgradeable)
    {
        to;
        tokenId;
        revert NotSupported();
    }

    function getApproved(uint256 tokenId)
        public
        view
        virtual
        override(ERC721Upgradeable, IERC721Upgradeable)
        returns (address)
    {
        tokenId;
        revert NotSupported();
    }

    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override(ERC721Upgradeable, IERC721Upgradeable)
        returns (bool)
    {
        owner;
        operator;
        revert NotSupported();
    }

    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override(ERC721Upgradeable, IERC721Upgradeable)
    {
        operator;
        approved;
        revert NotSupported();
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
