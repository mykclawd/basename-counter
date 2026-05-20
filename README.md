# basename-counter

A live demonstration of [basenames-module](https://github.com/mykclawd/basenames-module) — a public counter contract on Base that owns the Basename `numbercounter.base.eth`.

## Live contract

- **Name:** [`numbercounter.base.eth`](https://www.base.org/name/numbercounter)
- **Address:** [`0x8e8d7bb8Ad939CaBA20dCA419A633CEb9263F36f`](https://basescan.org/address/0x8e8d7bb8ad939caba20dca419a633ceb9263f36f)
- **Network:** Base Mainnet
- **Interact:** [Write Contract on Basescan](https://basescan.org/address/0x8e8d7bb8ad939caba20dca419a633ceb9263f36f#writeContract)

## What it does

- **Anyone** can call `increment()` to increase the counter
- **Anyone** can call `getCount()` to read the current count
- **Owner only** can call `registerBasename(name, duration)` to register a `.base.eth` name
- **Owner only** can call `setForwardResolution(name)` to set the forward addr record
- **Owner only** can call `setPrimaryBasename(name)` to update the reverse record

## How to register a basename (two steps)

```bash
# Check price first
cast call 0x8e8d7bb8Ad939CaBA20dCA419A633CEb9263F36f \
  "getBasenamePrice(string,uint256)(uint256)" "myname" "31536000" \
  --rpc-url https://mainnet.base.org

# Step 1: Register (sets reverse record: address → myname.base.eth)
cast send 0x8e8d7bb8Ad939CaBA20dCA419A633CEb9263F36f \
  "registerBasename(string,uint256)" "myname" "31536000" \
  --value 0.001ether \
  --rpc-url https://mainnet.base.org \
  --private-key <owner-key>

# Step 2: Set forward resolution (sets: myname.base.eth → address)
cast send 0x8e8d7bb8Ad939CaBA20dCA419A633CEb9263F36f \
  "setForwardResolution(string)" "myname" \
  --rpc-url https://mainnet.base.org \
  --private-key <owner-key>
```

Both steps use accurate gas estimates — no manual gas limit required.

## Why two steps?

Combining registration and the resolver write in one transaction causes wallet gas estimators (MetaMask etc.) to under-estimate gas. Splitting them keeps each tx simple and gas-estimable without any special settings.

## Source

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {BasenameRegistrar} from "basenames-module/src/BasenameRegistrar.sol";

contract Counter is BasenameRegistrar {
    address public owner;
    uint256 public count;

    error NotOwner();
    modifier onlyOwner() { if (msg.sender != owner) revert NotOwner(); _; }

    constructor(address owner_)
        BasenameRegistrar(address(0), address(0), address(0))
    {
        owner = owner_;
    }

    function increment() external { count += 1; }
    function getCount() external view returns (uint256) { return count; }

    /// @notice Step 1: Register basename (owner, send ETH)
    function registerBasename(string memory name, uint256 duration)
        external payable onlyOwner
    {
        _registerBasename(name, duration);
    }

    /// @notice Step 2: Set forward addr record (owner, no ETH)
    function setForwardResolution(string memory name) external onlyOwner {
        _setForwardResolution(name);
    }
}
```

## Build & test

```bash
forge install mykclawd/basenames-module
forge build
forge test --fork-url https://mainnet.base.org -vvv
```
