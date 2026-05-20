// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {BasenameRegistrar} from "basenames-module/BasenameRegistrar.sol";

/// @title Counter
/// @notice A simple public counter contract that owns a Basename.
///         Anyone can increment the count.
///         Only the owner can register or update the contract's Basename.
/// @dev Demonstrates the basenames-module: https://github.com/mykclawd/basenames-module
contract Counter is BasenameRegistrar {

    // =============================================================
    //                           STORAGE
    // =============================================================

    address public owner;
    uint256 public count;

    // =============================================================
    //                           ERRORS / EVENTS
    // =============================================================

    error NotOwner();

    event CountIncremented(address indexed by, uint256 newCount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // =============================================================
    //                           MODIFIERS
    // =============================================================

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // =============================================================
    //                           CONSTRUCTOR
    // =============================================================

    constructor(address owner_)
        BasenameRegistrar(address(0), address(0), address(0))
    {
        owner = owner_;
    }

    // =============================================================
    //                       PUBLIC COUNTER
    // =============================================================

    /// @notice Increment the counter by 1. Anyone can call this.
    function increment() external {
        count += 1;
        emit CountIncremented(msg.sender, count);
    }

    /// @notice Read the current count.
    function getCount() external view returns (uint256) {
        return count;
    }

    // =============================================================
    //                     BASENAME MANAGEMENT
    // =============================================================

    /**
     * @notice Step 1: Register a Basename and set the reverse (primary) name.
     * @dev Only owner. Send ETH with this call (use getBasenamePrice to check amount).
     *      Sets: address(this) → name.base.eth  ✓
     *      After this call, run setForwardResolution(name) as a separate transaction.
     *
     *      Two-tx pattern avoids gas estimation issues that occur when both
     *      registration and resolver writes are bundled together.
     *
     * @param name     The label to register, e.g. "myapp" → myapp.base.eth
     * @param duration Seconds (minimum 31536000 = 1 year)
     */
    function registerBasename(string memory name, uint256 duration)
        external
        payable
        onlyOwner
    {
        _registerBasename(name, duration);
    }

    /**
     * @notice Step 2: Set the forward addr record.
     * @dev Call this after registerBasename. No ETH needed.
     *      Sets: name.base.eth → address(this)  ✓
     *      Also works as a rescue if forward resolution is missing or stale.
     * @param name The label (e.g. "myapp")
     */
    function setForwardResolution(string memory name) external onlyOwner {
        _setForwardResolution(name);
    }

    /**
     * @notice Update the primary (reverse) name: address(this) → name.base.eth.
     * @dev Use when the contract already owns the name but you want to update
     *      which name is shown as primary.
     * @param name The label or full name (e.g. "myapp" or "myapp.base.eth")
     */
    function setPrimaryBasename(string memory name) external onlyOwner {
        _setPrimaryBasename(name);
    }

    /// @notice Transfer ownership of this contract.
    function transferOwnership(address newOwner) external onlyOwner {
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // =============================================================
    //                           RECEIVE
    // =============================================================

    receive() external payable override {}
}
