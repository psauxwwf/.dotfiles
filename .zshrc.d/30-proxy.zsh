proxy() {
	HTTP_PROXY=$PROXY HTTPS_PROXY=$PROXY ALL_PROXY=$PROXY NO_PROXY=$NO_PROXY "$@"
}

proxych() {
	proxychains4 -q -f ~/.ai/proxychains.conf "$@"
}

alias pr='proxychains4 -q -f /etc/proxychains.conf'

# alias pi='proxych pi'
alias crush='proxy crush'

# alias pc='cd ~/.ai && pi'
alias cr='cd ~/.ai && crush'
alias oc='cd ~/.ai && opencode'

compdef _opencode_yargs_completions opencode
