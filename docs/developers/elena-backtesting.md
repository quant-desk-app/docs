---
title: "Elena & backtesting API"
description: "QuantDesk Elena Conductor, dataset catalog, Python sim workers, deploy gate, and StrategyCardSchema — separate from MIKEY-AI."
---

# Elena & backtesting

**Elena** is QuantDesk's dedicated **backtest lifecycle** agent. It is **not** MIKEY-AI (general protocol intelligence). Elena orchestrates dataset selection, strategy specs, simulation, walk-forward validation, and deploy gating.

## Status

| Component | Status | Notes |
| --- | --- | --- |
| `elena-ai/` service (port **3006**) | **Shipped** | Conductor + tool registry |
| `/api/v2/backtest/*` | **Shipped** | Job queue, manifests, deploy gate |
| Pro `BT` + Lite backtest flows | **Shipped** | Real APIs — no mock-only production path |
| Live LLM Conductor | **Optional** | Set LLM API key; `VITE_MOCK_ELENA=true` for UI-only dev |
| GPU optimization pool | **Optional** | CPU path default; `use_gpu: true` falls back with notice |

## Architecture

```
Browser → backend :3002 (/api/elena/chat, /api/v2/backtest/*)
              ↓
         elena-ai :3006 (Conductor tools)
              ↓
         Redis job queue → Python sim workers
              ↓
         databaseService (manifests, ledger, deploy bundles)
```

- Elena **never** re-implements sim logic — it calls backend `/api/v2/backtest/*` as a client.
- MIKEY has **no** tool that submits sim jobs directly.

## Gateway routes

| Route | Purpose |
| --- | --- |
| `POST /api/elena/chat` | Conductor chat (privacy-scrubbed proxy to Elena) |
| `GET /api/elena/health` | Elena service health via gateway |

## Backtest API (narrative)

Base: `/api/v2/backtest`. Full schemas in Swagger (`/api/docs/`).

| Route | Purpose |
| --- | --- |
| `GET /datasets` | Browse oracle-history datasets (`dataset_id`, version, resolution) |
| `POST /runs` | Submit backtest job (requires fees, slippage, funding — zero-cost rejected) |
| `GET /runs/:id` | Manifest + metrics (Sharpe, Sortino, max DD, DSR, trade count) |
| `POST /runs/:run_id/deploy-gate/check` | Pass/fail vs thresholds (min trades, OOS Sharpe, max DD) |
| `POST /runs/:run_id/deploy-bundle` | Versioned artifact for paper → live `place_order_v2` |
| `POST /compliance/scan` | AST guardrail before queue (lookahead, blocklisted imports) |
| `POST /optimize` | Parameter sweeps (optional GPU queue) |
| `POST /walk-forward` | Rolling OOS validation |

## StrategyCardSchema

Developer output emits **StrategyCardSchema** JSON — SSOT for `max_leverage`, cost model refs, and Solana friction (priority fees + slippage floor). Deploy bundles extend this schema; there is no competing parallel format.

## Deploy gate → flex publish

1. Complete backtest → `run_id`
2. `deploy-gate/check` passes (evaluates **DSR**, not raw Sharpe alone)
3. Optional paper/live deploy via scoped session keys
4. Publish flex card: `POST /api/v2/social/flex-cards` with `run_id` — see [Verified flex charter](../social/verified-flex-charter)

## Local dev

```bash
# Backend + Redis required
cd backend && pnpm run start:dev

export QUANTDESK_BACKEND_URL=http://localhost:3002
cd elena-ai && pnpm dev   # port 3006

# Optional mock Conductor UI without LLM key
# frontend/.env: VITE_MOCK_ELENA=true
```

Fleet: `bash scripts/services/start-all.sh` from repo root (full fleet; docs site not auto-started).

## Related

- [V2 API endpoints](./api-v2) — social, markets, data plane
- [Building on QuantDesk](./building-on-quantdesk) — `place_order_v2` live deploy
- [Data plane overview](../data/overview) — dataset dumps and candles
- [Verified flex charter](../social/verified-flex-charter)
