// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./HotspotRegistry.sol";

/**
 * @title DePINRewards
 * @dev Mints tokens for active infrastructure providers.
 */
contract DePINRewards is ERC20, Ownable {
    HotspotRegistry public registry;
    uint256 public constant REWARD_PER_EPOCH = 10 * 1e18;

    constructor(address _registry) ERC20("Network Token", "NTK") Ownable(msg.sender) {
        registry = HotspotRegistry(_registry);
    }

    /**
     * @dev Distributes rewards to active hotspots. 
     * In production, this would be triggered by an Oracle or specialized PoC logic.
     */
    function distributeEpochRewards(bytes32[] calldata _activeIds) external onlyOwner {
        for (uint i = 0; i < _activeIds.length; i++) {
            (address owner, , , bool active) = registry.hotspots(_activeIds[i]);
            if (active) {
                _mint(owner, REWARD_PER_EPOCH);
            }
        }
    }
}
