---
description: Implement the instructions written in the comments in the code
---

### Instructions

1. Load context

- Include this files:

!`rg -l "AI:" | sed 's/^/@/'`

2. Execute

- Treat ONLY comments containing 'AI:' as actionable instructions.
- Implement every 'AI:' instruction by changing code as required.

3. Cleanup

- After implementing, delete the 'AI:' comment(s) you used.
- Do not change any other comments.
- Do not modify comments with 'AI?'.
