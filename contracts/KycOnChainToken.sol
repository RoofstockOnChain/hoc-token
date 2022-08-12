// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import 'erc721a-upgradeable/contracts/ERC721AUpgradeable.sol';
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

error NotSupported();

/// @title A soulbound token that you get once you KYC with Roofstock onChain that allows you to receive Home onChain tokens.
/// @author Roofstock onChain team
contract KycOnChainToken is Initializable, ERC721AUpgradeable, PausableUpgradeable, AccessControlUpgradeable {
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
        __ERC721A_init('KycOnChainToken', 'KYC');
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

    function isAllowed(address _address) public view returns(bool) {
        return expirations[_address] > block.timestamp;
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
        override
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

    function transferFrom(address, address, uint256)
        public
        virtual
        override
    {
        revert NotSupported();
    }

    function safeTransferFrom(address, address, uint256, bytes memory)
        public
        virtual
        override
    {
        revert NotSupported();
    }

    function approve(address, uint256)
        public
        virtual
        override
    {
        revert NotSupported();
    }

    function getApproved(uint256)
        public
        view
        virtual
        override
        returns (address)
    {
        revert NotSupported();
    }

    function isApprovedForAll(address, address)
        public
        view
        virtual
        override
        returns (bool)
    {
        revert NotSupported();
    }

    function setApprovalForAll(address, bool)
        public
        virtual
        override
    {
        revert NotSupported();
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721AUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
