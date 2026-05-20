# Counter Contract Deployment

## Base Mainnet

- **Contract Address:** `0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb`
- **Deploy TX:** `0x111d9de07b2e5868d6fa302cebf69ac4e6e644fb8bee561e519380e5882281d6`
- **Owner:** `0x653Ff253b0c7C1cc52f484e891b71f9f1F010Bfb`
- **Basescan:** https://basescan.org/address/0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb

## Interact

```bash
# Read count
cast call 0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb "getCount()(uint256)" --rpc-url https://mainnet.base.org

# Increment (anyone can call)
cast send 0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb "increment()" --rpc-url https://mainnet.base.org --private-key <your-key>

# Check basename price for 1 year (owner only can register)
cast call 0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb "getBasenamePrice(string,uint256)(uint256)" "counter" "31536000" --rpc-url https://mainnet.base.org
```
