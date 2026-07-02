---
title: "Authentication: wallet SIWS and API bearer tokens"
sidebarTitle: "Authentication"
description: "How QuantDesk separates browser wallet sign-in with SIWS from programmatic API access using bearer tokens, with Swagger as the per-route auth source of truth."
---

# Authentication

QuantDesk separates **human sign-in** (wallet + SIWS in the app) from **programmatic API access** where enabled.

## Browser and app users

<Steps>
  <Step title="Connect your wallet">
    Use a Solana-compatible wallet supported by the QuantDesk web app.
  </Step>

  <Step title="Complete Sign-In With Solana (SIWS)">
  Sign the challenge in the app to prove wallet ownership. Session handling after verification follows backend policies (for example HTTP-only cookies).
  </Step>

  <Step title="Confirm session for your deployment">
    Cookie names and lifetimes are implementation details — confirm against your deployment and Swagger for any cookie-based routes.
  </Step>
</Steps>

## API clients

<Steps>
  <Step title="Check Swagger for the route">
    Many routes require an authenticated context. Swagger shows whether **Bearer JWT** is required in `Authorization` or whether cookies from an authenticated browser session are expected.
  </Step>

  <Step title="Attach the bearer token">
    ```http
    Authorization: Bearer <your_access_token>
    ```

    Obtain tokens only through supported login flows documented for your environment; do not embed secrets in client-side code.
  </Step>

  <Step title="Treat Swagger as authoritative">
    This page describes the model; Swagger describes the exact contract for each endpoint.
  </Step>
</Steps>

## Related

<CardGroup cols={2}>
  <Card title="Developer quickstart" icon="rocket" href="/docs/developers/quickstart">
    Health check, Swagger, and first curl.
  </Card>
  <Card title="API overview" icon="plug" href="/docs/developers/api-overview">
    Endpoint map and integration patterns.
  </Card>
</CardGroup>
