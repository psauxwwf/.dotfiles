_gen_fzf_default_opts() {
	local theme=${1:-'default'}
	local colors=""
	if [[ $theme == 'gruvbox' ]]; then
		colors="bg+:#3c3836,bg:#282828,spinner:#8ec07c,hl:#83a598,fg:#bdae93,header:#83a598,info:#fabd2f,pointer:#8ec07c,marker:#8ec07c,fg+:#ebdbb2,prompt:#fabd2f,hl+:#83a598"
	elif [[ $theme == 'dracula' ]]; then
		colors="fg:#f8f8f2,bg:#282a36,hl:#bd93f9,fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
	elif [[ $theme == 'cattpucin' ]]; then
		colors="bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
	fi
	export FZF_DEFAULT_OPTS="--color=$colors"
}
_gen_fzf_default_opts 'dracula'
