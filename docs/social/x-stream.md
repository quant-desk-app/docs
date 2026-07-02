---
title: "X stream and social alerts"
description: "How QuantDesk ingests X/Twitter posts, emits symbol-linked alerts, and exposes the feed to Lite, Pro, and MIKEY without sharing API credentials."
---

# X stream and social alerts

QuantDesk runs a dedicated **`x-stream`** service on port `3008` for X/Twitter ingestion. It is separate from both `data-ingestion` and `news-ingestion`.

## Status

- **Shipped**: dedicated `x-stream/` service, backend `/api/v2/x/*` routes, alert fanout, terminal windows, MIKEY `get_x_context`
- **Dev sample mode**: when `TWITTER_BEARER_TOKEN` is unset in non-production, env-gated sample posts (not live KOL firehose)
- **Not supported**: direct client-side X API access or frontend-held bearer tokens

## Service boundaries

| Layer | Responsibility |
| --- | --- |
| `x-stream/` | Poll or stream watched accounts, normalize posts, derive alert events |
| `backend/` | Persist recent posts/alerts, expose `/api/v2/x/*`, fan out websocket events |
| Lite / Pro / MIKEY | Read the normalized feed and alert cache only |

## Normalized post shape

Each ingested post is normalized to:

```json
{
  "post_id": "tweet-id",
  "author": "@account",
  "text": "Post body",
  "ts": "2026-06-25T12:00:00.000Z",
  "urls": [],
  "entity_tags": ["SOL", "JUP"],
  "linked_symbols": ["SOL-PERP", "JUP-PERP"],
  "lists": ["solana_ecosystem"],
  "url": "https://x.com/..."
}
```

The service publishes raw normalized events to `x.posts.raw` and stores recent history in the `x_posts` table.

## Alert types

QuantDesk currently emits separate alert events to `x.alerts.raw` and stores them in the `x_alerts` table.

| Alert type | Trigger | Typical use |
| --- | --- | --- |
| `account_post` | A tracked account posts | Breaking headline awareness |
| `keyword` | Watch keywords match | Macro, policy, or protocol watchlists |
| `symbol_mention` | A mapped market symbol is mentioned | Jump from social context to chart / market |

Each alert includes `severity`, `linked_symbols`, `lists`, and the original `post_url`.

## Public read paths

| Surface | Route / event |
| --- | --- |
| Feed snapshot | `GET /api/v2/x/feed` |
| Alerts snapshot | `GET /api/v2/x/alerts` |
| MIKEY / agent context | `GET /api/v2/x/context` and backend `get_x_context` tool |
| Correlated UI timeline | Client-side merge of `GET /api/v2/news` and `GET /api/v2/x/feed` |
| Compatibility timeline | `GET /api/v2/x/timeline` (legacy compatibility only) |
| Push updates | Socket.IO `x_post` and `x_alert` via dedicated X feed / alert subscriptions |
| Service health | `GET http://localhost:3008/health` |

## API usage and ToS posture

- QuantDesk treats X as a **licensed upstream** with rate and ToS limits.
- Frontend clients and MIKEY do **not** call X directly.
- `TWITTER_BEARER_TOKEN` is owned by `x-stream` only.
- Development mode may serve env-gated sample posts when no bearer token is configured.

## Related

- [Social overview](./overview)
- [Data plane overview](../data/overview)
- [Websocket overview](../developers/websocket-overview)
