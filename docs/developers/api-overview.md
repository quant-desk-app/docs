---
title: "QuantDesk API overview and integration funnel"
description: "Integration guidance for the QuantDesk V2 backend gateway with Swagger as schema truth, base URLs, retry posture, and the recommended developer funnel."
---

# API overview

Integration guidance for the QuantDesk backend gateway. **Field-level truth lives in Swagger/OpenAPI**, not in Markdown tables here.

## Developer funnel

Follow this order once your gateway is running:

1. [Developer quickstart](./quickstart) — health check, Swagger, first `curl`
2. [Authentication](./authentication) — how browser vs API credentials fit together
3. Swagger UI at `/api/docs/` on your API host — every path, parameter, and schema

## Principles

- **Swagger / OpenAPI** — canonical for HTTP contracts (`GET /api/docs/swagger` for the JSON document).
- **This docs site** — narratives, safety notes, and copy-paste quickstarts only.
- **No duplicate schemas** — if Swagger changes, Markdown should still read correctly.

## Base URL

Set `QD_API` to your gateway origin when running the stack yourself. All production and devnet endpoints are served under the **V2** namespace:

- **V2 API:** `https://api.quantdesk.app/api/v2/`
- **Legacy V1:** `https://api.quantdesk.app/api/v1/` (Deprecated)

Paths are generally prefixed with `/api/v2` (see Swagger `servers`).

## Errors and resilience

- Prefer retries with backoff on **503** and transient network failures.
- Respect **rate limits** when documented on the route or in middleware responses.
- Log correlation IDs if your deployment exposes them.

## Related

- [Developer quickstart](./quickstart)
- [Building on QuantDesk](./building-on-quantdesk)
- [V2 API endpoints](./api-v2)
- [Authentication](./authentication)
- [WebSockets overview](./websocket-overview)
- [Errors and rate limits](./errors-and-rate-limits)
- [Security and trust](../security/overview)
