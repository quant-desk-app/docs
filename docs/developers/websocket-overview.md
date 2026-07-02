---
title: "WebSockets overview: Socket.IO streaming updates"
sidebarTitle: "WebSockets"
description: "How QuantDesk streams market, order, and position updates over Socket.IO, with connection hygiene, backoff guidance, and reconciliation tips against REST."
---

# WebSockets overview

QuantDesk’s backend exposes **real-time** updates via **Socket.IO** on the same HTTP server as the REST API (same gateway origin as your `QD_API`, whatever your deployment uses).

## Conceptual model

- The server pushes structured payloads for **market**, **order**, **position**, and related updates where enabled.  
- Clients typically connect from the web app with the Socket.IO client; programmatic clients should mirror that handshake pattern.

## Connection hygiene

1. **Reuse one connection** per session where possible; avoid reconnect storms.  
2. **Backoff on disconnect** — exponential delay with a sane maximum (for example 1s → 32s cap).  
3. **Do not treat WS as source of ledger truth** — reconcile critical state via REST or your canonical persistence path.  
4. **Authentication** — user-scoped channels may require an authenticated session or token from your login flow; confirm against Swagger and implementation.

## Relationship to HTTP API

- Prefer REST/Swagger for **commands** (place/cancel) unless an endpoint explicitly documents WS usage.  
- Use sockets for **streaming state** and UI freshness.

## Market data channels

- `market_stats_update` pushes incremental hub stat updates for symbols such as `BTC-PERP` and `US500-PERP`.
- Trade fanout is emitted separately for tape-style consumers.
- Recommended pattern: bootstrap with `GET /api/v2/market-stats`, then merge `market_stats_update` payloads as they arrive.

## Debugging locally

- Confirm REST `/health` before debugging sockets.  
- Watch browser devtools → WS frames when iterating from the frontend.

## Related

- [Developer quickstart](./quickstart)  
- [Errors and rate limits](./errors-and-rate-limits)  
- [API overview](./api-overview)  
