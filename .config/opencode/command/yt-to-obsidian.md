---
description: transcribe a YouTube video and create an Obsidian note
model: openai/gpt-5.3-codex
---

### Workflow

1. Load skill `yotube-transcribe`.
2. Load skill `obsidian-cli`.
3. Load skill `obsidian-markdown`.
4. Process the YouTube URL from `$1` and generate transcript-based content.
5. Create a new note in @core/ using @templates/Note.md as template.

### Note Requirements

1. Use sections exactly as:
   - `### Summary`
   - `### Key points`
2. Fill `Summary` with a short overview from the transcript.
3. Fill `Key points` with concise bullets from the transcript.
4. Translate `Summary` and `Key points` to Russian.
5. In `#### Links:`, make the first item a Markdown link with the video title and URL.
6. Add all links from the YouTube video description to `#### Links:`.
7. Leave `tags:` empty (do not set tags).
8. Set `zero-links:` to exactly one Obsidian wikilink, for example `[[1310 Kaspersky]]`.
9. Choose `zero-links:` by video meaning and prefer the lowest-level category in the hierarchy.

   ```
   !`./map.py --tree-only`
   ```

### Response Behavior

If the workflow completes successfully, do not output any final response.
