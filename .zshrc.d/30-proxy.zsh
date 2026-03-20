proxy() {
	HTTP_PROXY=$PROXY HTTPS_PROXY=$PROXY ALL_PROXY=$PROXY NO_PROXY=$NO_PROXY "$@"
}

proxych() {
	pr "$@"
}

alias open='xdg-open'
alias ls='lsd'
alias docker-compose='docker compose'
alias default-ssh-agent='eval "$(ssh-agent -s)"'
alias laz='lazygit'
alias lad='lazydocker'
alias pr='proxychains4 -q -f /etc/proxychains.conf'

alias crush='proxy crush'
alias aider='proxy aider'
alias aider-no-git='proxy aider --no-git'

# opencode() {
# 	proxychains4 -q -f ~/.ai/proxychains.conf /usr/local/bin/opencode "$@"
# }
compdef _opencode_yargs_completions opencode

alias ai='cd ~/.ai && aider-no-git'
alias oc='cd ~/.ai && opencode'
alias cr='cd ~/.ai && crush'
