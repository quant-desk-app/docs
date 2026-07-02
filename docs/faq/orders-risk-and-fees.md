---
title: "Orders, risk, and fees FAQ for QuantDesk traders"
sidebarTitle: "Orders & risk"
description: "Answers on market order slippage, liquidation risk drivers, in-app fee displays, and recovering stuck orders when trading perps on the QuantDesk terminal."
---

# Orders, risk, and fees

Lightweight FAQ — deep mechanics stay in trading guides and Swagger.

## Why did my market order slip?

Market orders consume liquidity across levels; **slippage** grows when depth is thin or volatility is high. Check spread and depth before large notionals — see [Reading the order book](../trading/order-book).

## What controls liquidation risk?

Position size, leverage, collateral quality, and market moves. Reduce leverage or size **before** stress, not after.

## Where are fees displayed?

In-product previews and panels when placing trades — **trust those over static docs** if numbers diverge.

## Can I cancel stuck orders?

Use in-app cancel flows; if errors persist, verify connectivity and auth — see [Errors and rate limits](../developers/errors-and-rate-limits).

## Related

- [Order entry basics](../trading/order-entry)  
- [Fees and fairness](../security/fees-and-fairness)  
- [FAQ hub](./index)  
