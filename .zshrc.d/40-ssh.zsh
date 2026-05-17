_get_ssh_hosts() {
	local opts hist
	opts=$(
		awk '/^Host / {
            for (i=2; i<=NF; i++) print $i
        }' ~/.ssh/config ~/.ssh/config.d/*.conf 2>/dev/null | grep -v '\*'
	)
	hist=$(history | tail -n 1000 | grep -oP 'ssh \K[^\s]+')
	echo -e "$opts\n$hist" | sort -u
}

ssh() {
	if [[ -z $1 ]]; then
		session=$(fzf --reverse --height=10 --border <<<"$(_get_ssh_hosts)")
		[[ -z $session ]] && return 1
		/usr/bin/ssh "$session"
	else
		/usr/bin/ssh "$@"
	fi
}
compdef _ssh ssh

ssh-copy-id-all() {
	if [[ -z $1 ]]; then
		return 1
	fi
	ssh-copy-id -f "$1"
	ssh-copy-id -f -i ~/.ssh/id_rsa "$1"
	ssh-copy-id -f -i ~/.ssh/id_ed25519_sk "$1"
}

_ssh_copy_id_all_completion() {
	local -a hosts
	# shellcheck disable=SC2034,SC2206,SC2207
	hosts=($(_get_ssh_hosts))
	compadd -a hosts
}
compdef _ssh_copy_id_all_completion ssh-copy-id-all

_start_gpg_agent() {
	command -v gpgconf >/dev/null 2>&1 || return 0
	local sock
	sock="$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null)" || return 0
	[[ -n $sock ]] || return 0
	[[ -S $sock ]] || gpgconf --launch gpg-agent >/dev/null 2>&1 || return 0
	export SSH_AUTH_SOCK="$sock"
}
_start_gpg_agent
# [[ -z $SSH_AUTH_SOCK || ! -S $SSH_AUTH_SOCK ]] && _start_gpg_agent
