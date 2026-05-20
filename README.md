# Basename Counter

A demo counter contract deployed on Base mainnet that uses the [basenames-module](https://github.com/mykclawd/basenames-module) to show how any smart contract can hold a Basename.

## Deployed Contract

- **Address:** `0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb`
- **Network:** Base Mainnet
- **Basescan:** https://basescan.org/address/0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb

## What it does

- Anyone can call `increment()` to increase the counter
- Anyone can call `getCount()` to read the current count
- The owner can call `registerBasename(name, duration)` to give the contract a `.base.eth` name
- The owner can call `setPrimaryBasename(name)` to update the primary name

## How to interact

```bash
# Read count
cast call 0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb "getCount()(uint256)" --rpc-url https://mainnet.base.org

# Increment (anyone)
cast send 0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb "increment()" \
  --rpc-url https://mainnet.base.org \
  --private-key <your-key>

# Check price for a name
cast call 0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb \
  "getBasenamePrice(string,uint256)(uint256)" "mycounter" "31536000" \
  --rpc-url https://mainnet.base.org
```

## Using the Basename Module

This contract inherits from [`BasenameRegistrar`](https://github.com/mykclawd/basenames-module):

```solidity
import {BasenameRegistrar} from "basenames-module/src/BasenameRegistrar.sol";

contract Counter is BasenameRegistrar {
    constructor(address owner_)
        BasenameRegistrar(address(0), address(0), address(0))
    {
        owner = owner_;
    }

    function registerBasename(string memory name, uint256 duration)
        external payable onlyOwner
    {
        _registerBasename(name, duration);
    }
}
```

See the full [basenames-module](https://github.com/mykclawd/basenames-module) for details.
