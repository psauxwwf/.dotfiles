# Helix text languages

## Download the built-in Helix language list

```bash
curl -fsSL "https://raw.githubusercontent.com/helix-editor/helix/master/languages.toml" -o "/tmp/opencode/helix-languages.toml"
```

Local file used for searching:

```text
/tmp/opencode/helix-languages.toml
```

## Find a language by name

```bash
rg -n '^name = "(text|ini|env|log)"|^scope = |^file-types = |^language-servers = ' "/tmp/opencode/helix-languages.toml" -A4 -B2
```

Examples:

```bash
rg -n '^name = "ini"|^scope = |^file-types = |^language-servers = ' "/tmp/opencode/helix-languages.toml" -A4 -B2
rg -n '^name = "env"|^scope = |^file-types = |^language-servers = ' "/tmp/opencode/helix-languages.toml" -A4 -B2
```

## Check whether an extension is already taken

Search plain extensions:

```bash
rg -n '"log"|"cfg"|"conf"|"ini"|"env"' "/tmp/opencode/helix-languages.toml"
```

Search `glob` patterns:

```bash
rg -n 'glob = ".*README.*"|glob = ".*\.conf"|glob = ".*\.env"' "/tmp/opencode/helix-languages.toml"
```

## Find potential conflicts

For `.conf`:

```bash
rg -n '"conf"|glob = ".*\.conf"' "/tmp/opencode/helix-languages.toml"
```

For `.cfg`:

```bash
rg -n '"cfg"|glob = ".*\.cfg"' "/tmp/opencode/helix-languages.toml"
```

For plain-text file names:

```bash
rg -n 'glob = "README"|glob = "LICENSE"|glob = "CHANGELOG"|glob = "NOTES"' "/tmp/opencode/helix-languages.toml"
```

## Check additional plain-text candidates that are not covered yet

This is the command used to inspect more generic extensions before adding them:

```bash
rg -n '"(out|err|dump|trace|textile|org|rst|cfg|conf|env|ini|md|adoc|text|lst|list|note|notes|nfo|ans|asc|log|textile|texi|man|info|readme|license|copying|notice|authors|changelog|history|news|faq|thanks|install)"|glob = ".*(README|LICENSE|COPYING|NOTICE|AUTHORS|TODO|NOTES|CHANGELOG|HISTORY|NEWS|FAQ|THANKS|INSTALL).*"' "/tmp/opencode/helix-languages.toml"
```

This is the narrower command used for the final safe additions:

```bash
rg -n '"(out|err|dump|trace|bak|old)"|glob = ".*(README|LICENSE|TODO|todo.txt).*"' "/tmp/opencode/helix-languages.toml"
```

## Validate your language after edits

```bash
hx --health text
hx --health ini
hx --health env
hx --health cfg
hx --health conf
```

## Practical rules

- Helix `file-types` uses `glob`, not regex.
- Do not use `{ glob = "*" }` or overly broad patterns.
- In Helix, `glob` has higher priority than file extensions.
- Before adding a new extension, always check both string `file-types` and `glob` matches.
