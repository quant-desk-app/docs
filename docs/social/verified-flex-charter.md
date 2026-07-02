---
title: "Verified flex cards — proof charter"
sidebarTitle: "Verified flex"
description: "How QuantDesk flex cards link gate-verified backtest runs to shareable proof, what each badge means, and honest limitations (backtest ≠ future live performance)."
---

# Verified flex charter

**Status:** **Shipped (API + in-app surfaces)** on devnet-oriented stacks with the backtest + deploy gate. Flex cards are **not** screenshot exports or marketing claims — they are immutable references to a `run_id` that passed the deploy gate at publish time.

## What a flex card is

A **flex card** is a published record that:

- Points to a single completed backtest `run_id` (immutable after publish)
- Stores a frozen **strategy summary** and **equity snapshot hash** from the run manifest
- Records the **publisher wallet** and **manifest version** (`engine_version`)
- Exposes a **deep link** (`/lite/flex/:flex_card_id`) for sharing — not an unverified image export

Flex cards exist so affiliates and strategy builders can share **credible context** without implying guaranteed future performance.

## Publish path (honest scope)

```text
Dataset → Backtest run → Deploy gate check → POST flex card → Share deep link
```

1. Run a backtest via the v2 backtest APIs until status is `completed`.
2. Call deploy gate (`POST /api/v2/backtest/runs/:run_id/deploy-gate/check`). Publishing is **blocked** if the gate fails (`403` with `DEPLOY_GATE_FAILED`).
3. Authenticated publisher calls `POST /api/v2/social/flex-cards` with `run_id`, `title`, and optional `description`.
4. Share the returned deep link or Pro/Lite flex surfaces.

> [!WARNING]
> A passing backtest gate proves the **historical simulation** met QuantDesk floors at publish time. It does **not** predict live trading results, funding regimes you have not seen, or future market structure.

## Proof badges (server-verified only)

Badges are computed **on the backend** and returned in API payloads. The UI renders badges **only** from the server `badges` array — never client-inferred.

| Badge | Meaning | When it appears |
| --- | --- | --- |
| `BACKTEST_VERIFIED` | Linked `run_id` passed deploy gate; flex card publish succeeded | Flex card exists for the wallet/row |
| `LIVE_TRACKED` | Publisher wallet has **live tracked PnL** on vault leaderboard infra (active vault, non-zero `total_pnl`) | **Additionally** to `BACKTEST_VERIFIED` when vault data confirms live tracking |

Entries **without** flex-card linkage show **no proof badges** on the leaderboard — we do not imply verification from PnL rank alone.

See [Proof badges glossary](./proof-badges) for integrator and UX detail.

## Limitations (read this before sharing)

- **Backtest ≠ live.** Simulated fills, historical oracle paths, and OOS splits do not guarantee forward performance.
- **Gate at publish time.** Metrics are frozen to the manifest version stamped on the card; re-running with different data or costs is a different `run_id`.
- **No endorsement.** QuantDesk does not endorse strategies published as flex cards; badges describe **verification mechanics**, not investment advice.
- **Devnet vs mainnet.** Confirm environment labels in-app before treating proof as production-grade.

## Where to view flex cards

| Surface | Path |
| --- | --- |
| Lite affiliate profile | **Referrals** tab → Verified Flex Cards |
| Lite deep link | `/lite/flex/:flex_card_id` |
| Pro terminal | Command `FLEX` or `FLEX <flex_card_id>` |
| Leaderboard | **Social → Verified Leaders** (badges on ranked rows with linkage) |

## API reference

| Method | Path | Auth | Purpose |
| --- | --- | --- | --- |
| `POST` | `/api/v2/social/flex-cards` | Yes | Publish after gate pass |
| `GET` | `/api/v2/social/flex-cards/:flex_card_id` | No | Read card + `badges[]` |
| `GET` | `/api/v2/leaderboard` | No | Vault PnL rank; optional `flex_card_id`, `run_id`, `badges` |

Field-level schemas: Swagger at `/api/docs/` on the backend gateway. Narrative: [V2 API — Social](../developers/api-v2#social-flex-cards-and-leaderboard).

## Related

- [Proof badges glossary](./proof-badges)
- [Social overview](./overview)
- [V2 API — flex & leaderboard](../developers/api-v2#social-flex-cards-and-leaderboard)
