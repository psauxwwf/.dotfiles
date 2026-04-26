---
description: Answer on the questions written in the comments in the code
model: openai/gpt-5.3-codex
---

### Instructions

1. Load context

- Include this files:

!`rg -l "AI\?" | sed 's/^/@/'`

2. Execute

- Treat ONLY comments containing 'AI?' as questions.
- Answer only the questions asked in lines with 'AI?'.
- Respond in this exact format:

question:
answer:

3. Cleanup

- After answering, delete only the 'AI?' comment lines you answered.
- Do not modify any other comments.
- Do not modify comments with 'AI:'.
- Do not modify source code.
