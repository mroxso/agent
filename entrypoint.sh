#!/bin/sh
set -e

# Build the pi argument list from environment variables.
# All variables are optional; unset variables are simply skipped.
ARGS=""

# ── Provider & model ─────────────────────────────────────────────────────────
# Provider (e.g. anthropic, openai, google, amazon-bedrock, …)
[ -n "$PI_PROVIDER" ] && ARGS="$ARGS --provider $PI_PROVIDER"

# Model ID or pattern (e.g. claude-sonnet-4-5, gpt-4o, openai/gpt-4o)
[ -n "$PI_MODEL" ] && ARGS="$ARGS --model $PI_MODEL"

# Thinking level: off | minimal | low | medium | high | xhigh
[ -n "$PI_THINKING" ] && ARGS="$ARGS --thinking $PI_THINKING"

# Comma-separated model patterns for Ctrl+P cycling
[ -n "$PI_MODELS" ] && ARGS="$ARGS --models $PI_MODELS"

# Direct API key – overrides the provider-specific env var (e.g. ANTHROPIC_API_KEY)
[ -n "$PI_API_KEY" ] && ARGS="$ARGS --api-key $PI_API_KEY"

# ── Run mode ─────────────────────────────────────────────────────────────────
# default (interactive) | print | json | rpc
case "$PI_MODE" in
  print|-p) ARGS="$ARGS -p" ;;
  json)     ARGS="$ARGS --mode json" ;;
  rpc)      ARGS="$ARGS --mode rpc" ;;
esac

# ── Tools ────────────────────────────────────────────────────────────────────
# PI_NO_TOOLS=1  → disable all built-in tools
# PI_TOOLS=read,bash,edit,write,grep,find,ls  → enable only listed tools
if [ "$PI_NO_TOOLS" = "1" ]; then
  ARGS="$ARGS --no-tools"
elif [ -n "$PI_TOOLS" ]; then
  ARGS="$ARGS --tools $PI_TOOLS"
fi

# ── Session ──────────────────────────────────────────────────────────────────
# Continue most recent session
[ "$PI_CONTINUE" = "1" ] && ARGS="$ARGS -c"

# Ephemeral mode – do not save session
[ "$PI_NO_SESSION" = "1" ] && ARGS="$ARGS --no-session"

# Custom session storage directory
[ -n "$PI_SESSION_DIR" ] && ARGS="$ARGS --session-dir $PI_SESSION_DIR"

# ── System prompt ─────────────────────────────────────────────────────────────
# Replace default system prompt
[ -n "$PI_SYSTEM_PROMPT" ] && ARGS="$ARGS --system-prompt $PI_SYSTEM_PROMPT"

# Append text to the default system prompt (without replacing it)
[ -n "$PI_APPEND_SYSTEM_PROMPT" ] && ARGS="$ARGS --append-system-prompt $PI_APPEND_SYSTEM_PROMPT"

# ── Resources ────────────────────────────────────────────────────────────────
[ "$PI_NO_EXTENSIONS" = "1" ]      && ARGS="$ARGS --no-extensions"
[ "$PI_NO_SKILLS" = "1" ]          && ARGS="$ARGS --no-skills"
[ "$PI_NO_PROMPT_TEMPLATES" = "1" ] && ARGS="$ARGS --no-prompt-templates"

# ── Misc ─────────────────────────────────────────────────────────────────────
# Verbose startup output
[ "$PI_VERBOSE" = "1" ] && ARGS="$ARGS --verbose"

# If a prompt is provided via env, pass it as positional argument
if [ -n "$PI_PROMPT" ]; then
  # shellcheck disable=SC2086
  exec pi $ARGS "$PI_PROMPT" "$@"
else
  # shellcheck disable=SC2086
  exec pi $ARGS "$@"
fi
