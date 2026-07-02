---
title: "Proof badges glossary (BACKTEST_VERIFIED · LIVE_TRACKED)"
sidebarTitle: "Proof badges"
description: "Server-verified badge definitions for flex cards and the strategy leaderboard — what each label means and what it does not imply."
---

# Proof badges glossary

QuantDesk uses a small, **server-verified** badge vocabulary for social proof. Badges are returned in JSON (`badges: string[]`) from the backend; clients must not invent badges locally.

## `BACKTEST_VERIFIED`

**What it means**

- The row or flex card is linked to a `run_id` with a published flex card.
- That run **passed the deploy gate** when the card was created (minimum trades, OOS Sharpe floor, drawdown ceiling, cost model, non-weak statistics).

**What it does not mean**

- Future profitability or “approved strategy” status
- Live execution quality or slippage on mainnet
- That the publisher will continue trading the same parameters

**Typical surfaces:** flex card header, leaderboard row (when `flex_card_id` present).

## `LIVE_TRACKED`

**What it means**

- In addition to `BACKTEST_VERIFIED`, the publisher wallet appears on **vault leaderboard infrastructure** with an active vault and **non-zero tracked `total_pnl`** at query time.

**What it does not mean**

- That live PnL was caused by the backtested strategy alone
- That backtest and live periods are comparable without your own analysis
- Paper or simulated deploy modes unless explicitly labeled elsewhere

**Typical surfaces:** flex card and leaderboard when both backtest proof and live vault tracking apply.

## Absence of badges

If `badges` is omitted or empty:

- **Do not** show “verified” or trust chrome in UI
- Leaderboard rank alone is **not** verification
- Screenshots and third-party claims are **not** substitutes

## Badge computation (integrators)

Logic is centralized in the backend (`proofBadgeService`):

1. No flex-card linkage → `badges: []` (leaderboard base rows)
2. Flex card exists → at minimum `["BACKTEST_VERIFIED"]`
3. Active vault with non-zero `total_pnl` for publisher → append `LIVE_TRACKED`

Re-fetch leaderboard or flex card endpoints for current badge state; do not cache badges across unrelated wallets.

## Related

- [Verified flex charter](./verified-flex-charter)
- [V2 API — Social](../developers/api-v2#social-flex-cards-and-leaderboard)
