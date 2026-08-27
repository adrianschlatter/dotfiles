#!/usr/bin/env bash
set -euo pipefail

command="${CRUSH_TOOL_INPUT_COMMAND:-}"

if printf '%s\n' "$command" | grep -qE '(^|[[:space:]])sudo([[:space:]]|$)'; then
  echo "Denied: sudo is not allowed in bash tool calls." >&2
  exit 2
fi

echo '{}'
