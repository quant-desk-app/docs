---
title: "Start trading on QuantDesk in 5 minutes locally"
description: "Quick local setup for QuantDesk: clone the repo, install dependencies, start frontend, backend, and AI services, connect a wallet, and trade on devnet."
---

# Start in 5 minutes

Spin up QuantDesk locally and get to a safe first workflow quickly.

## Setup

```bash
git clone https://github.com/dextrorsal/quantdesk.git
cd quantdesk
pnpm install
pnpm run dev
```

## Service ports

| Service | Port |
| --- | --- |
| Frontend | 3001 |
| Backend API | 3002 |
| MIKEY-AI | 3000 |
| Data ingestion | 3003 |

## First session

1. Open `http://localhost:3001`
2. Connect a supported Solana wallet
3. Stay on devnet while testing
4. Review trading pages before placing larger size

## Wallet and network pitfalls

- **Wrong cluster** — If the wallet is on mainnet but the app expects devnet (or the reverse), signing will fail. Align wallet cluster with your session.  
- **Expired session** — Reconnect wallet or refresh if API calls start returning 401.  
- **Local API down** — Frontend may load while [`/health`](http://localhost:3002/health) fails; fix backend first.

More: [Wallet and network FAQ](../faq/wallet-and-network).
