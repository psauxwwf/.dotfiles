---
description: do git commit
model: openai/gpt-5.3-codex
subtask: true
---

### Instructions

1. Load skill: `git-commit`

2. Follow the `git-commit` skill workflow to create the commit.

3. If this value $1 is `push` do git push.

# Shows concise working tree status

`$ git status --short`
!`git status --short`

# Shows staged and unstaged changes

`$ git diff --staged && git diff`
!`git diff --staged && git diff`

# Shows recent commit message history

`$ git log --oneline -10`
!`git log --oneline -10`
