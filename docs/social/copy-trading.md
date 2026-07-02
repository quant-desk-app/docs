---
title: "Copy trading on QuantDesk: intent, risks, scope"
description: "Directional design for QuantDesk copy trading: consent-based mirroring with size caps, pause controls, and transparent slippage and latency disclosure."
---

# Copy trading

**Status:** Primarily **roadmap / prototype** — treat capabilities described here as **directional** until a release explicitly marks them **Shipped** in-app and in these docs.

## What we mean by copy trading

Following or mirroring another trader’s fills or signals with explicit consent, risk limits, and transparent mechanics — not opaque shadow trading.

## Quant Hub vault model (V2)

QuantDesk V2 social trading uses **Quant Vaults** — leader-run strategies backed by the same unified `PortfolioAccount` infrastructure as solo traders.

> [!NOTE]
> On-chain vault instructions exist in the V2 program, but end-user copy-trading flows remain **prototype / roadmap** in the app. Treat API and program details here as integrator orientation, not a shipped product guarantee.

### Roles

| Role | Responsibility |
| --- | --- |
| **Vault leader** | Initializes the vault, sets strategy parameters, and places trades via `trade_from_quant_vault`. Must maintain a minimum leader stake (5% in the current program defaults). |
| **Depositor / follower** | Deposits collateral into the vault and receives proportional shares tracked in a `VaultDepositor` account. |
| **Protocol** | Enforces the **100bps slippage band** on vault-originated trades relative to the live oracle price. |

### 100bps slippage band

Social vault trades are bound to ±100 basis points of the oracle mid. Orders outside this band fail with `SlippageExceeded` — protecting followers from leaders executing at abusive prices during volatile windows.

This invariant is documented for traders in [Protocol and fairness](../security/protocol-and-fairness) and for integrators in [Errors and rate limits](../developers/errors-and-rate-limits).

### Discovering leaders

The gateway exposes ranked leaders at `GET /api/v2/leaderboard` — see [V2 API endpoints](../developers/api-v2).

## Why it matters for QuantDesk

Active traders often learn faster when they can:

- Observe **real execution context** (not only signals)
- Apply **size and risk caps** to copied notionals
- Pause or disconnect copying instantly

## Honest scope today

- Public docs describe **intent** and **design constraints**.
- Concrete buttons, routes, and fees ship per release — watch release notes and in-app labels.

## Risks (always disclose)

- Past performance does not predict future results  
- Slippage and latency differ between leader and follower  
- Regulatory obligations vary by jurisdiction — obtain your own advice  

## Related

- [Social overview](./overview) — status model  
- [Strategy collaboration](./strategy-collaboration)  
- [Orders, risk, and fees FAQ](../faq/orders-risk-and-fees)  
