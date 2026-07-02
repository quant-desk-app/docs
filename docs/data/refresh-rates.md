---
title: "Refresh rates and SLOs"
description: "Expected update cadence, websocket behavior, and stale-data thresholds for QuantDesk data surfaces."
---

# Refresh rates and SLOs

QuantDesk treats the Postgres hub as the canonical cache boundary. APIs read the latest written state, and websockets fan out incremental updates as they arrive.

## Expected cadences

| Surface | Typical cadence | Notes |
| --- | --- | --- |
| `market-stats` hub row | Event-driven, usually sub-30s | Updated by mark, trade, OI, and funding writers |
| `candles` | 1m base writes with rollups | Higher resolutions are rolled up on read |
| `trade` fanout | Near real-time | Derived from `place_order_v2` fills |
| `news` | Poll-driven | Depends on RSS / API provider cadence |
| `reference/perps` | ~15s default | Configurable collector interval |
| `data-health` | Snapshot at request time | Summarizes collector freshness |

## Staleness thresholds

| Asset class | Default threshold | Why |
| --- | --- | --- |
| Crypto | `30s` | 24/7 market; prolonged silence is suspicious |
| TradFi index synthetics | Configurable, session-aware | Off-hours behavior follows market session policy |

When a symbol exceeds its freshness threshold, `/api/v2/data-health` reports it as stale instead of hiding the condition. For TradFi index synthetics, stale evaluation is session-aware: off-hours `US500-PERP` / `US100-PERP` rows are not flagged stale by age alone when the cash session is closed.

## Client pattern

1. Load a snapshot with REST.
2. Subscribe to `market_stats_update` over Socket.IO.
3. Reconcile on reconnect by refetching the REST snapshot.

That model avoids using websockets as ledger truth while still keeping the UI current.

## Operational notes

- Collectors write heartbeats into `hub_collector_status`.
- Backend health summaries aggregate collector status plus latest market-stat timestamps.
- Dataset exports capture `storage_format`, `storage_path`, `checksum_sha256`, row count, and export timestamp for reproducibility.

## Related

- [Data plane overview](./overview)
- [WebSockets overview](../developers/websocket-overview)
- [Errors and rate limits](../developers/errors-and-rate-limits)
