---
title: "QuantDesk API reference"
sidebarTitle: "Introduction"
description: "Interactive reference for the QuantDesk REST gateway — authenticate, browse endpoints by capability, and try requests directly from the docs."
---

# API reference

Interactive reference for the QuantDesk REST gateway. Every endpoint on this tab is generated from the OpenAPI specification, so request parameters, response schemas, and the **Try it** playground stay in sync with the contract.

Prefer narrative walkthroughs? Start with the [Developer quickstart](/docs/developers/quickstart) and [API overview](/docs/developers/api-overview), then come back here for field-level detail.

## Base URL

All endpoints are served from the production gateway:

```
https://api.quantdesk.app
```

Most trading and portfolio routes live under the **V2** namespace (`/api/v2/...`). When you run the stack yourself, set `QD_API` to your own gateway origin.

## Authentication

Public read routes (markets, oracle prices, orderbook, leaderboard) require no credentials.

Authenticated routes expect a **Bearer JWT** obtained from the wallet session flow described in [Authentication](/docs/developers/authentication):

```bash
curl -s -H "Authorization: Bearer $QD_TOKEN" \
  "https://api.quantdesk.app/api/v2/portfolio" | jq .
```

In the **Try it** playground, paste your token into the `Authorization` field to run authenticated requests against your own account.

## Endpoint groups

| Group | What it covers |
| --- | --- |
| **Markets** | Registry, metadata, leverage tiers, and orderbook depth |
| **Oracle** | Pyth-sourced price feeds |
| **Portfolio** | Unified balances, positions, and open orders |
| **Data** | Market stats snapshots and historical OHLCV candles |
| **Social** | Leaderboard and verified proof (flex) cards |
| **Backtesting** | Strategy simulation lifecycle and dataset catalog |
| **Referrals** | Referral loop validation before on-chain assignment |

## Conventions

- Responses are JSON with a top-level `success` boolean and a `data` payload.
- Errors return `success: false` with `code`, `message`, and a `request_id` for correlation.
- Retry with backoff on `503` and transient network failures, and respect documented rate limits.

## Related

- [Developer quickstart](/docs/developers/quickstart)
- [Authentication](/docs/developers/authentication)
- [Errors and rate limits](/docs/developers/errors-and-rate-limits)
- [WebSockets overview](/docs/developers/websocket-overview)
