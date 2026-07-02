---
title: "Perpetual market coverage"
sidebarTitle: "Market coverage"
description: "QuantDesk V2 synthetic perp markets — asset classes, leverage caps, listing policy, and v1 scope boundaries. Solana-native clearing only; no CFD or MT5."
---

# Perpetual market coverage

QuantDesk routes **all** leveraged products through one on-chain V2 clearing layer (`place_order_v2` on Solana). Markets are defined in a **program-governed registry** — not deployer discretion or CeFi bridges.

## Asset classes

| Class | v1 status | Examples | Clearing |
| --- | --- | --- | --- |
| **Crypto** | Live | `BTC-PERP`, `ETH-PERP`, `SOL-PERP`, ecosystem alts | `native_v2` |
| **Index** | Pilot | `US500-PERP`, `US100-PERP` | `native_v2` |
| **TradFi equity** | API ready, **0 listings** | — | Deferred to v2 queue |
| **Commodity** | API ready, **0 listings** | — | Post-index |
| **FX** | API ready, **0 listings** | — | Deferred |

Filter markets: `GET /api/v2/markets?asset_class=index` — see [V2 API](../developers/api-v2).

## Leverage caps (v1)

| Asset class | Max leverage | Notes |
| --- | --- | --- |
| Crypto majors | Up to **100×** platform cap | Per-market registry `max_leverage` may be lower |
| Crypto alts | **10×–30×** typical | Registry row governs |
| **Index synthetics** | **50×** hard cap | US500 / US100 pilots — no broker-style 500× |

Leverage tiers API: `GET /api/v2/markets/leverage-tiers`.

## Listing policy (summary)

New markets must pass a **checklist** before registry write and on-chain `initialize_market_v2`:

1. **Oracle tier** approved for the asset class (`pyth_index_a` for index pilots).
2. **OI cap** and **max leverage** set from risk review.
3. **Session rules** documented (`continuous_24_7` crypto; `pyth_futures_continuous` for index off-hours).
4. **Multisig / Security Council** sign-off for TradFi pilots (v1 governance).
5. **No prelaunch or self-referential oracle** for TradFi rows.

`listing_status` values: `pilot` (limited), `production` (GA), `halted`, `deprecated`.

## Synthetic perp disclaimer

Index products (`US500-PERP`, `US100-PERP`) are **synthetic perpetuals** margined and settled on Solana. They track **oracle marks** — v1 pilots use **Pyth SPY/QQQ equity proxies**; E-mini continuous feeds are a follow-on upgrade.

- **Cash session:** Marks may align with US cash RTH when open.
- **Off-hours:** Marks use Pyth 24/7 futures continuous feeds per registry `off_hours_policy`.
- **Telemetry:** Pro terminal shows `CASH OPEN` or `CASH CLOSED — ORACLE MARK` on TradFi perps.

This is not securities brokerage, stock trading, or CFD execution.

## v1 scope boundaries

### In Epic 14 v1

- Crypto perps (registry backfill from seeded majors + alts)
- **US500-PERP** and **US100-PERP** index pilots only

### Explicitly out of v1

- Single-name US equities (NVDA, TSLA, …)
- Pre-IPO / private-name perps
- Commodities (e.g. gold), FX, regional singles
- HIP-3-style permissionless deployer markets

## No CFD / MT5 (permanent)

QuantDesk **never** routes perp execution through:

- CeFi CFD platforms
- MetaTrader (MT5) bridges
- Off-chain matching with synthetic on-chain claims

All fills settle through **`place_order_v2`** and the unified `PortfolioAccount` on Solana.

## Verify before release

Engineers run the Epic 14 market smoke checklist:

```bash
cd contracts && pnpm test:smoke
cd backend && pnpm test
pnpm epic14:market-smoke   # fleet API with backend running
```

## Related docs

- [Trading overview](./overview)
- [Order entry](./order-entry)
- [V2 API — markets](../developers/api-v2)
- [Unified portfolio](../overview/unified-portfolio)
