// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeviceLocationTracker {
    address public owner;
    mapping(address => bool) public authorizedUpdaters;

    struct Location {
        uint latitude;
        uint longitude;
    }
    // map device_id => Location
    mapping(string => Location) public deviceLocations;

    constructor() {
        owner = msg.sender; // Set the contract creator as the initial owner
        authorizedUpdaters[owner] = true; // Automatically authorize the owner
    }

    // Modifier to restrict function access to authorized addresses only
    modifier onlyAuthorized() {
        require(authorizedUpdaters[msg.sender], "Caller is not authorized");
        _;
    }

    // Function to transfer ownership of the contract
    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Caller is not the owner");
        owner = newOwner;
        authorizedUpdaters[newOwner] = true; // Automatically authorize the new owner
    }

    // Function to add an authorized updater
    function addAuthorizedUpdater(address updater) public {
        require(msg.sender == owner, "Caller is not the owner");
        authorizedUpdaters[updater] = true;
    }

    // Function to remove an authorized updater
    function removeAuthorizedUpdater(address updater) public {
        require(msg.sender == owner, "Caller is not the owner");
        authorizedUpdaters[updater] = false;
    }

    // Function to retrieve a device's location
    function getLocation(string memory deviceId) public view returns (uint latitude, uint longitude) {
        Location memory loc = deviceLocations[deviceId];
        return (loc.latitude, loc.longitude);
    }
 
    // Function to see if a device is at a location
    function isDeviceAtLocation(string memory deviceId, uint _latitude, uint _longitude) public view returns (bool) {
        Location memory loc = deviceLocations[deviceId];
        return (loc.latitude == _latitude && loc.longitude == _longitude);
    }

    // Function to update locations for multiple devices
    function updateLocationsBatch(string[] memory deviceIds, uint[] memory latitudes, uint[] memory longitudes) public {
        require(deviceIds.length == latitudes.length && latitudes.length == longitudes.length, "Data arrays must have the same length");

        for (uint i = 0; i < deviceIds.length; i++) {
            deviceLocations[deviceIds[i]] = Location(latitudes[i], longitudes[i]);
        }
    }
    
}

