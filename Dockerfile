# ─── runtime stage ────────────────────────────────────────────────────────────
FROM node:24-slim

# Install pi globally so it is available as a shell tool (e.g. inside bash tool)
RUN npm install -g @mariozechner/pi-coding-agent

WORKDIR /agent

# /app is the project directory mounted at runtime
VOLUME ["/app"]

# Default working directory for the agent (overridable via CWD env var)
ENV CWD=/app

CMD ["pi", "--version"]