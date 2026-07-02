---
title: "V2 API endpoints (narrative reference)"
description: "Narrative guide to QuantDesk /api/v2 routes for portfolio state, orderbook depth, social leaderboard, and referral validation — with Swagger as schema truth."
---

# V2 API endpoints

QuantDesk's backend gateway exposes a **V2 namespace** for aggregated on-chain state and social surfaces. Field-level request and response shapes live in **Swagger** (`/api/docs/`); this page explains what each route is for and how to use it safely.

## Base path

| Environment | Base URL |
| --- | --- |
| Local dev | `http://localhost:3002/api/v2` |
| Production | `https://api.quantdesk.app/api/v2` |

Legacy `/api/v1` routes are deprecated for new integrations.

## Authentication

| Route group | Auth required |
| --- | --- |
| `/portfolio/*` | Yes — wallet session or Bearer token (see [Authentication](./authentication)) |
| `/referrals/validate` | Yes |
| `/markets/orderbook/:market` | No |
| `/leaderboard` | No |

## Portfolio (unified state)

These routes return portfolio state aggregated by the backend gateway (indexed from on-chain `PortfolioAccount` data). For lowest latency, parse the account buffer directly via RPC.

### `GET /api/v2/portfolio`

Returns the full unified portfolio: balances, positions, and open orders in one payload.

```bash
curl -s -H "Authorization: Bearer $QD_TOKEN" \
  "$QD_API/api/v2/portfolio" | jq .
```

**Common response codes**

| Code | Meaning |
| --- | --- |
| `200` | Portfolio found |
| `404` | `PORTFOLIO_NOT_FOUND` — wallet has not initialized a V2 portfolio yet |
| `401` | Missing or expired auth |

### `GET /api/v2/portfolio/positions`

Positions slice only — useful when you already cache balances elsewhere.

### `GET /api/v2/portfolio/orders`

Open orders slice only — pairs well with the orderbook route for depth context.

> [!TIP]
> For sub-millisecond on-chain reads, parse the `PortfolioAccount` buffer directly. See [Parsing the PortfolioAccount buffer](./portfolio-parsing).

## Markets (crankless orderbook)

### `GET /api/v2/markets/orderbook/:market`

Returns global BST depth for a market symbol (for example `SOL-PERP`).

```bash
curl -s "$QD_API/api/v2/markets/orderbook/SOL-PERP" | jq .
```

**Response shape (conceptual)**

| Field | Meaning |
| --- | --- |
| `success` | Request succeeded |
| `source` | `redis` (hot path) or `supabase` (fallback snapshot) |
| `data` | Bid/ask levels from the on-chain slab monitor |

The gateway tries **Redis first** for sub-millisecond delivery, then falls back to the `market_orderbooks` table if the cache is cold.

## Markets (registry SSOT)

Epic 14 adds registry-driven market discovery. Symbols, oracle feeds, leverage caps, and session rules come from one SSOT — not scattered env keys.

| Route | Purpose |
| --- | --- |
| `GET /markets` | List/filter by `asset_class` (`crypto`, `index`, …) |
| `GET /markets/asset-classes` | Per-class counts for terminal tabs |
| `GET /markets/:symbol` | Single market metadata |
| `GET /markets/leverage-tiers` | Asset-class leverage caps |
| `GET /markets/resolve/:symbol` | Ticker → registry symbol |
| `GET /markets/registry/:symbol` | Full registry row |

See [Perpetual market coverage](../trading/perp-market-coverage).

## Backtest & Elena

Epic 12 exposes the backtest lifecycle under `/api/v2/backtest/*`. Elena (`elena-ai/`, port 3006) proxies through `POST /api/elena/chat` — see [Elena & backtesting](./elena-backtesting).

| Route group | Purpose |
| --- | --- |
| `GET /backtest/datasets` | Dataset catalog (`dataset_id`, version) |
| `POST /backtest/runs` | Submit sim job (fees/slippage/funding required) |
| `GET /backtest/runs/:id` | Manifest + metrics (incl. DSR) |
| `POST /backtest/runs/:run_id/deploy-gate/check` | Deploy gate pass/fail |
| `POST /backtest/compliance/scan` | AST guardrail before queue |

