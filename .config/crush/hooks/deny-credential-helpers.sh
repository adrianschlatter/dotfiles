#!/usr/bin/env bash
set -euo pipefail

command="${CRUSH_TOOL_INPUT_COMMAND:-}"

if printf '%s\n' "$command" | grep -qE '(^|[[:space:]])(rbw|rbw-agent|rbw-menu)([[:space:]]|$)'; then
  echo "Denied: rbw, rbw-agent, and rbw-menu are not allowed in bash tool calls." >&2
  exit 2
fi

echo '{}'
