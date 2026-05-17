# shellcheck disable=SC1091
[[ ! -f $HOME/.local/bin/env ]] || source "$HOME/.local/bin/env"
# shellcheck disable=SC1091
[[ ! -f $HOME/.env ]] || source "$HOME/.env"

export GOPATH=~/.go
export EDITOR=hx

export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.lmstudio/bin:$PATH"

export AIDER_ANALYTICS=False
export CRUSH_DISABLE_METRICS=1
export DO_NOT_TRACK=1
export DISABLE_TELEMETRY=1
export LIGHTPANDA_DISABLE_TELEMETRY=true

export OPENCODE_EXPERIMENTAL=True
# export OPENCODE_DISABLE_LSP_DOWNLOAD=True
# export OPENCODE_EXPERIMENTAL_WORKSPACES=True

export DOCKER_MCP_USE_CE=1
# export DOCKER_MCP_IN_CONTAINER=1 # NOT SET THIS )))

export PLAYWRIGHT_BROWSER_PATH=/opt/chromium/chrome
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
