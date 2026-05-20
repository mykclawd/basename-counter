# basename-counter

A live demonstration of [basenames-module](https://github.com/mykclawd/basenames-module) — a public counter contract on Base that owns the Basename `counter.base.eth`.

## Live contract

- **Name:** [`counter.base.eth`](https://www.base.org/name/counter)
- **Address:** [`0xa31cc82CC569617DBf8de092A17204e43a4f72d1`](https://basescan.org/address/0xa31cc82cc569617dbf8de092a17204e43a4f72d1)
- **Network:** Base Mainnet
- **Interact:** [Write Contract on Basescan](https://basescan.org/address/0xa31cc82cc569617dbf8de092a17204e43a4f72d1#writeContract)

## What it does

- **Anyone** can call `increment()` to increase the counter
- **Anyone** can call `getCount()` to read the current count
- **Owner only** can call `registerBasename(name, duration)` to give the contract a `.base.eth` name
- **Owner only** can call `setPrimaryBasename(name)` to update the primary name

The owner (`0x653Ff253b0c7C1cc52f484e891b71f9f1F010Bfb`) registered `counter.base.eth` by calling `registerBasename("counter", 31536000)` with `0.001 ETH`.

## How to interact

```bash
# Read count
cast call 0xa31cc82CC569617DBf8de092A17204e43a4f72d1 \
  "getCount()(uint256)" \
  --rpc-url https://mainnet.base.org

# Increment (anyone)
cast send 0xa31cc82CC569617DBf8de092A17204e43a4f72d1 \
  "increment()" \
  --rpc-url https://mainnet.base.org \
  --private-key <your-key>
```

## How the basename module is used

This contract inherits from [`BasenameRegistrar`](https://github.com/mykclawd/basenames-module):

```solidity
import {BasenameRegistrar} from "basenames-module/src/BasenameRegistrar.sol";

contract Counter is BasenameRegistrar {
    address public owner;
    uint256 public count;

    error NotOwner();
    modifier onlyOwner() { if (msg.sender != owner) revert NotOwner(); _; }

    constructor(address owner_)
        // Pass address(0) to use Base mainnet defaults
        BasenameRegistrar(address(0), address(0), address(0))
    {
        owner = owner_;
    }

    function increment() external { count += 1; }
    function getCount() external view returns (uint256) { return count; }

    /// @notice Register a basename for this contract (owner only)
    /// @param name     The label, e.g. "counter" → counter.base.eth
    /// @param duration Seconds (minimum 31536000 = 1 year)
    function registerBasename(string memory name, uint256 duration)
        external payable onlyOwner
    {
        _registerBasename(name, duration);
        // After this call:
        // counter.base.eth → this contract address ✓
        // this contract address → counter.base.eth  ✓
    }
}
```

## Pricing

Use `getBasenamePrice(name, duration)` to check the exact cost before registering:

```bash
cast call 0xa31cc82CC569617DBf8de092A17204e43a4f72d1 \
  "getBasenamePrice(string,uint256)(uint256)" "counter" "31536000" \
  --rpc-url https://mainnet.base.org
# → 999088168608000 (≈ 0.001 ETH)
```

Any ETH sent above the price is automatically refunded.

## Build & test

```bash
forge install mykclawd/basenames-module
forge build
forge test --fork-url https://mainnet.base.org -vvv
```
