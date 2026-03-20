_trans_completion() {
	_files
}
compdef _trans_completion trans

Resume() {
	fg
	zle push-input
	# shellcheck disable=SC2034
	BUFFER=""
	zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

y() {
	local tmp cwd
	tmp="$(mktemp -t 'yazi-cwd.XXXXXX')" || return
	yazi "$@" --cwd-file="$tmp"
	cwd="$(command cat -- "$tmp")" || true
	if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd" || return
	fi
	rm -f -- "$tmp"
}

o() {
	if [[ -z $1 ]]; then
		return 1
	fi
	set +m
	nohup setsid "$@" >/dev/null 2>&1 </dev/null &
	disown
	set -m
}
_o_completion() {
	_command_names
}
compdef _o_completion o

n() {
	o nautilus .
}
compdef _o_completion n

k() {
	local session
	session=$(find ~/.config/kitty/session -maxdepth 1 -type f -name "*.kitty-session" | fzf --reverse --height=10 --border)
	o kitty --session "$session"
	exit
}

clip() {
	if [[ -z $1 ]]; then
		if ! wl-copy; then
			echo "Failed: copy from stdin."
			return 1
		fi
	else
		if ! cat "$1" | wl-copy; then
			echo "Failed: copy file \"$1\"."
			return 1
		fi
	fi
	return 0
}
_clip_completion() {
	_files
}
compdef _clip_completion clip

share() {
	if [[ -z $1 ]]; then
		echo "Usage: share <file_or_directory>"
		return 1
	fi

	local input="$1"
	local zip_file="$input".zip
	local pass url
	pass=$(openssl rand 32 | base64)
	zip -e -rq9 "$zip_file" "$input" -P "$pass"

	url=$(proxychains4 -q curl -F "file=@${zip_file}" https://temp.sh/upload | sed 's/http:/https:/')

	echo "Password: $pass"
	echo "Download:
curl -X POST -o $zip_file $url
wget --method=POST -O $zip_file $url
Invoke-WebRequest -Uri \"$url\" -Method \"POST\" -OutFile $zip_file
"
}
_share_completion() {
	_files
}
compdef _share_completion share

gpge() {
	if [[ -z $1 ]]; then
		echo "Usage: gpge <file_or_directory>"
		return 1
	fi

	local input="$1"
	local input_file=""
	local cleanup=0

	if [[ -d $input ]]; then
		input_file="${input%/}.zip"
		if ! zip -r "$input_file" "$input" >/dev/null; then
			echo "Error: Failed to zip directory '$input'."
			return 1
		fi
		cleanup=1
	elif [[ -f $input ]]; then
		input_file="$input"
	else
		echo "Error: '$input' is neither a file nor a directory."
		return 1
	fi

	local output_file="$input_file.gpg"

	if gpg --encrypt --output - "$input_file" | base64 >"$output_file"; then
		echo "File encrypted successfully: $output_file"
		[[ $cleanup -eq 1 ]] && rm -f "$input_file"
	else
		echo "Error: Failed to encrypt file."
		[[ $cleanup -eq 1 ]] && rm -f "$input_file"
		return 1
	fi
}
_gpge_completion() {
	_files
}
compdef _gpge_completion gpge

gpgd() {
	if [[ -z $1 ]]; then
		return 1
	fi
	local input_file="$1"
	local output_file="${input_file%.gpg}"
	if [[ ! -f $input_file ]]; then
		echo "Error: File '$input_file' does not exist."
		return 1
	fi
	if base64 --decode "$input_file" | gpg --decrypt --output "$output_file"; then
		echo "File decrypted successfully: $output_file"
	else
		echo "Error: Failed to decrypt file."
	fi
}
_gpgd_completion() {
	_files
}
compdef _gpgd_completion gpgd

yubi() {
	if [[ -z $1 ]]; then
		return 1
	fi
	local phrase="$1"
	local password
	password=$(echo "$phrase" | xxd -p | ykman otp calculate 1)
	echo "$password"
	echo "$phrase"
	echo "$password" >"$phrase.pass"
}

yubi-zip() {
	if [[ -z $1 ]]; then
		return 1
	fi
	local phrase="$1"
	local password
	password=$(echo "$phrase" | xxd -p | ykman otp calculate 1)
	echo "$password"
	echo "$phrase"
	echo "$password" >"$phrase.pass"
	zip -r9 -P "$password" "$1.zip" "$1"
}

oconnect() {
	(
		echo -e "${OPENCONNECT_PASSWORD}\nyes\n"
	) | sudo openconnect "$OPENCONNECT_SERVER" --user="$OPENCONNECT_USERNAME" --passwd-on-stdin --allow-insecure-crypto --no-system-trust
}
