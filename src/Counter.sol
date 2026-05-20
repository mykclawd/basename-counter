// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {BasenameRegistrar} from "basenames-module/BasenameRegistrar.sol";

/// @title Counter
/// @notice A simple public counter contract that also holds a Basename.
///         Anyone can increment the count.
///         Only the owner can register or update the contract's Basename.
/// @dev Inherits BasenameRegistrar so this contract can own a name like
///      counter.base.eth
contract Counter is BasenameRegistrar {
    // =============================================================
    //                           STORAGE
    // =============================================================

    /// @notice The owner of this contract (can manage the Basename)
    address public owner;

    /// @notice The running count — anyone can increment this
    uint256 public count;

    // =============================================================
    //                           ERRORS
    // =============================================================

    error NotOwner();

    // =============================================================
    //                           EVENTS
    // =============================================================

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

    /// @param owner_ Address that will own this contract and control the Basename
    constructor(address owner_)
        BasenameRegistrar(address(0), address(0), address(0))
    {
        owner = owner_;
        count = 0;
    }

    // =============================================================
    //                       PUBLIC FUNCTIONS
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
    //                     BASENAME FUNCTIONS
    // =============================================================

    /// @notice Register a Basename for this contract.
    /// @dev Only the owner can call this. The contract must hold enough ETH.
    ///      Query getBasenamePrice(name, duration) first to know the cost.
    /// @param name The label to register (e.g. "counter" → counter.base.eth)
    /// @param duration Registration duration in seconds (min 365 days)
    function registerBasename(string memory name, uint256 duration)
        external
        payable
        onlyOwner
    {
        _registerBasename(name, duration);
    }

    /// @notice Update the primary Basename for this contract.
    /// @dev Only the owner can call this. Name must already be owned by this contract.
    /// @param name The label or full name (e.g. "counter" or "counter.base.eth")
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
