---
title: "Wallet and network FAQ: devnet, mainnet, clusters"
description: "Answers for connecting Solana wallets to QuantDesk safely, choosing devnet versus mainnet, troubleshooting loads, and matching wallet cluster to environment."
---

# Wallet and network

Quick answers for connecting wallets and choosing networks safely.

## Which wallet should I use?

Use a **supported Solana wallet** that you trust (Phantom, Solflare, etc.). QuantDesk does **not** custody keys — you remain responsible for seed phrase security.

## Devnet vs mainnet

- **Devnet** — default for local setup and experimentation; use faucets for SOL; expect resets and instability.  
- **Mainnet** — real funds and real risk; verify URLs and program IDs every session.

## I connected but nothing loads

1. Confirm backend + frontend are running (see [Start in 5 minutes](../getting-started/start-trading-in-5-minutes)).  
2. Hit API health: `curl http://localhost:3002/health` when developing locally.  
3. Try disconnect/reconnect wallet and hard refresh once.

## Wrong network in wallet

Switch your wallet’s cluster to match QuantDesk’s expectations for that URL (devnet vs mainnet-beta). Wrong cluster signatures **fail** — by design.

## Related

- [Security and trust](../security/overview)  
- [FAQ hub](./index)  
- [Developer quickstart](../developers/quickstart)  
