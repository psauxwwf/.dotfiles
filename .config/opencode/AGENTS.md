## AGENTS Instructions

### Web Requests

- For complex website interactions (dynamic/JS, auth, buttons/forms), use `agent-browser`.
- If `webfetch` fails (error, empty response, blocked, needs interaction), switch to `agent-browser`.

### AB Trigger

If the user uses `AB:` in their message

1. Load the `agent-browser` skill.
2. Use `agent-browser` for all web requests.
