// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@quadrata/contracts/interfaces/IQuadPassport.sol";
import "./IKyc.sol";

/// @title Allows users to KYC/AML on Quadrata and acknowledge our documents on the blockchain.
/// @author Roofstock onChain team
contract RoofstockOnChainKyc is Initializable, OwnableUpgradeable, IKyc {
    /* DO NOT CHANGE THE ORDER OF THESE VARIABLES - BEGIN */
    address private _quadPassportContractAddress;

    mapping(address => bool) private documentsAcknowledged;
    mapping(address => bool) private verifiedRecipients;
    /* DO NOT CHANGE THE ORDER OF THESE VARIABLES - END */

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the contract.
    /// @param quadPassportContractAddress The default value of the QuadPassport contract address.
    function initialize(address quadPassportContractAddress)
        initializer
        public
    {
        require(quadPassportContractAddress != address(0), "RoofstockOnChainKyc: QuadPassport smart contract address must exist");
        _quadPassportContractAddress = quadPassportContractAddress;

        __Ownable_init();
    }

    /// @notice Gets the contract address for the Quadrata Passport contract.
    function getQuadrataPassportContractAddress()
        external
        view
        returns (address)
    {
        return _quadPassportContractAddress;
    }

    /// @notice Checks to see if the address has a token and is KYC'd.
    /// @param _address The address that you want to check.
    /// @return Whether the address has has a token and it is KYC'd.
    function isAllowed(address _address)
        public
        view
        returns(bool)
    {
        require(_address != address(0), "RoofstockOnChainKyc: Address must exist");
        if (isVerifiedRecipient(_address))
        {
            return true;
        }

        bool _isIdentityVerified = isIdentityVerified(_address);
        return _isIdentityVerified && documentsAcknowledged[_address];
    }

    /// @notice Acknowleges that the sender has read the following docs:
    ///   - https://ipfs.io/ipfs/QmUWMB55arnbjQvmdNFcdVEwm3VfAi8XFnNMzKmYqVAFcW/hoc-documents/forms/purchase-and-sale-agreement.pdf
    ///   - https://ipfs.io/ipfs/QmUWMB55arnbjQvmdNFcdVEwm3VfAi8XFnNMzKmYqVAFcW/hoc-documents/forms/llc-agreement.pdf
    ///   - https://ipfs.io/ipfs/QmUWMB55arnbjQvmdNFcdVEwm3VfAi8XFnNMzKmYqVAFcW/hoc-documents/forms/llc-admin-agreement.pdf
    ///   - https://ipfs.io/ipfs/QmUWMB55arnbjQvmdNFcdVEwm3VfAi8XFnNMzKmYqVAFcW/hoc-documents/forms/token-admin-agreement.pdf
    function acknowledgeDocuments()
        public
    {
        require(!documentsAcknowledged[msg.sender], "RoofstockOnChainKyc: This address has already acknowleged the documents.");
        documentsAcknowledged[msg.sender] = true;
    }

    /// @notice Checks to see if the sender has acknowledged documents.
    /// @param _address The address that you want to check.
    /// @return Whether the sender has acknowledged documents.
    function hasAcknowlegedDocuments(address _address)
        public
        view
        returns(bool)
    {
        return documentsAcknowledged[_address];
    }

    /// @notice Adds a verified recipient.
    /// @dev Can only be called by contract owner.
    /// @param _address The address of the verified recipient that is to be added.
    function addVerifiedRecipient(address _address)
        public
        onlyOwner
    {
        require(!verifiedRecipients[_address], "RoofstockOnChainKyc: This address has already a verified recipient.");
        verifiedRecipients[_address] = true;
    }

    /// @notice Removes a verified recipient.
    /// @dev Can only be called by contract owner.
    /// @param _address The address of the verified recipient that is to be removed.
    function removeVerifiedRecipient(address _address)
        public
        onlyOwner
    {
        require(verifiedRecipients[_address], "RoofstockOnChainKyc: This address is not a verified recipient.");
        verifiedRecipients[_address] = false;
    }

    /// @notice Checks to see if the address is a verified recipient.
    /// @param _address The address that you want to check.
    /// @return Whether the address is a verified recipient.
    function isVerifiedRecipient(address _address)
        public
        view
        returns(bool)
    {
        return verifiedRecipients[_address];
    }

    /// @notice Checks to see if the address has had it's identity verified on Quadrata.
    /// @param _address The address that you want to check.
    /// @return Whether the address has been verified on Quadrata.
    function isIdentityVerified(address _address)
        public
        view
        returns(bool)
    {
        IQuadPassport _quadPassport = IQuadPassport(_quadPassportContractAddress);
        IQuadPassportStore.Attribute memory countryAttribute = _quadPassport.attribute(
            _address, 
            keccak256("COUNTRY")
        );
        IQuadPassportStore.Attribute memory amlAttribute = _quadPassport.attribute(
            _address, 
            keccak256("AML")
        );
        bool isEligibleCountry = countryIsEqual(countryAttribute.value, "US");
        bool isEligibleAML = amlLessThanEqual(amlAttribute.value, 5);
        return isEligibleCountry && isEligibleAML;
    }

    /// @dev Checks if Country return value is equal to a given string value
    /// @param _attrValue return value of query
    /// @param _expectedString expected country value as string
    function countryIsEqual(bytes32 _attrValue, string memory _expectedString) private pure returns (bool) {
        return(_attrValue == keccak256(abi.encodePacked(_expectedString)));
    }

    /// @dev Checks if AML return value is less than or equal to a given uint256 value
    /// @param _attrValue return value of query
    /// @param _upperBound upper bound AML value as uint256
    function amlLessThanEqual(bytes32 _attrValue, uint256 _upperBound) private pure returns (bool) {
        return(uint256(_attrValue) <= _upperBound);
    }
}
