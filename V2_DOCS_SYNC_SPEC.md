# QuantDesk V2: Documentation (Mintlify) Sync Spec

**Objective:** Synchronize public-facing documentation with the hardened V2 architecture.

---

## 📝 1. Content Updates

### A. Core Concepts
- **Unified Portfolios:** Explain how zero-copy PDAs enable sub-ms execution.
- **Crankless BST Matching:** Detail the shift from V1 high-latency matching to V2 atomic matching.
- **Social Layer:** Document the 100bps slippage bands and authorized vault leader roles.

### B. Technical Guides
- **Integration Guide:** Provide code snippets for parsing the `PortfolioAccount` buffer in TypeScript and Python.
- **Error Codes:** Add the new hardened error codes (`SlippageExceeded`, `PriceStale`, `InvalidOraclePrice`).

### C. API Reference
- Document the new `/api/v2/` endpoints provided by the Backend agent.

---

## 🚀 2. Action Items
1.  **Diagram Update:** Replace V1 architecture diagrams (with separate Position accounts) with the V2 Unified Model diagram.
2.  **Tutorials:** Update the "Building on QuantDesk" tutorial to use `place_order_v2`.

*Prepared by Codex-Alpha (Security Lead)*
