opencode-serve() {
	if ss -tulnp 2>/dev/null | grep -q "14096"; then
		return 0
	fi

	o opencode serve --port 14096 --hostname 127.0.0.1 --pure
}

opencode-serve
