# QuantDesk Documentation

Public repository hosting the QuantDesk developer portal — content, navigation, and static assets, powered by [Mintlify](https://mintlify.com).

## Structure

- `docs/` — all documentation pages (MDX/Markdown), grouped by section (`overview/`, `developers/`, `trading/`, `data/`, `social/`, `security/`, `faq/`, `changelog/`, `community/`).
- `docs.json` — modern Mintlify configuration (navigation, theme, colors). Primary config.
- `mint.json` — legacy Mintlify configuration, kept in sync with `docs.json` for compatibility.
- `images/` — static image assets and placeholders.
- `logo.svg` — site logo / favicon.

> **Note:** `docs.json` and `mint.json` must stay in sync. When you add, remove, or reorder a page, update the navigation in **both** files.

## Running locally

Requires Node.js 22 or lower (Mintlify's CLI does not support Node 25+).

```bash
nvm use 22
npx mintlify dev
```

This serves the site locally with live reload. Install the CLI globally with `npm i -g mintlify` if you prefer running `mintlify dev` directly.

## Validating navigation

Before opening a PR, confirm there are no broken links or pages missing from navigation:

```bash
npx mintlify broken-links
```
