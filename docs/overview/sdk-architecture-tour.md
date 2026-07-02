---
title: "SDK architecture tour: what's in the public repo"
description: "A guided tour of the public QuantDesk SDK repository — the idl/, scripts/, typescript/, and examples/ directories — so you know exactly what each part is for before you build."
---

# SDK architecture tour

The public [`quant-desk-app/quantdesk-sdk`](https://github.com/quant-desk-app/quantdesk-sdk) repository is the developer-facing surface of QuantDesk: the on-chain interface, a typed client, and copy-paste examples. It is intentionally **sterile** — it contains what you need to integrate, and nothing about how the platform is operated internally.

This page walks the top-level tree so you know what you are looking at.

## Repository layout

```text
quantdesk-sdk/
├── idl/          # On-chain program interface (Anchor IDL)
├── typescript/   # Typed client library (@quantdesk/sdk)
├── examples/     # Runnable integration samples
├── scripts/      # Local environment setup helpers
└── README.md     # Start here
```

## `idl/` — the on-chain contract

The **Interface Definition Language** files describe the QuantDesk perpetuals program: its instructions, accounts, and types. They are the source of truth for anything that talks to the program directly on Solana.

| File | Purpose |
| --- | --- |
| `quantdesk_perp_dex.json` | Machine-readable IDL for codegen and Anchor clients |
| `quantdesk_perp_dex.ts` | Typed TypeScript export of the same IDL |

Use these to build and decode transactions, or to generate your own bindings in another language.

## `typescript/` — the client library

The published SDK package (`@quantdesk/sdk`) lives here. It wraps the IDL, REST gateway, and websocket streams behind a typed client.

| Path | Purpose |
| --- | --- |
| `src/client.ts` | Main client entrypoint |
| `src/types.ts` | Shared request/response and account types |
| `src/errors.ts` | Typed error classes mapped to program/API errors |
| `src/idl.json` | Bundled IDL used by the client |
| `utils/` | Helpers (including security utilities) |
| `tests/` | SDK unit and example test runners |
| `dist/` | Compiled output shipped to npm |

Install it directly:

```bash
pnpm add @quantdesk/sdk
```

## `examples/` — runnable integrations

Self-contained samples grouped by task. Each subdirectory has its own `README.md` and works out of the box.

| Directory | What it shows |
| --- | --- |
| `devnet-testing/` | Service health checks, wallet funding, and program interaction on Solana devnet |
| `api-integration/` | Calling the public REST gateway for market data and monitoring |
| `typescript/` | Typed order flows — basic trading and advanced orders |
| `ai-integration/` | Feeding portfolio and sentiment context into your own agents |

Standalone files at the root of `examples/` (for example `basic-trading-demo.js` and `community-trading-bot.ts`) are quick, single-file starting points.

## `scripts/` — environment setup

Convenience scripts for standing up a local development environment (SVM testing, WSL setup, and analysis prep). They are optional — you do not need them to consume the published package, only to hack on the repo itself.

## Where to go next

- [Developer quickstart](../developers/quickstart) — health check, Swagger, first `curl`
- [Building on QuantDesk](../developers/building-on-quantdesk) — `place_order_v2` on-chain tutorial
- [Contributing](../developers/submit-strategy-example) — submit your own strategy examples
