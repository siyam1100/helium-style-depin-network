// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title HotspotRegistry
 * @dev Manages the geographic registration of physical hardware.
 */
contract HotspotRegistry is Ownable {
    struct Hotspot {
        address owner;
        string h3Index; // Hexagonal geographic index
        uint256 lastHeartbeat;
        bool active;
    }

    mapping(bytes32 => Hotspot) public hotspots; // Key is keccak256(hardwareID)
    uint256 public totalHotspots;

    event HotspotOnboarded(bytes32 indexed id, address indexed owner, string h3Index);

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Registers a new physical device on the network.
     */
    function onboard(bytes32 _id, string calldata _h3Index) external payable {
        require(msg.value >= 0.05 ether, "Onboarding fee required");
        require(!hotspots[_id].active, "Already onboarded");

        hotspots[_id] = Hotspot({
            owner: msg.sender,
            h3Index: _h3Index,
            lastHeartbeat: block.timestamp,
            active: true
        });

        totalHotspots++;
        emit HotspotOnboarded(_id, msg.sender, _h3Index);
    }

    function recordHeartbeat(bytes32 _id) external {
        require(hotspots[_id].owner == msg.sender, "Not the owner");
        hotspots[_id].lastHeartbeat = block.timestamp;
    }
}
