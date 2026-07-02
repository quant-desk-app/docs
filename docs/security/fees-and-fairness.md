---
title: "Fees and fairness: trading, funding, and network"
sidebarTitle: "Fees and fairness"
description: "How QuantDesk presents trading fees, perpetual funding, and Solana network costs honestly in the product, with Swagger as the source for programmatic constants."
---

# Fees and fairness

User-facing summary — **exact fee schedules** live in product surfaces (fee panels, order previews) and may vary by market and deployment.

## What traders should expect

- **Trading fees** — maker/taker or equivalent structure as shown in-app at order time  
- **Funding** — perpetual funding mechanics depend on market definitions and oracle/settlement design — confirm for each symbol  
- **Network costs** — Solana transaction fees are separate from protocol trading fees  

## Fairness principles

- Fees are disclosed **before submission** where the product supports it  
- Docs avoid hiding adverse selection behind vague language — when something is experimental, we label it  

## Developers / API consumers

- Numeric fee parameters for programmatic routes belong in **Swagger** when exposed  
- Do not scrape marketing pages for fee constants — use signed previews or API responses from your environment  

## Related

- [Protocol and fairness](./protocol-and-fairness)  
- [Orders, risk, and fees FAQ](../faq/orders-risk-and-fees)  
- [Order entry basics](../trading/order-entry)  
