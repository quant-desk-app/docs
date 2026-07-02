---
title: "Start trading on QuantDesk in 5 minutes locally"
sidebarTitle: "Start in 5 minutes"
description: "Quick local setup for QuantDesk: clone the repo, install dependencies, start frontend, backend, and AI services, connect a wallet, and trade on devnet."
---

# Start in 5 minutes

Spin up QuantDesk locally and get to a safe first workflow quickly.

<Steps>
  <Step title="Clone and install">
    ```bash
    git clone https://github.com/quant-desk-app/quantdesk-sdk.git
    cd quantdesk-sdk
    pnpm install
    ```
  </Step>

  <Step title="Start the stack">
    ```bash
    pnpm run dev
    ```

    Follow the SDK README for any environment variables your local gateway needs.
  </Step>

  <Step title="Configure your client">
    Set up your local client environment following the instructions in the SDK README.
  </Step>

  <Step title="Connect a wallet">
    Connect a supported Solana wallet and stay on **devnet** while testing.
  </Step>

  <Step title="Place a safe first trade">
    Review trading parameters before placing larger size. Start with small size until you confirm cluster, wallet, and market state match your intent.
  </Step>
</Steps>

## Wallet and network pitfalls

<Warning>
  **Wrong cluster** — If the wallet is on mainnet but the app expects devnet (or the reverse), signing will fail. Align wallet cluster with your session.
</Warning>

<Tip>
  **Expired session** — Reconnect wallet or refresh if API calls start returning 401.
</Tip>

More: [Wallet and network FAQ](../faq/wallet-and-network).
