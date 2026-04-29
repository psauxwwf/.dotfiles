## AGENTS Instructions

### Web Requests

- For complex website interactions (dynamic/JS, auth, buttons/forms), use `lightpanda`.
- If `webfetch` fails (error, empty response, blocked, needs interaction), switch to `lightpanda`.

### AB Trigger

If the user uses `AB:` in their message

1. Load the `agent-browser` skill.
2. Use `agent-browser` for all web requests.

### LB Trigger

If the user uses `LB:` in their message

1. Load the `lightpanda` skill.
2. Use `lightpanda` for all web requests.

### Language

- Always respond in the same language the user used for the question.

### Skill loading hardening

- Do not open `skill://...` with `read`.
- Resolve skills via filesystem path: `~/.agents/skills/<skill>/SKILL.md`.
- If skill file is unavailable, continue with installed CLI/tool and report fallback.
