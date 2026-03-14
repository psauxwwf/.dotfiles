---
description: transcribe a YouTube video and create an Obsidian note
model: openai/gpt-5.3-codex
subtask: true
---

## Goal

Take a YouTube URL from `$1`, build transcript-based content, and create a new Obsidian note in `@core/` from `@templates/Note.md`.

## Required Skills

Load these skills in order:

1. `yotube-transcribe`
2. `obsidian-cli`
3. `obsidian-markdown`

## Workflow

1. Read YouTube URL from `$1`.
2. Transcribe and extract content from the video.
3. Translate all resulting content to Russian.
4. Create a new note in `@core/` using `@templates/Note.md`.
5. Fill the note according to the structure and rules below.

## Note Structure (strict)

Use these section headers exactly:

- `## Summary`
- `## Text`
- `### Key points`
- `#### Links:`
- `#### Back-links:`

## Content Rules

1. `Summary`: short transcript-based overview.
2. `Text`: main transcript-based text in Markdown; **add headings/lists/formatting where useful**; remove low-value details without losing meaning.
3. `Key points`: concise bullet list of key ideas.
4. In `#### Links:` (links always come after the `Text`):
   - first item must be a Markdown link with video title and URL;
   - then include all links found in the YouTube video description.
   - **remove all ad links**
5. Leave `tags:` empty.
6. Set `zero-links:` to exactly one Obsidian wikilink example:
   ```yaml
   zero-links:
     - "[[1000 Digit]]"
   ```
7. Choose `zero-links:` by video meaning and prefer the lowest-level category from:

```
!`./map.py --tree-only`
```

## Output Behavior

If everything completes successfully, do not print a final response.
