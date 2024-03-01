// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeviceLocationTracker {
    address public owner;
    mapping(address => bool) public authorizedUpdaters;

    struct Location {
        int latitude;
        int longitude;
    }
    // map keccak256(device_id) => Location
    mapping(bytes32 => Location) public deviceLocations;

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
    function getLocation(bytes32 deviceId) public view returns (int latitude, int longitude) {
        Location memory loc = deviceLocations[deviceId];
        return (loc.latitude, loc.longitude);
    }
 
    // Function to see if a device is at a location
    function isDeviceAtLocation(bytes32 deviceId, int _latitude, int _longitude) public view returns (bool) {
        Location memory loc = deviceLocations[deviceId];
        return (loc.latitude == _latitude && loc.longitude == _longitude);
    }

    // This returns true if the device ID is withing the radius represented in meters from the target lat and lng.
    function isDeviceWithinDistance(
        bytes32 deviceId,
        int targetLatitude,
        int targetLongitude,
        int radiusInMeters
    ) public view returns (bool) {
        Location memory deviceLoc = deviceLocations[deviceId];
        
        // Convert the radius from meters to degrees approximately
        // Note: 1 degree of latitude is approximately 111km (111,000 meters)
        int latDifference = abs(deviceLoc.latitude - targetLatitude);
        int longDifference = abs(deviceLoc.longitude - targetLongitude);
        
        // Convert differences to meters
        // Assuming roughly 111,000 meters per degree for both latitude and longitude
        int latDistanceInMeters = latDifference * 111000;
        int longDistanceInMeters = longDifference * 111000;

        // Check if the device is within the "circular" radius around the target location
        // This is a simplification and not accurate for large distances or close to the poles
        return (latDistanceInMeters <= radiusInMeters && longDistanceInMeters <= radiusInMeters);
    }

    // Helper function for absolute value
    function abs(int x) private pure returns (int) {
        return x >= 0 ? x : -x;
    }

    // Function to update locations for multiple devices.
    // Accepts the keccak256 hash of deviceId as imput.
    function updateLocationsBatch(bytes32[] memory deviceIds, int[] memory latitudes, int[] memory longitudes) public onlyAuthorized {
        require(deviceIds.length == latitudes.length && latitudes.length == longitudes.length, "Data arrays must have the same length");

        for (uint i = 0; i < deviceIds.length; i++) {
            deviceLocations[deviceIds[i]] = Location(latitudes[i], longitudes[i]);
        }
    }    
}
