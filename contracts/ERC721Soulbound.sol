// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract ERC721Soulbound is ERC721Upgradeable, AccessControlUpgradeable {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /**
     * @dev Total number of tokens minted
     */
    uint256 public totalSupply;

    // All the tokens share the same metadata
    string private uri;

    constructor() {
        // Prevents logic contract from being initialized
        _disableInitializers();
    }

    /**
     * @dev This can only be called once.
     * Should be called in the proxy contract right after instantiation.
     */
    function initialize(
        string calldata name,
        string calldata symbol,
        string calldata _tokenURI,
        address admin,
        address minter
    ) external initializer {
        __ERC721_init(name, symbol);
        __AccessControl_init();
        uri = _tokenURI;

        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(MINTER_ROLE, minter);
    }

    /**
     * @dev Block all transfers, except when minting or when msgSender is admin.
     */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
        require(from == address(0) || hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot transfer soulbound token");
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev Override isApprovedForAll to always approve admin. Usefull for social recovery
     */
    function isApprovedForAll(address tokenOwner, address operator) public view virtual override returns (bool) {
        if (hasRole(DEFAULT_ADMIN_ROLE, operator)) {
            return true;
        }
        return super.isApprovedForAll(tokenOwner, operator);
    }

    /**
     * @dev Batched version of of {IERC721-ownerOf}.
     */
    function ownerOfBatch(uint256[] calldata tokenIds) external view returns (address[] memory) {
        address[] memory owners = new address[](tokenIds.length);
        for(uint256 i = 0; i < tokenIds.length; ++i) {
            owners[i] = ownerOf(tokenIds[i]);
        }
        return owners;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireMinted(tokenId);
        return uri;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, AccessControlUpgradeable) returns (bool) {
        return ERC721Upgradeable.supportsInterface(interfaceId) ||
            AccessControlUpgradeable.supportsInterface(interfaceId);
    }

    /**
     * @dev Only minter is able to mint new tokens.
     */
    function mint(address to) external onlyRole(MINTER_ROLE) {
        _safeMint(to, ++totalSupply);
    }

    /**
     * @dev Minter can mint multiple tokens in one transaction.
     */
    function mintBatch(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        for (uint256 i = 1; i <= amount; ++i) {
            _safeMint(to, totalSupply + i);
        }
        totalSupply += amount;
    }

    /**
     * @dev Owner can change tokens URI.
     */
    function setTokenURI(string calldata newURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        uri = newURI;
    }
}
