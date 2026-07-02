---
title: "Building on QuantDesk: place_order_v2 tutorial"
description: "Step-by-step integrator guide for V2 atomic trading with place_order_v2, MarketSeat claims, and PortfolioAccount prerequisites."
---

# Building on QuantDesk

This tutorial walks through the **V2 crankless execution path** using `place_order_v2` — the atomic entry point for all trades on QuantDesk V2.

## Prerequisites

1. Complete the [Developer quickstart](./quickstart) — gateway health and Swagger access.
2. A funded Solana wallet on your target cluster (devnet or mainnet).
3. An initialized `PortfolioAccount` and an active `MarketSeat` for your target market.

> [!NOTE]
> Limit-order makers must **claim a seat** before placing orders. This spam-protection gate is enforced on-chain.

## Step-by-step flow

### 1. Initialize your portfolio

Every trader needs a `PortfolioAccount` PDA before placing orders. Pass `subaccount_index` (usually `0`) and a `referrer` pubkey (`PublicKey.default` if none).

```typescript
const subaccountIndex = 0;

const [portfolioPDA] = PublicKey.findProgramAddressSync(
  [
    Buffer.from("portfolio"),
    user.publicKey.toBuffer(),
    Buffer.from([subaccountIndex & 0xff, (subaccountIndex >> 8) & 0xff]),
  ],
  program.programId
);

await program.methods
  .initializePortfolio(subaccountIndex, PublicKey.default)
  .accounts({
    portfolio: portfolioPDA,
    user: user.publicKey,
    relayer: user.publicKey, // or a gasless relayer signer
    systemProgram: SystemProgram.programId,
  })
  .signers([user])
  .rpc();
```

If this account already exists for the wallet + subaccount pair, skip to seat claim. Confirm via RPC or `GET /api/v2/portfolio` after indexing.

### 2. Claim a market seat

```typescript
const [seatPDA] = PublicKey.findProgramAddressSync(
  [Buffer.from("seat"), marketV2PDA.toBuffer(), user.publicKey.toBuffer()],
  program.programId
);

await program.methods
  .claimSeat()
  .accounts({
    seat: seatPDA,
    market: marketV2PDA,
    user: user.publicKey,
  })
  .signers([user])
  .rpc();
```

### 3. Place the order

See the full TypeScript example below for `placeOrderV2` accounts (`bids`, `asks`, `jitMaker`, etc.).

## V2 execution model (30-second version)

In a single transaction, `place_order_v2`:

1. Validates oracle health and portfolio policy (including scoped session keys).
2. Attempts a JIT institutional fill window when configured.
3. Matches against the on-chain **BST slab** (bids and asks red-black trees).
4. Routes any remainder to the qLP backstop vault.

No off-chain keeper crank is required for core matching — see [Reading the order book](../trading/order-book#v2-crankless-bst-matching).

## Side encoding

On-chain, `side` is a `u8`:

| Value | Meaning |
| --- | --- |
| `1` | Bid (buy / long) |
| `2` | Ask (sell / short) |

Always confirm against the exported IDL in your environment. Client SDKs may expose friendlier enums that map to these values.

## TypeScript example (Anchor)

The following pattern mirrors our contract test suite. Adjust program ID, market PDAs, and cluster RPC for your deployment.

```typescript
import * as anchor from "@coral-xyz/anchor";
import { PublicKey, SystemProgram } from "@solana/web3.js";

// PDAs from steps 1–2 above: portfolioPDA, seatPDA

// Place order — side 1 = bid, size/price in program-native units
await program.methods
  .placeOrderV2(
    1,                        // bid
    new anchor.BN(10_000),    // size (check market lot_size)
    new anchor.BN(50_000)     // price (check market tick_size)
  )
  .accounts({
    market: marketV2PDA,
    bids: bidsPDA,
    asks: asksPDA,
    portfolio: portfolioPDA,
    seat: seatPDA,
    user: user.publicKey,
    relayer: user.publicKey,
    jitMaker: null,
    jitPortfolio: null,
  })
  .signers([user])
  .rpc();
```

### Gasless relaying

If the user wallet holds less than ~0.005 SOL, the QuantDesk frontend routes the same instruction through a **relayer** that deducts fees from `relayer_fee_balance` on the portfolio. Integrators can mirror this pattern or require users to fund SOL for fees.

## Verify execution

After submission:

1. Fetch the transaction signature on your cluster explorer.
2. Read portfolio state via RPC ([portfolio parsing](./portfolio-parsing)) or `GET /api/v2/portfolio`.
3. Compare open orders against `GET /api/v2/markets/orderbook/:market` for depth context.

## Common program errors

| Error | Typical cause |
| --- | --- |
| `PriceStale` | Oracle last update older than ~20 seconds |
| `InvalidOraclePrice` | Zero or negative oracle price |
| `SlippageExceeded` | Social vault trade outside the 100bps band |
| `PolicyViolationMarket` | Scoped session key not authorized for this market |

Full HTTP and program error guidance: [Errors and rate limits](./errors-and-rate-limits).

## Next steps

| Goal | Page |
| --- | --- |
| Decode portfolio bytes | [Portfolio parsing](./portfolio-parsing) |
| REST aggregation | [V2 API endpoints](./api-v2) |
| Social vault mechanics | [Copy trading](../social/copy-trading) |
| Terminal UX context | [Order entry](../trading/order-entry) |
