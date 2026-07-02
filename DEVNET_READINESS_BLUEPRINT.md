# QuantDesk V2: Master Devnet Readiness Blueprint

**Objective:** Completely eliminate mock data, hardcoded placeholders, and simulated states across the entire ecosystem. Ensure the Frontend, Backend, and Crank infrastructure are fully wired to the hardened V2 Smart Contracts for a high-fidelity Devnet deployment.

---

## 1. 🎨 Frontend (UI/UX) - Live Data Mapping
**Goal:** The UI must reflect 100% real on-chain state. No static JSON files or mock API responses.

### A. Unified Portfolio Parsing
*   **Action:** Deprecate all REST API calls that fetch "mock" user balances or positions.
*   **Wiring:** Connect the user's wallet via `@solana/wallet-adapter`. Fetch their `PortfolioAccount` PDA directly from the RPC.
*   **Parsing:** Use `@coral-xyz/anchor` and `bytemuck` offsets to decode the zero-copy buffer:
    *   `portfolio.balances` -> Maps to Wallet / Margin UI.
    *   `portfolio.positions` -> Maps to Active Positions table.
    *   `portfolio.orders` -> Maps to Open Orders tab.

### B. Live Orderbook (BST Slabs)
*   **Action:** Remove the simulated orderbook component.
*   **Wiring:** Subscribe to the `MarketV2` PDA via WebSocket.
*   **Parsing:** Reconstruct the Red-Black Tree (or BST) locally in JavaScript from the `bids` and `asks` slabs to render the depth chart.

### C. Live Oracles
*   **Action:** Remove hardcoded price streams.
*   **Wiring:** Integrate Pyth Network and Switchboard React SDKs to stream live Devnet prices into the charting library (e.g., TradingView Lightweight Charts). Ensure the UI displays the 100bps slippage warning for Social Trades if diverging from this live feed.

---

## 2. 🗄️ Backend / Data-Ingestion (Omni-Indexer)
**Goal:** Real-time indexing of the V2 engine for historical data, charts, and leaderboards.

### A. Event Indexing
*   **Action:** Clear the Supabase database of all mock historical data.
*   **Wiring:** Update the Yellowstone gRPC or Geyser plugin listeners to ingest the newly hardened V2 events:
    *   `LiquidationExecuted`
    *   `TradeFromQuantVault`
    *   `SettleFunding`

### B. PnL Leaderboard & Social Stats
*   **Action:** Stop generating random high-score "PnL Cards."
*   **Wiring:** 
    *   **Traders:** Aggregate realized PnL from historical trades and live `unrealized_pnl` from `PortfolioAccount`.
    *   **Quant Hub Leaders:** Index the `MarketMakerVault.total_pnl` field directly for the Social Trading leaderboard.

### C. Referral Tracking
*   **Action:** Remove mock affiliate dashboards.
*   **Wiring:** Track the `SetReferrer` instructions and index the mandatory `referrer_account` relationships. Calculate rebates dynamically based on the 5% formula defined in `order_management.rs`.

---

## 3. 🤖 Bots & Crank (Operations)
**Goal:** Automated edge-case settlement using live network conditions.

### A. Conditional Orders & Liquidations
*   **Action:** Remove "dry-run" mock intervals.
*   **Wiring:** The bot must actively poll `PortfolioAccount` PDAs for `status == Pending` orders and trigger `execute_conditional_order` when live oracle prices cross the threshold.
*   **Safety:** Bots must handle the `PriceStale` error gracefully, retrying when the Oracle health status returns to `Healthy` (&lt;20s).

---

## 🚀 Devnet Transition Checklist
- [ ] **Contracts:** Deploy hardened SBF program to Solana Devnet.
- [ ] **Frontend:** Confirm 0 mock files in `/src/data/` or `/src/mocks/`. All data flows from RPC/WebSocket.
- [ ] **Backend:** Flush Supabase DB. Begin indexing from the Devnet deployment block height.
- [ ] **Social:** Verify a user can create a Vault, another user can deposit real Devnet SOL, and the leader can trade it (within the 100bps slippage band).

*Prepared by Codex-Alpha (Security Lead)*
