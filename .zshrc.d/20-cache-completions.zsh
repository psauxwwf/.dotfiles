_zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

_cache_eval() {
	local cache_file="$1"
	shift
	local -a deps
	deps=()
	while [[ ${1:-} == --dep ]]; do
		deps+=("$2")
		shift 2
	done
	local bin="$1"
	shift
	local bin_path
	bin_path="$(command -v -- "$bin" 2>/dev/null)" || return 0
	mkdir -p -- "${cache_file:h}" || return 0
	local regen=0
	if [[ ! -s "$cache_file" || "$bin_path" -nt "$cache_file" ]]; then
		regen=1
	else
		local dep dep_path
		for dep in "${deps[@]}"; do
			dep_path="$(command -v -- "$dep" 2>/dev/null)" || continue
			[[ "$dep_path" -nt "$cache_file" ]] && {
				regen=1
				break
			}
		done
	fi
	if ((regen)); then
		"$bin_path" "$@" >|"${cache_file}.tmp" && mv -f -- "${cache_file}.tmp" "$cache_file"
	fi
	[[ -r "$cache_file" ]] || return 0
	# shellcheck disable=SC1090
	source "$cache_file"
}

_cache_comp() {
	local cmd="$1"
	shift
	local comp_fn="_$cmd"
	local cache_dir="$_zsh_cache_dir/completions"
	local cache_file="$cache_dir/$comp_fn"
	local bin_path

	bin_path="$(command -v -- "$cmd" 2>/dev/null)" || return 0
	mkdir -p -- "$cache_dir" || return 0

	if [[ ! -s "$cache_file" || "$bin_path" -nt "$cache_file" ]]; then
		"$bin_path" "$@" >|"${cache_file}.tmp" && mv -f -- "${cache_file}.tmp" "$cache_file"
	fi

	fpath=("$cache_dir" $fpath)
	autoload -Uz "$comp_fn"
	compdef "$comp_fn" "$cmd"
}

# Zsh-native completions (cached). Avoid sourcing bash_completion on startup.
_cache_eval "$_zsh_cache_dir/completions/mise.zsh" mise activate zsh
_cache_eval "$_zsh_cache_dir/completions/starship.zsh" starship init zsh
_cache_eval "$_zsh_cache_dir/completions/zoxide.zsh" zoxide init zsh --cmd cd
_cache_eval "$_zsh_cache_dir/completions/ykman.zsh" --dep ykman env _YKMAN_COMPLETE=zsh_source ykman
_cache_eval "$_zsh_cache_dir/completions/opencode.zsh" opencode completion zsh

_cache_comp task --completion zsh
_cache_comp zellij setup --generate-completion zsh
