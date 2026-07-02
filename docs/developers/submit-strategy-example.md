---
title: "Contributing: submit a strategy example"
sidebarTitle: "Contributing"
description: "How external quants and developers contribute custom strategy scripts to the public QuantDesk examples/ workspace, and the code-quality rules (TypeScript linting, secret scanning) every contribution must pass."
---

# Contributing

QuantDesk welcomes strategy examples and integration samples from the community. The public [`quant-desk-app/quantdesk-sdk`](https://github.com/quant-desk-app/quantdesk-sdk) repository is where those contributions live — specifically the [`examples/`](../overview/sdk-architecture-tour) workspace.

This guide shows you how to add a clean, mergeable example.

## What we accept

- **Strategy scripts** — market making, arbitrage, risk monitoring, signal-driven entries.
- **Integration samples** — REST gateway usage, websocket consumption, on-chain account reads.
- **Agent context recipes** — feeding QuantDesk data into your own tooling.

Contributions should be **self-contained, runnable, and honest** about what they do. We prefer a small example that works over a large one that almost works.

## Where your code goes

Add new work under the matching subdirectory in `examples/`:

| Your contribution | Directory |
| --- | --- |
| Devnet / on-chain interaction | `examples/devnet-testing/` |
| REST or market-data integration | `examples/api-integration/` |
| Typed order flows | `examples/typescript/` |
| Agent / AI context | `examples/ai-integration/` |

If your example does not fit an existing bucket, propose a new subdirectory in your pull request description.

## Submission workflow

1. **Fork** `quant-desk-app/quantdesk-sdk` and create a branch (for example `example/mean-reversion-btc`).
2. **Add your example** in the correct `examples/` subdirectory, including:
   - the working script,
   - a short `README.md` explaining what it does and how to run it,
   - any required environment variables documented (never their values).
3. **Run the quality checks** locally (below) until they pass.
4. **Open a pull request** describing the strategy, its assumptions, and any external data it needs.

## Code-quality rules

Every contribution must pass these before review. Pull requests that fail are sent back automatically.

### TypeScript linting

TypeScript examples are linted with the SDK's ESLint config.

```bash
cd typescript
pnpm install
pnpm run lint
```

Keep examples typed where practical, avoid `any` unless justified, and match the existing style. JavaScript samples should still be clean and readable.

### Secret scanning (Gitleaks)

**Never commit secrets.** All contributions are scanned for leaked credentials with [Gitleaks](https://github.com/gitleaks/gitleaks).

```bash
gitleaks detect --source . --no-banner
```

- Use environment variables for keys, tokens, and RPC URLs — document the variable names, not the values.
- Do not hardcode wallet private keys, API bearer tokens, or provider secrets.
- A single detected secret blocks the merge until it is removed **and rotated**.

### Runs out of the box

Reviewers will clone your branch and run it. Make sure:

- dependencies install cleanly (`pnpm install`),
- the example runs with only the documented environment variables set,
- and the `README.md` steps actually reproduce the result.

## Review and merge

A maintainer reviews for correctness, safety, and clarity. Once linting and secret scanning are green and the example runs, your contribution is merged into the public `examples/` workspace.

## Related

- [SDK architecture tour](../overview/sdk-architecture-tour) — how the repo is laid out
- [Developer quickstart](../developers/quickstart) — get a gateway talking first
- [Building on QuantDesk](../developers/building-on-quantdesk) — on-chain trading tutorial
