---
title: "Authentication: wallet SIWS and API bearer tokens"
sidebarTitle: "Authentication"
description: "How QuantDesk separates browser wallet sign-in with SIWS from programmatic API access using bearer tokens, with Swagger as the per-route auth source of truth."
---

# Authentication

QuantDesk separates **human sign-in** (wallet + SIWS in the app) from **programmatic API access** where enabled.

## Browser and app users

- Connect a Solana-compatible wallet and complete **Sign-In With Solana (SIWS)** in the web app.
- Session handling after verification follows backend policies (for example HTTP-only cookies). Exact cookie names and lifetimes are implementation details — confirm against your deployment and Swagger for any cookie-based routes.

## API clients

Many routes require an authenticated context. Check **Swagger** for each operation:

- Whether **Bearer JWT** is required in `Authorization`
- Whether cookies from an authenticated browser session are expected

Pattern:

```http
Authorization: Bearer <your_access_token>
```

Obtain tokens only through supported login flows documented for your environment; do not embed secrets in client-side code.

## Practical rule

**Swagger is authoritative** for which endpoints require auth and which headers to send. This page describes the model; Swagger describes the exact contract.

## Related

- [Developer quickstart](./quickstart)
- [API overview](./api-overview)
