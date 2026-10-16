#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_PLUGIN_DIR="${HOME}/.gemini/config/plugins/multi-agent-orchestrator"
TARGET_GLOBAL_RULES="${HOME}/.gemini/config/AGENTS.md"
TARGET_USER_RULES="${HOME}/AGENTS.md"

echo "==> Installing Antigravity Multi-Agent Orchestrator Plugin..."
mkdir -p "${TARGET_PLUGIN_DIR}"
cp -f "${SCRIPT_DIR}/plugin.json" "${TARGET_PLUGIN_DIR}/"
cp -rf "${SCRIPT_DIR}/rules" "${TARGET_PLUGIN_DIR}/"
cp -rf "${SCRIPT_DIR}/skills" "${TARGET_PLUGIN_DIR}/"
cp -rf "${SCRIPT_DIR}/agents" "${TARGET_PLUGIN_DIR}/"

echo "==> Deploying Global AGENTS.md rules..."
mkdir -p "$(dirname "${TARGET_GLOBAL_RULES}")"
cp -f "${SCRIPT_DIR}/rules/AGENTS.md" "${TARGET_GLOBAL_RULES}"
cp -f "${SCRIPT_DIR}/rules/AGENTS.md" "${TARGET_USER_RULES}"

echo "==> Verifying CLI Toolchain..."
for cmd in ast-grep biome agent-browser rg orca; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "  [OK] $cmd found"
  else
    echo "  [WARN] $cmd not found in PATH"
  fi
done

echo "==> Installation complete! Run 'agy' to start."
