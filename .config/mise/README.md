### Mise

```bash
mise install
```

### Python

```bash
pip install --no-cache-dir --upgrade -r requirements.txt
```

### Node

```bash
npm install -g . --cache /dev/null --loglevel=error
```

### Golang

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/a-h/templ/cmd/templ@latest
curl -sSfL https://golangci-lint.run/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.9.0
```

### Clear caches

```bash
mise cache clear
pip cache purge
uv cache clean
npm cache clean --force
npm dedup
rm -rf ~/.bun/install/cache
rm -rf ~/.bun/cache
```
