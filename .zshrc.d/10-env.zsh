# shellcheck disable=SC1091
[[ ! -f $HOME/.local/bin/env ]] || source "$HOME/.local/bin/env"
# shellcheck disable=SC1091
[[ ! -f $HOME/.env ]] || source "$HOME/.env"

export GOPATH=~/.go
export EDITOR=hx

export PATH=$PATH:"$GOPATH/bin"
export PATH=$PATH:"$HOME/.local/bin"

# Aider conf
export AIDER_AUTO_COMMITS=False
export AIDER_CHAT_LANGUAGE=ru_RU
export AIDER_CHECK_UPDATE=False
export AIDER_CODE_THEME=dracula
export AIDER_COMMIT_LANGUAGE=en_EN
export AIDER_DIRTY_COMMITS=True
export AIDER_DRY_RUN=False
# export AIDER_EDIT_FORMAT=diff # https://aider.chat/docs/more/edit-formats.html#diff
export AIDER_EDITOR=hx
export AIDER_ENV_FILE=.env.aider
export AIDER_GUI=False
export AIDER_MODEL_METADATA_FILE=~/.ai/.aider.model.metadata.json
export AIDER_MODEL=openai/gpt-5.2
export AIDER_PRETTY=True
export AIDER_RESTORE_CHAT_HISTORY=True
export AIDER_SHOW_RELEASE_NOTES=False
export AIDER_STREAM=True
export AIDER_VOICE_LANGUAGE=ru
export AIDER_WATCH_FILES=True
export AIDER_WEAK_MODEL=openai/gpt-5-nano

# Aider-ce conf
export AIDER_AGENT=False
export AIDER_CACHE_PROMPTS=False
export AIDER_ENABLE_CONTEXT_COMPACTION=True
export AIDER_PRESERVE_TODO_LIST=True

export AIDER_ANALYTICS=False
export CRUSH_DISABLE_METRICS=1
export DO_NOT_TRACK=1
export DISABLE_TELEMETRY=1

export OPENCODE_EXPERIMENTAL=True
# export OPENCODE_DISABLE_LSP_DOWNLOAD=True
# export OPENCODE_EXPERIMENTAL_WORKSPACES=True

export DOCKER_MCP_USE_CE=1
# export DOCKER_MCP_IN_CONTAINER=1 # NOT SET THIS )))
