z() {
	zellij attach --create main
}

zi() {
	local session query selected
	local -a picked

	if [[ -n $1 ]]; then
		zellij attach --create "$1"
		return
	fi

	picked=("${(@f)$(fzf --reverse --height=10 --border --print-query --header='enter: attach/create | ctrl-d: delete session' --bind='ctrl-d:execute-silent(zellij d {} --force)+reload(zellij ls --short)' <<<"$(zellij ls --short)")}")
	[[ $? -ne 0 ]] && return 1

	query="${picked[1]}"
	selected="${picked[2]}"
	session="${selected:-$query}"
	[[ -z $session ]] && return 1

	zellij attach --create "$session"
}

_zellij_auto_tab_title() {
	autoload -Uz add-zsh-hook
	typeset -g _ZELLIJ_T=""
	_zr() {
		[[ -n $ZELLIJ && $1 != "$_ZELLIJ_T" ]] || return
		_ZELLIJ_T=$1
		zellij action rename-tab "$1" &>/dev/null
	}
	_zp() {
		local dir
		if [[ $PWD == "$HOME" ]]; then
			dir="~"
		else
			dir=${PWD##*/}
		fi
		_zr "$dir"
	}
	_zx() {
		local title=$1
		title="${title#"${title%%[![:space:]]*}"}"
		title="${title%"${title##*[![:space:]]}"}"
		[[ -n $title ]] || return
		_zr "$title"
	}
	add-zsh-hook precmd _zp
	add-zsh-hook preexec _zx
}
_zellij_auto_tab_title
