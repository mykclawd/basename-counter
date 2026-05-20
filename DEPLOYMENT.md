# Counter Contract Deployment

## Base Mainnet — v4 (current, use this one)

- **Contract Address:** `0xa31cc82CC569617DBf8de092A17204e43a4f72d1`
- **Deploy TX:** `0x356ff4993d7d9f99d7c37f67fbe6dc1752c723a8e84141d2630a9d6a1f58c101`
- **Owner:** `0x653Ff253b0c7C1cc52f484e891b71f9f1F010Bfb`
- **Sourcify:** https://sourcify.dev/#/lookup/0xa31cc82CC569617DBf8de092A17204e43a4f72d1
- **Blockscout:** https://base.blockscout.com/address/0xa31cc82CC569617DBf8de092A17204e43a4f72d1?tab=write_contract

## How to register a basename (as owner)

Send ETH with the call — the contract holds it and pays the registrar:

```bash
# Price check
cast call 0xa31cc82CC569617DBf8de092A17204e43a4f72d1 \
  "getBasenamePrice(string,uint256)(uint256)" "counter" "31536000" \
  --rpc-url https://mainnet.base.org

# Register (send slightly more than price — excess refunded)
cast send 0xa31cc82CC569617DBf8de092A17204e43a4f72d1 \
  "registerBasename(string,uint256)" "counter" "31536000" \
  --value 0.001ether \
  --rpc-url https://mainnet.base.org \
  --private-key <your-key>
```

## Previous (broken) deployments

- v1: `0x893348add4f77f0499e3bdc88f1c3c9b6b5d99cb` — old RegistrarController
- v2: `0x63B9F4bd8D7b39D5A6Dd8e61241205c13bBeB328` — wrong struct
- v3: `0xF2b7f749f9AC0c61F0a280D7eFD3dbCE41e08DB2` — wrong struct
