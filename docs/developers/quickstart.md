---
title: "Developer quickstart: health, Swagger, first curl"
sidebarTitle: "Quickstart"
description: "Five-minute QuantDesk gateway integration: verify health, open Swagger at /api/docs, set QD_API, and make your first authenticated curl request locally."
---

# Developer quickstart

Copy-paste these steps with the backend API running and reachable.

## 0) Prerequisite

Start the stack from the repo root (see [Start in 5 minutes](../getting-started/start-trading-in-5-minutes)). You need a reachable API base URL:

```bash
export QD_API=https://api.quantdesk.app
```

Point `QD_API` at your own gateway origin if you run the stack yourself (same paths under `/api`).

## 1) Verify the gateway

```bash
curl -s "$QD_API/health"
```

Expect JSON indicating the service is up. If this fails, fix networking or process startup before continuing.

## 2) Open interactive API docs (schema truth)

In the browser, open:

`$QD_API/api/docs/` — for example `https://api.quantdesk.app/api/docs/`

Use Swagger for **request/response shapes**, parameters, and authentication requirements. This docs site stays narrative-only for HTTP fields.

## 3) Download the OpenAPI document

The gateway exposes the machine-readable spec here:

```bash
curl -s "$QD_API/api/docs/swagger" -o openapi.json
```

Inspect metadata:

```bash
jq '.info' openapi.json
```

Regenerate `openapi.json` whenever you need an offline reference or codegen input.

## 4) First API call (no auth)

Development market overview (useful for integrations and debugging):

```bash
curl -s "$QD_API/api/dev/market-summary" | jq .
```

You should see `success` and a `data.markets` array when the database and oracle paths are healthy.

## 5) Next steps (Coinbase-style funnel)

| Step | Page |
| --- | --- |
| Secure requests | [Authentication](./authentication) |
| Patterns and boundaries | [API overview](./api-overview) |
| V2 route reference | [V2 API endpoints](./api-v2) |
| On-chain trading | [Building on QuantDesk](./building-on-quantdesk) |
| Streaming updates | [WebSockets overview](./websocket-overview) |
| Errors and throttling | [Errors and rate limits](./errors-and-rate-limits) |
| Terminal context | [Trading overview](../trading/overview) |

Do not duplicate full endpoint tables from Swagger into Markdown — link Swagger and keep examples short here.