## X stream

Epic 16 social ingest — separate from news and market data.

| Route | Purpose |
| --- | --- |
| `GET /x/feed` | Normalized posts by KOL list |
| `GET /x/alerts` | Symbol-linked alert events |
| `GET /x/context` | MIKEY/agent context cache |

See [X stream and social alerts](../social/x-stream).

## Data plane routes

Epic 15 adds backend-facing market data routes backed by the authoritative hub tables.

| Route | Purpose |
| --- | --- |
| `GET /market-stats` | Snapshot of last price, 24h change, volume, OI, and TradFi `cash_open` state |
| `GET /candles` | Historical OHLCV for a symbol and resolution |
| `GET /news` | Tagged article feed filtered by symbol or source |
| `GET /reference/perps` | Hyperliquid / Coinalyze reference context |
| `GET /data-health` | Collector freshness and stale-symbol summary |

Use these routes for UI hydration, operational tooling, and reproducible dataset workflows. For live UI refresh, pair `GET /market-stats` with the websocket event documented in [WebSockets overview](./websocket-overview).

## Social (flex cards and leaderboard)

### `GET /api/v2/leaderboard`

Ranks active Quant Vault leaders by realized P&L from `market_maker_vaults`.

Query parameters:

| Param | Default | Description |
| --- | --- | --- |
| `limit` | `10` | Page size |
| `offset` | `0` | Pagination offset |

```bash
curl -s "$QD_API/api/v2/leaderboard?limit=5" | jq '.data[] | {leader, total_pnl, strategy}'
```

Each row includes `vault_address`, `leader`, `total_pnl`, `strategy`, and `is_active`.

When a vault leader has a published flex card, the row may also include:

| Field | Meaning |
| --- | --- |
| `flex_card_id` | Link to verified flex card |
| `run_id` | Gate-verified backtest run |
| `badges` | Server-computed proof labels (see below) |

```bash
curl -s "$QD_API/api/v2/leaderboard?limit=5" | jq '.data[] | {leader, total_pnl, badges, flex_card_id}'
```

Rows **without** flex linkage omit `badges` — rank alone is not verification.

### Flex cards

Publish and read gate-verified backtest proof cards.

| Method | Path | Auth |
| --- | --- | --- |
| `POST` | `/api/v2/social/flex-cards` | Yes |
| `GET` | `/api/v2/social/flex-cards/:flex_card_id` | No |

**Publish body (conceptual)**

| Field | Required | Description |
| --- | --- | --- |
| `run_id` | Yes | Completed backtest that passed deploy gate |
| `title` | Yes | Display title (max 120 chars) |
| `description` | No | Optional blurb |

Failed gate → `403` `DEPLOY_GATE_FAILED`. Success → `201` with card payload including `badges[]`.

```bash
curl -s -X POST \
  -H "Authorization: Bearer $QD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"run_id":"RUN_UUID","title":"BTC MR — verified"}' \
  "$QD_API/api/v2/social/flex-cards" | jq .
```

**Badge meanings:** see [Proof badges glossary](../social/proof-badges) and [Verified flex charter](../social/verified-flex-charter).

## Referrals

### `POST /api/v2/referrals/validate`

Checks whether assigning a referrer would create a circular loop **before** you submit an on-chain `SetReferrer` transaction.

```bash
curl -s -X POST \
  -H "Authorization: Bearer $QD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"referrerAddress": "LEADER_WALLET_PUBKEY"}' \
  "$QD_API/api/v2/referrals/validate" | jq .
```

| Field | Meaning |
| --- | --- |
| `isLoop: true` | Referral rejected — circular chain detected |
| `isLoop: false` | Safe to proceed on-chain |

## Related

- [API overview](./api-overview) — integration funnel and resilience posture
- [Building on QuantDesk](./building-on-quantdesk) — `place_order_v2` on-chain tutorial
- [Errors and rate limits](./errors-and-rate-limits) — V2 hardened program errors
- [Unified portfolio architecture](../overview/unified-portfolio) — why one PDA matters
