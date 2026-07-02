# QuantDesk Documentation

Public repository hosting the QuantDesk developer portal — content, navigation, and static assets, powered by [Mintlify](https://mintlify.com).

## Structure

- `docs/` — all documentation pages (Markdown), grouped by section (`overview/`, `developers/`, `trading/`, `data/`, `social/`, `security/`, `faq/`, `changelog/`).
- `docs.json` — Mintlify site configuration (navigation, theme, navbar, colors). **Single source of truth.**
- `images/` — static image assets and placeholders.
- `logo.svg` — site logo / favicon.

## Running locally

Requires Node.js 22 or lower (Mintlify's CLI does not support Node 25+).

```bash
nvm use 22
npx mintlify dev
```

This serves the site locally with live reload. Install the CLI globally with `npm i -g mintlify` if you prefer running `mintlify dev` directly.

> **PATH note:** If `node -v` still shows 25+ after `nvm use 22`, prepend the nvm Node 22 bin dir to `PATH` (linuxbrew/homebrew `node` can shadow nvm).

## Validating navigation

Before opening a PR, confirm there are no broken links or pages missing from navigation:

```bash
npx mintlify broken-links
```

## Deployment

The live site at [docs.quantdesk.app](https://docs.quantdesk.app) deploys from this repo's `main` branch via the Mintlify GitHub integration. After merging, confirm the deployment in the [Mintlify dashboard](https://dashboard.mintlify.com) → your project → **Deployments**.
