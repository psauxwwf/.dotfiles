alias zi="zema"
alias z="zema main"

eval "$(zema -completion)"

# _start_session() {
# 	kitty @ load-config ~/.config/kitty/kitty-no-bind.conf &&
# 		zellij attach --create "$1" &&
# 		kitty @ load-config ~/.config/kitty/kitty.conf
# }

# zi() {
# 	local session query selected
# 	local -a picked

# 	if [[ -n $1 ]]; then
# 		_start_session "$1"
# 		return
# 	fi

# 	picked=("${(@f)$(fzf --reverse --height=10 --border --print-query --header='enter: attach/create | ctrl-d: delete session' --bind='ctrl-d:execute-silent(zellij d {} --force)+reload(zellij ls --short)' <<<"$(zellij ls --short)")}")
# 	[[ $? -ne 0 ]] && return 1

# 	query="${picked[1]}"
# 	selected="${picked[2]}"
# 	session="${selected:-$query}"
# 	[[ -z $session ]] && return 1

# 	_start_session "$session"
# }

# _zellij_auto_tab_title() {
# 	autoload -Uz add-zsh-hook
# 	typeset -g _ZELLIJ_T=""
# 	_zr() {
# 		local title=$1
# 		(( ${#title} > 32 )) && title=${title[1,32]}
# 		[[ -n $ZELLIJ && $title != "$_ZELLIJ_T" ]] || return
# 		_ZELLIJ_T=$title
# 		zellij action rename-tab "$title" &>/dev/null
# 	}
# 	_zp() {
# 		local dir
# 		if [[ $PWD == "$HOME" ]]; then
# 			dir="~"
# 		else
# 			dir=${PWD##*/}
# 		fi
# 		_zr "$dir"
# 	}
# 	_zx() {
# 		local title=$1
# 		title="${title#"${title%%[![:space:]]*}"}"
# 		title="${title%"${title##*[![:space:]]}"}"
# 		[[ -n $title ]] || return
# 		_zr "$title"
# 	}
# 	add-zsh-hook precmd _zp
# 	add-zsh-hook preexec _zx
# }
# _zellij_auto_tab_title
