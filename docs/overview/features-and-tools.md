---
title: "QuantDesk features and tools capability map"
description: "Capability map across the QuantDesk trading terminal, gateway APIs, auth model, market data, and social tooling, with shipped versus roadmap status labels."
---

# Features and tools

High-level map of what QuantDesk offers. **Status** reflects how we label capability in public docs; details live in guides and Swagger where noted.

| Area | What you get | Typical status |
| --- | --- | --- |
| **Trading terminal** | Lite vs Pro layouts, order entry, order book reading, execution workflows | Shipped (ongoing refinement) |
| **Shortcuts & speed** | Keyboard-oriented workflows where enabled | Shipped |
| **Market & oracle data** | Integrated price/market context via backend and oracle paths | Shipped |
| **Backend gateway** | REST APIs, Swagger at `/api/docs/`, dev assistance routes for structure and market summary | Shipped |
| **Auth model** | Wallet + SIWS-style flows; API auth per route in Swagger | Shipped |
| **Strategy Validation** | Local SVM testnets and simulator wrappers | Shipped (via scripts and examples) |
| **Backtesting** | Dataset catalog and metrics (Sharpe, Sortino, DSR) | Shipped (via API endpoints) |
| **Unified markets** | Registry SSOT, crypto + index pilots (`US500`/`US100`) | **Shipped** (Epic 14) — [Perp market coverage](../trading/perp-market-coverage) |
| **Data plane** | Market stats, candles, news, reference feeds, collector health | **Shipped** (Epic 15) — [Data overview](../data/overview) |
| **X stream** | Social feed + alerts via `x-stream/` | **Shipped** (Epic 16) — [X stream](../social/x-stream) |
| **Social & collaboration** | Verified flex cards, proof badges, leaderboard proof fields; copy-trading direction | Flex proof **shipped** (API + in-app); vault copy flows **prototype / roadmap** — [Social](../social/overview) |
| **Security & trust** | Non-custodial posture, operational security narrative | Shipped (summary) / internal detail in repo |

## Trading

- **Lite** — fast sessions, less chrome, good for monitoring and simple execution.  
- **Pro** — multi-panel, order book and execution context for active workflows.  
- **Guides:** [Trading overview](../trading/overview), [order entry](../trading/order-entry), [order book](../trading/order-book), [shortcuts](../trading/terminal-shortcuts).

## Developers and integrators

- **Quickstart** — health, Swagger, first `curl` in [Developer quickstart](../developers/quickstart).  
- **Contracts** — OpenAPI JSON at `/api/docs/swagger` on your API host; interactive UI at `/api/docs/`.  
- **Auth** — [Authentication](../developers/authentication) + per-route requirements in Swagger.

## Trust and safety

- **Public summary:** [Security and trust](../security/overview).  
- Deep audits and runbooks stay **repository-only** unless we explicitly publish a summary.

## Social (honest)

Verified **flex cards** and server-side **proof badges** are documented as shipped where the API and in-app surfaces exist. Copy-trading and collaboration remain prototype/roadmap until labeled otherwise. Start at [Social overview](../social/overview).

## Visual tour

Placeholder screenshots and a replacement checklist: [Visual product tour](./visual-product-tour).

## How to read this site

- **Product & vision** — Overview section (this page, [What is QuantDesk](./what-is-quantdesk), [Uniques](./uniques-and-roadmap)).  
- **How-to guides** — Getting started, Trading, Developers, FAQ.  
- **Schema truth for HTTP** — always Swagger, not duplicated tables in Markdown.
