---
title: "Data sources"
description: "Canonical upstream sources for QuantDesk market stats, candles, trades, news, and reference context."
---

# Data sources

QuantDesk uses a **source matrix** so each data class has a documented upstream owner, normalization path, and fallback behavior.

## Source matrix

| Data class | Primary source | Ingestion service | Hub table | Public consumers |
| --- | --- | --- | --- | --- |
| Mark / tick prices | Pyth-backed collectors | `data-ingestion` | `hub_market_stats`, `hub_candles` | Heatmap, ticker tape, chart API |
| On-chain fills | QuantDesk `place_order_v2` logs | `data-ingestion` | `hub_trades`, `hub_market_stats` | Trade tape, rolling 24h volume rollups |
| OI / funding / reference marks | Coinalyze, Hyperliquid | `data-ingestion` | `hub_reference_perps` | Reference badges, operator context |
| News articles | RSS, NewsData, CryptoPanic | `news-ingestion` | `hub_news` | News panels, symbol-linked context |
| X posts and alerts | X/Twitter API or dev-mode sample feed | `x-stream` | `x_posts`, `x_alerts` | Social feed, alert list, MIKEY X context |
| Session metadata | TradFi session policy | `backend` enrichment | `hub_market_stats.cash_open` | US500 / US100 session badge |
| Dataset exports | Hub candles + catalog metadata | `scripts/data` | `backtest_datasets` | Elena backtests and reproducibility checks |

## Symbol handling

- **Registry symbols are canonical**: `BTC-PERP`, `US500-PERP`, `US100-PERP`.
- **News entity tagging** maps aliases back to registry symbols.
- **X entity tagging** maps post mentions back to registry symbols where possible.
- **Reference collectors** derive their watchlists from active registry markets where possible.

## Envelope contract

Every Redis producer publishes the Epic 15 event envelope:

```json
{
  "event_id": "uuid-v4",
  "event_type": "mark | trade | candle | oi | funding | news",
  "source": "pyth | quantdesk | hyperliquid | coinalyze | rss",
  "symbol": "BTC-PERP",
  "asset_class": "crypto | index | equity | fx | commodity",
  "ts": 1719230400,
  "ingest_ts": 1719230401,
  "payload": {}
}
```

Development builds validate the envelope contract before the event is accepted into the stream fanout path, including UUID/event-type checks, session-safe timestamps, and registry-style symbol requirements for non-news events.

## Fallback posture

- **No production UI fallback to random market data**.
- If a collector is stale, QuantDesk reports that via `/api/v2/data-health` rather than inventing metrics.
- Legacy ad hoc stream payloads are deprecated and should not be used by new producers.

## Related

- [Data plane overview](./overview)
- [Refresh rates](./refresh-rates)
