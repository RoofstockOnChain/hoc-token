// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import 'erc721a-upgradeable/contracts/ERC721AUpgradeable.sol';
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

error NotSupported();

/// @title A soulbound token that you get once you KYC with Roofstock onChain that allows you to receive Home onChain tokens.
/// @author Roofstock onChain team
contract KycOnChainToken is Initializable, ERC721AUpgradeable, PausableUpgradeable, AccessControlUpgradeable {
    string private _baseTokenURI;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant KYC_ROLE = keccak256("KYC_ROLE");

    mapping(address => uint256) private expirations;
    event ExpirationUpdated(address indexed _address, uint256 indexed expiration);

    /// @notice Initializes the contract.
    function initialize()
        initializerERC721A
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

    /// @notice Mints new tokens.
    /// @dev Only Roofstock onChain can mint new tokens.
    /// @param to The address that will own the token after the mint is complete.
    /// @param expiration The date at which the token recipient will no longer be able to recieve tokens.
    function mint(address to, uint256 expiration)
        public
        onlyRole(KYC_ROLE)
    {
        _mint(to, 1);
        setExpiration(to, expiration);
    }

    /// @notice Burns the token.
    /// @dev Only Roofstock onChain can burn tokens.
    /// @param tokenId The token ID to be burned.
    function burn(uint256 tokenId)
        public
        onlyRole(BURNER_ROLE)
    {
        _burn(tokenId);
    }

    /// @notice Checks to see if the address has expired.
    /// @param _address The address that you want to check.
    /// @return Whether the address has expired.
    function isAllowed(address _address)
        public
        view
        returns(bool)
    {
        return expirations[_address] > block.timestamp;
    }

    /// @notice Gets the expiration date of the address.
    /// @param _address The address to check.
    /// @return The date that the address expires.
    function getExpiration(address _address)
        public
        view
        returns (uint256)
    {
        return expirations[_address];
    }

    /// @notice Sets the exiration for the address.
    /// @dev Can only be called by Roofstock onChain.
    /// @param _address The address whose expiration is to be set.
    /// @param expiration The date for which the address will expire.
    function setExpiration(address _address, uint256 expiration)
        public
        onlyRole(KYC_ROLE)
    {
        expirations[_address] = expiration;
        emit ExpirationUpdated(_address, expiration);
    }

    /// @notice Expires the address immediately.
    /// @dev Can only be called by Roofstock onChain.
    /// @param _address The address whose expiratoin is to be set.
    function expire(address _address)
        public
        onlyRole(KYC_ROLE)
    {
        setExpiration(_address, block.timestamp);
    }

    /// @notice Pauses transfers on the contract.
    /// @dev Can be called by Roofstock onChain to halt transfers.
    function pause()
        public
        onlyRole(PAUSER_ROLE)
    {
        _pause();
    }

    /// @notice Unpauses transfers on the contract.
    /// @dev Can be called by Roofstock onChain to resume transfers.
    function unpause()
        public 
        onlyRole(PAUSER_ROLE)
    {
        _unpause();
    }

    /// @notice Gets the base URI for all tokens.
    /// @return The token base URI.
    function _baseURI()
        internal
        view
        override
        returns (string memory)
    {
        return _baseTokenURI;
    }

    /// @notice Sets the base URI for all tokens.
    /// @param baseTokenURI The new base URI.
    function setBaseURI(string memory baseTokenURI)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _baseTokenURI = baseTokenURI;
    }

    /// @notice Override that is called before all transfers.
    /// @dev Makes sure that the contract is not paused.
    /// @param from The address where the token is coming from.
    /// @param to The address where the token is going to.
    /// @param startTokenId The id of the token
    /// @param quantity The number of tokens that are being transferred.
    function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity)
        internal
        virtual
        override
        whenNotPaused
    {
        super._beforeTokenTransfers(from, to, startTokenId, quantity);
    }

    /// @dev This function is not allowed because we want the token to be soulbound.
    function transferFrom(address, address, uint256)
        public
        virtual
        override
    {
        revert NotSupported();
    }

    /// @dev This function is not allowed because we want the token to be soulbound.
    function safeTransferFrom(address, address, uint256, bytes memory)
        public
        virtual
        override
    {
        revert NotSupported();
    }

    /// @dev This function is not allowed because we want the token to be soulbound.
    function approve(address, uint256)
        public
        virtual
        override
    {
        revert NotSupported();
    }

    /// @dev This function is not allowed because we want the token to be soulbound.
    function getApproved(uint256)
        public
        view
        virtual
        override
        returns (address)
    {
        revert NotSupported();
    }

    /// @dev This function is not allowed because we want the token to be soulbound.
    function isApprovedForAll(address, address)
        public
        view
        virtual
        override
        returns (bool)
    {
        revert NotSupported();
    }

    /// @dev This function is not allowed because we want the token to be soulbound.
    function setApprovalForAll(address, bool)
        public
        virtual
        override
    {
        revert NotSupported();
    }

    /// @dev The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721AUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
