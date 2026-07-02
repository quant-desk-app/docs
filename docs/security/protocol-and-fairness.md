---
title: "Protocol fairness, oracle health, and V2 invariants"
sidebarTitle: "Protocol fairness"
description: "Public trust layer for QuantDesk V2 covering non-custodial signing, oracle health checks, the 100bps social slippage band, and fair execution posture."
---

# Protocol and fairness (public layer)

This page is the **short public trust layer** for QuantDesk — enough context for traders and integrators without exposing sensitive implementation detail.

## Non-custodial stance

- You connect your wallet; **signing stays in the wallet** for supported flows.  
- Backend services coordinate sessions and permissions according to deployment policies — see [Authentication](../developers/authentication) and Swagger for specifics.

## Markets and prices

- Tradable symbols and displayed prices depend on **oracle and gateway configuration** for your environment (e.g. devnet vs production).  
- Docs describe behavior at a **high level**; engineers extend via Swagger and repository references where appropriate.

## Fair execution posture

QuantDesk aims for:

- Clear presentation of **fees, spreads, and liquidation dynamics** relevant to you  
- Honest docs when behavior is **still evolving** (label prototype vs shipped)

## Hardened security invariants

V2 introduces strict on-chain invariants to protect users and the protocol:

- **100bps social slippage band:** to prevent social trade abuse, trades originating from Quant Vaults (social trading) are bound by a 100bps slippage band relative to the live oracle price. The program rejects trades that exceed this band.
- **Oracle health requirement:** liquidations and conditional orders only execute when the relevant oracle status is **"healthy"** (last update under 20 seconds). If an oracle becomes stale, the protocol enters a safety-halt state for that market until fresh price data is available.

## What we do not publish here

- Full on-chain instruction matrices or custody internals — repository / audits as applicable  
- Penetration-test artifacts — internal distribution  

## Related

- [Fees and fairness](./fees-and-fairness)  
- [Security overview](./overview)  
- [What is QuantDesk](../overview/what-is-quantdesk)  
