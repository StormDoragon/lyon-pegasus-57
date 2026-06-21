#!/bin/bash
set -euo pipefail

# Only run dependency setup in Claude Code on the web (remote) sessions.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"

# Use the pinned package manager (pnpm) via corepack.
corepack enable >/dev/null 2>&1 || true

# Install JS dependencies. `install` (not `--frozen-lockfile`) lets the
# container cache benefit subsequent runs and stays idempotent.
pnpm install --prefer-offline

# Install Playwright's browser so the e2e suite can run.
pnpm exec playwright install chromium >/dev/null 2>&1 || true

echo "session-start hook: dependencies installed"
