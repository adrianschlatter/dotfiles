#!/usr/bin/env bash
set -euo pipefail

cmd="${CRUSH_TOOL_INPUT_COMMAND:-}"
trimmed="${cmd#"${cmd%%[![:space:]]*}"}"

if [[ "$trimmed" =~ ^(pytest|tox|flake8)([[:space:]].*)?$ ]] && [[ ! "$trimmed" =~ [\;\&\|\`\$\<\>] ]]; then
  echo '{"decision":"allow"}'
else
  echo '{}'
fi
