export ZSH="$HOME/.oh-my-zsh"

# Keep OMZ caches/dumps out of $HOME and speed up completion init.
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p -- "${ZSH_CACHE_DIR}" "${ZSH_COMPDUMP:h}" 2>/dev/null || true

# shellcheck disable=SC2034
plugins=(
	git
	zsh-autosuggestions
)

# shellcheck disable=SC1091
[[ ! -f $ZSH/oh-my-zsh.sh ]] || source "$ZSH/oh-my-zsh.sh"

for zshrc_file in "$HOME/.zshrc.d"/*.zsh; do
	[[ -r $zshrc_file ]] || continue
	# shellcheck disable=SC1090
	source "$zshrc_file"
done
