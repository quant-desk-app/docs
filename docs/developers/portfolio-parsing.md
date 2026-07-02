---
title: "Parsing the PortfolioAccount zero-copy buffer"
description: "How to decode the QuantDesk V2 PortfolioAccount zero-copy buffer using Anchor in TypeScript to read balances, positions, and open orders with sub-ms latency."
---

# Parsing the PortfolioAccount buffer

QuantDesk V2 uses a zero-copy architecture for the `PortfolioAccount`. This maps the raw account data directly into local memory structures, so you get high-performance reads.

**Account size:** 2,360 bytes total (8-byte Anchor discriminator + 2,352-byte `PortfolioAccount` body).

## Why zero-copy?

Standard Anchor accounts deserialize on every fetch, which is slow and CPU-intensive for large accounts with many positions. Zero-copy lets you:

- **Avoid deserialization:** read fields directly from the buffer.
- **Sub-ms latency:** critical for high-frequency trading bots.
- **Atomic state:** fetch balances, positions, and orders in a single RPC call.

---

## TypeScript integration (recommended)

Use the exported IDL with `@coral-xyz/anchor` — this is safer than hand-parsing offsets.

```typescript
import * as anchor from "@coral-xyz/anchor";

const portfolioPda = ...; // Derived PDA — see Building on QuantDesk
const accountInfo = await connection.getAccountInfo(portfolioPda);

if (accountInfo) {
  const portfolio = program.account.portfolioAccount.coder.accounts.decode(
    "PortfolioAccount",
    accountInfo.data
  );

  console.log("Collateral USD:", portfolio.totalCollateralValue.toString());
  console.log("Balances:", portfolio.balances);
  console.log("Positions:", portfolio.positions);
  console.log("Open orders:", portfolio.orders);
}
```

---

## Python integration

For Python developers, use `anchorpy` to interact with the V2 program.

```python
from anchorpy import Program
from solders.pubkey import Pubkey

async def get_portfolio(program: Program, pda: Pubkey):
    portfolio = await program.account["PortfolioAccount"].fetch(pda)
    print(f"Collateral USD: {portfolio.total_collateral_value}")
    print(f"Balances: {portfolio.balances}")
    print(f"Positions: {portfolio.positions}")
    print(f"Orders: {portfolio.orders}")
```

---

## Manual offset map

Use this only for custom parsers or debugging. Layout matches `contracts/programs/quantdesk-perp-dex/src/state/portfolio.rs` (verify against your deployed program version).

| Field | Type | Offset (bytes) | Size (bytes) |
| --- | --- | ---: | ---: |
| Discriminator | `[u8; 8]` | 0 | 8 |
| `authority` | `Pubkey` | 8 | 32 |
| `total_collateral_value` | `u64` | 40 | 8 |
| `total_borrowed_value` | `u64` | 48 | 8 |
| `unrealized_pnl` | `i64` | 56 | 8 |
| `pending_funding` | `i64` | 64 | 8 |
| `balances` | `[AssetBalance; 8]` | 72 | 320 |
| `positions` | `[InlinePosition; 10]` | 392 | 720 |
| `orders` | `[InlineOrder; 16]` | 1,112 | 1,024 |
| `referrer` | `Pubkey` | 2,136 | 32 |
| `relayer_fee_balance` | `u64` | 2,168 | 8 |
| `subaccount_index` | `u16` | 2,176 | 2 |
| `bump` | `u8` | 2,178 | 1 |
| `padding` | `[u8; 5]` | 2,179 | 5 |
| `delegate_pubkey` | `Pubkey` | 2,184 | 32 |
| `delegate_policy` | `TradingPolicy` | 2,216 | 144 |

### Nested struct sizes

| Struct | Size (bytes) | Notes |
| --- | ---: | --- |
| `AssetBalance` | 40 | `asset_type`, `amount`, `value_usd`, weights, `last_update` |
| `InlinePosition` | 72 | `market`, `side`, `size`, `entry_price`, `margin`, `last_funding_index` |
| `InlineOrder` | 64 | `market`, `side`, `order_type`, `status`, `size`, `price`, `trigger_price` |
| `TradingPolicy` | 144 | `max_leverage`, `allowed_markets[4]`, `expiry_timestamp` |

> [!TIP]
> Prefer the latest exported IDL from the [QuantDesk repository](https://github.com/dextrorsal/quantdesk) over manual offsets. Regenerate clients after program upgrades.

## Related

- [Building on QuantDesk](./building-on-quantdesk) — initialize portfolio and place orders
- [V2 API endpoints](./api-v2) — gateway read path when RPC parsing is not required
- [Unified portfolio architecture](../overview/unified-portfolio) — why one PDA matters
