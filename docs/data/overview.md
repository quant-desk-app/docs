---
title: "Data plane overview"
description: "How QuantDesk normalizes market, trade, candle, news, and reference data into one backend-facing data plane."
---

# Data plane overview

QuantDesk's market data stack is split into three layers:

1. **Collectors** ingest raw market, protocol, and article events.
2. **The data plane** normalizes those events into a shared envelope and writes authoritative hub tables.
3. **Backend APIs and websockets** expose the hub to frontend surfaces, backtesting workflows, and external clients.

## Core principles

- **Registry first**: market identity comes from the market registry, not ticker guesses.
- **One envelope**: Redis producers publish the same event shape before any downstream fanout.
- **Postgres hub**: `hub_market_stats`, `hub_candles`, `hub_trades`, `hub_news`, `hub_reference_perps`, and `hub_collector_status` are the backend source of truth.
- **REST bootstrap, websocket freshness**: clients load the latest snapshot over HTTP, then stay current with Socket.IO updates such as `market_stats_update`.

## Services

| Service | Responsibility |
| --- | --- |
| `data-ingestion/` | Market marks, candles, protocol trades, reference perps, collector health |
| `news-ingestion/` | RSS / API article ingestion and entity tagging |
| `x-stream/` | X/Twitter posts, social alerts, symbol-linked context |
| `backend/` | Public `/api/v2/*` routes and websocket fanout |

Article news ownership lives in `news-ingestion/` only; `data-ingestion/` no longer acts as the first-class article collector in the standard dev fleet.
For local end-to-end verification, the standard `pnpm dev` fleet is expected to bring up `data-ingestion`, `news-ingestion`, and `x-stream` alongside the backend/frontend services.

## Public read paths

| Surface | Route / channel | Notes |
| --- | --- | --- |
| Market stats | `GET /api/v2/market-stats` | 24h stats, OI, last price, cash session badge |
| Candles | `GET /api/v2/candles` | Historical OHLCV from the hub |
| News | `GET /api/v2/news` | Tagged articles from `hub_news` |
| X feed | `GET /api/v2/x/feed` | Normalized posts from `x-stream` |
| X alerts | `GET /api/v2/x/alerts` | Stored social alert events |
| Reference perps | `GET /api/v2/reference/perps` | Hyperliquid and Coinalyze context |
| Data health | `GET /api/v2/data-health` | Collector freshness and stale-market summary |
| Live stats | `market_stats_update` | Socket.IO event for incremental UI updates after REST bootstrap |

## Why this exists

Epic 15 removes market-facing mock data from production surfaces and gives every consumer the same canonical input set. That keeps:

- the Lite and Pro terminals aligned,
- backtest dataset exports reproducible,
- TradFi session handling explicit,
- and collector health observable.

## Related

- [Data sources](./data-sources)
- [Refresh rates](./refresh-rates)
- [X stream and social alerts](../social/x-stream)
- [WebSockets overview](../developers/websocket-overview)
- [V2 API endpoints](../developers/api-v2)
