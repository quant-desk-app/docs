#!/usr/bin/env bash
# Start Mintlify docs preview (port 3204). Invoked from repo root by scripts/*/start-all.sh.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
if [ -f "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]; then
  # shellcheck disable=SC1090
  . "${NVM_DIR:-$HOME/.nvm}/nvm.sh"
fi
if [ -f "${ROOT}/.nvmrc" ]; then
  (cd "${ROOT}" && nvm use >/dev/null 2>&1 || true)
fi
exec pnpm run start:docs:mintlify
