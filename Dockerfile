# ─── runtime stage ────────────────────────────────────────────────────────────
FROM node:24-slim

# Install pi globally so it is available as a shell tool (e.g. inside bash tool)
RUN npm install -g @mariozechner/pi-coding-agent

WORKDIR /agent

# /app is the project directory mounted at runtime
VOLUME ["/app"]

# Default working directory for the agent (overridable via CWD env var)
ENV CWD=/app

# ─── Provider / model selection (all optional, can be overridden at runtime) ──
# Set PI_PROVIDER to one of: anthropic, openai, google, azure-openai,
#   amazon-bedrock, google-vertex, mistral, groq, cerebras, xai,
#   openrouter, vercel-ai-gateway, zai, opencode, opencode-go,
#   huggingface, kimi-coding, minimax
ENV PI_PROVIDER=""

# Set PI_MODEL to a model ID or pattern, e.g. "claude-sonnet-4-5", "gpt-4o"
ENV PI_MODEL=""

# Set PI_THINKING to: off | minimal | low | medium | high | xhigh
ENV PI_THINKING=""

# Set PI_MODE to: print | json | rpc  (leave empty for interactive)
ENV PI_MODE=""

# Set PI_MODELS to a comma-separated list for Ctrl+P cycling
ENV PI_MODELS=""

# Set PI_CONTINUE=1 to resume the most recent session
ENV PI_CONTINUE=""

# Set PI_PROMPT to a non-empty string to run a single prompt non-interactively
ENV PI_PROMPT=""

# ─── Tools ────────────────────────────────────────────────────────────────────
# Set PI_TOOLS to a comma-separated list of built-in tools to enable:
#   read, bash, edit, write, grep, find, ls  (default: read,bash,edit,write)
ENV PI_TOOLS=""
# Set PI_NO_TOOLS=1 to disable all built-in tools (extension tools still work)
ENV PI_NO_TOOLS=""

# ─── Session ──────────────────────────────────────────────────────────────────
# Set PI_NO_SESSION=1 for ephemeral mode (session not saved)
ENV PI_NO_SESSION=""
# Custom session storage directory inside the container
ENV PI_SESSION_DIR=""

# ─── System prompt ────────────────────────────────────────────────────────────
# Replace the default system prompt entirely
ENV PI_SYSTEM_PROMPT=""
# Append extra instructions to the default system prompt
ENV PI_APPEND_SYSTEM_PROMPT=""

# ─── Resources ────────────────────────────────────────────────────────────────
# Set to 1 to disable discovery of extensions / skills / prompt templates
ENV PI_NO_EXTENSIONS=""
ENV PI_NO_SKILLS=""
ENV PI_NO_PROMPT_TEMPLATES=""

# ─── Misc ─────────────────────────────────────────────────────────────────────
# Set PI_VERBOSE=1 to force verbose startup output
ENV PI_VERBOSE=""
# Direct API key override (takes priority over provider-specific env vars)
ENV PI_API_KEY=""

# ─── API keys (passed through from the host / compose env_file) ───────────────
# ANTHROPIC_API_KEY, OPENAI_API_KEY, GEMINI_API_KEY, MISTRAL_API_KEY,
# GROQ_API_KEY, CEREBRAS_API_KEY, XAI_API_KEY, OPENROUTER_API_KEY,
# AI_GATEWAY_API_KEY, ZAI_API_KEY, OPENCODE_API_KEY, HF_TOKEN,
# KIMI_API_KEY, MINIMAX_API_KEY  — set these in your .env file.

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]