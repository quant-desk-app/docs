---
title: "Developer quickstart: health, Swagger, first curl"
sidebarTitle: "Quickstart"
description: "Five-minute QuantDesk gateway integration: verify health, open Swagger at /api/docs, set QD_API, and make your first authenticated curl request locally."
---

# Developer quickstart

Copy-paste these steps with the backend API running and reachable.

<Info>
  Start the stack from the repo root first — see [Start in 5 minutes](../getting-started/start-trading-in-5-minutes).
</Info>

<Steps>
  <Step title="Set your API origin">
    ```bash
    export QD_API=https://api.quantdesk.app
    ```

    Point `QD_API` at your own gateway origin if you run the stack yourself (same paths under `/api`).
  </Step>

  <Step title="Verify the gateway">
    ```bash
    curl -s "$QD_API/health"
    ```

    Expect JSON indicating the service is up. If this fails, fix networking or process startup before continuing.
  </Step>

  <Step title="Open interactive API docs">
    In the browser, open:

    `$QD_API/api/docs/` — for example `https://api.quantdesk.app/api/docs/`

    Use Swagger for **request/response shapes**, parameters, and authentication requirements. This docs site stays narrative-only for HTTP fields.
  </Step>

  <Step title="Download the OpenAPI document">
    ```bash
    curl -s "$QD_API/api/docs/swagger" -o openapi.json
    jq '.info' openapi.json
    ```

    Regenerate `openapi.json` whenever you need an offline reference or codegen input.
  </Step>

  <Step title="Make your first API call">
    Development market overview (useful for integrations and debugging):

    ```bash
    curl -s "$QD_API/api/dev/market-summary" | jq .
    ```

    You should see `success` and a `data.markets` array when the database and oracle paths are healthy.
  </Step>
</Steps>

## Next steps

<CardGroup cols={2}>
  <Card title="Authentication" icon="key" href="/docs/developers/authentication">
    Secure requests with SIWS and bearer tokens.
  </Card>
  <Card title="API overview" icon="plug" href="/docs/developers/api-overview">
    Patterns, boundaries, and integration funnel.
  </Card>
  <Card title="Building on QuantDesk" icon="code" href="/docs/developers/building-on-quantdesk">
    On-chain `place_order_v2` walkthrough.
  </Card>
  <Card title="WebSockets" icon="bolt" href="/docs/developers/websocket-overview">
    Socket.IO streaming updates.
  </Card>
</CardGroup>

Do not duplicate full endpoint tables from Swagger into Markdown — link Swagger and keep examples short here.
