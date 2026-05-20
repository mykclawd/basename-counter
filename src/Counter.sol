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

    /// @notice The owner of this contract (can manage the Basename)
    address public owner;

    /// @notice The running count — anyone can increment
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

    /// @param owner_ Address that will own this contract and control the Basename.
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
     * @notice Register a Basename and set both resolution directions.
     * @dev Only owner. The contract must hold enough ETH (send with this call).
     *      After this:
     *        name.base.eth → address(this)   ← forward (via _setForwardResolution)
     *        address(this) → name.base.eth   ← reverse (via reverseRecord=true)
     * @param name     The label to register, e.g. "myapp" → myapp.base.eth
     * @param duration Seconds to register for (minimum 31536000 = 1 year)
     */
    function registerBasename(string memory name, uint256 duration)
        external
        payable
        onlyOwner
    {
        _registerBasename(name, duration);
        _setForwardResolution(name);
    }

    /**
     * @notice Fix or update the forward addr record: name.base.eth → address(this).
     * @dev Use this as a rescue if forward resolution is wrong or was never set.
     *      The contract must own the name.
     * @param name The label (e.g. "myapp")
     */
    function setForwardResolution(string memory name) external onlyOwner {
        _setForwardResolution(name);
    }

    /**
     * @notice Update the primary (reverse) name: address(this) → name.base.eth.
     * @dev Use when the name is already registered and owned by this contract.
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
