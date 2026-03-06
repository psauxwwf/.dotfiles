---
name: excalidraw-diagram
description: Generate Excalidraw diagrams from text content. Supports three output modes - Obsidian (.md), Standard (.excalidraw), and Animated (.excalidraw with animation order). Triggers on "Excalidraw", "draw", "flowchart", "mind map", "visualization", "diagram", "standard excalidraw", "animated excalidraw", "animation diagram", "animate".
metadata:
  version: 1.2.1
---

# Excalidraw Diagram Generator

Create Excalidraw diagrams from text content with multiple output formats.

## Output Modes

Select the output mode based on the user's trigger words:

| Trigger Words                                         | Output Mode            | File Format   | Purpose                                            |
| ----------------------------------------------------- | ---------------------- | ------------- | -------------------------------------------------- |
| `Excalidraw`, `draw`, `flowchart`, `mind map`         | **Obsidian** (default) | `.md`         | Open directly in Obsidian                          |
| `standard excalidraw`                                 | **Standard**           | `.excalidraw` | Open/edit/share in excalidraw.com                  |
| `animated excalidraw`, `animation diagram`, `animate` | **Animated**           | `.excalidraw` | Drop into excalidraw-animate to generate animation |

## Workflow

1. **Detect output mode** from trigger words (see Output Modes table above)
2. Analyze content - identify concepts, relationships, hierarchy
3. Choose diagram type (see Diagram Types below)
4. Generate Excalidraw JSON (add animation order if Animated mode)
5. Output in correct format based on mode
6. **Automatically save to current working directory**
7. Notify user with file path and usage instructions

## Output Formats

### Mode 1: Obsidian Format (Default)

**Output must follow this exact structure with no modifications:**

```markdown
---
excalidraw-plugin: parsed
tags: [excalidraw]
---

==⚠ Switch to EXCALIDRAW VIEW in the MORE OPTIONS menu of this document. ⚠== You can decompress Drawing data with the command palette: 'Decompress current Excalidraw file'. For more info check in plugin settings under 'Saving'

# Excalidraw Data

## Text Elements

%%

## Drawing

\`\`\`json
{Complete JSON data}
\`\`\`
%%
```

**Key points:**

- Frontmatter must include `tags: [excalidraw]`
- The warning message must be complete
- JSON must be wrapped by `%%` markers
- Do not use any frontmatter setting other than `excalidraw-plugin: parsed`
- **File extension**: `.md`

### Mode 2: Standard Excalidraw Format

Output a pure JSON file that can be opened in excalidraw.com:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [...],
  "appState": {
    "gridSize": null,
    "viewBackgroundColor": "#ffffff"
  },
  "files": {}
}
```

**Key points:**

- `source` must be `https://excalidraw.com` (not the Obsidian plugin source)
- Pure JSON only, with no Markdown wrapper
- **File extension**: `.excalidraw`

### Mode 3: Animated Excalidraw Format

Same as Standard format, but each element adds a `customData.animate` field to control animation order:

```json
{
  "id": "element-1",
  "type": "rectangle",
  "customData": {
    "animate": {
      "order": 1,
      "duration": 500
    }
  },
  ...other standard fields
}
```

**Animation order rules:**

- `order`: Animation playback order (1, 2, 3...). Smaller numbers appear first
- `duration`: Drawing duration of the element (milliseconds), default is 500
- Elements with the same `order` appear simultaneously
- Recommended sequence: title -> main structure -> connectors -> detailed text

**How to use:**

1. Generate a `.excalidraw` file
2. Drag it to https://dai-shi.github.io/excalidraw-animate/
3. Click Animate to preview, then export SVG or WebM

**File extension**: `.excalidraw`

---

## Diagram Types & Selection Guide

Choose the most suitable diagram type to improve clarity and visual impact.

| Type             | English      | Use Cases                                                       | Method                                                        |
| ---------------- | ------------ | --------------------------------------------------------------- | ------------------------------------------------------------- |
| **Flowchart**    | Flowchart    | Step-by-step instructions, workflows, task execution order      | Connect steps with arrows to show clear process direction     |
| **Mind Map**     | Mind Map     | Idea expansion, topic classification, brainstorming capture     | Start from a center node and branch outward radially          |
| **Hierarchy**    | Hierarchy    | Organizational structures, content levels, system decomposition | Build hierarchical nodes top-down or left-to-right            |
| **Relationship** | Relationship | Influence, dependency, and interaction between elements         | Use connecting lines, arrows, and notes to show links         |
| **Comparison**   | Comparison   | Compare two or more options or viewpoints                       | Use side-by-side columns or table-style comparison dimensions |
| **Timeline**     | Timeline     | Event progression, project schedules, model evolution           | Use time as the axis and mark key points/events               |
| **Matrix**       | Matrix       | Two-dimensional classification, priority, positioning           | Build X and Y dimensions and place items on the plane         |
| **Freeform**     | Freeform     | Fragmented content, idea capture, initial information gathering | Place blocks and arrows freely without rigid structure        |

## Design Rules

### Text & Format

- **All text elements must use** `fontFamily: 5` (Excalifont hand-drawn style)
- **Double quote replacement rule in text**: replace `"` with `『』`
- **Parentheses replacement rule in text**: replace `()` with `「」`
- **Font size rules** (hard lower bounds; below these values is unreadable at normal zoom):
  - Title: 20-28px (minimum 20px)
  - Subtitle: 18-20px
  - Body/labels: 16-18px (minimum 16px)
  - Secondary notes: 14px (for less important supporting notes only; use sparingly)
  - **Never go below 14px**
- **Line height**: all text must use `lineHeight: 1.25`
- **Text centering estimation**: standalone text elements are not auto-centered, so calculate `x` manually:
  - Estimate text width: `estimatedWidth = text.length * fontSize * 0.5` (for CJK characters use `* 1.0`)
  - Centering formula: `x = centerX - estimatedWidth / 2`
  - Example: text "Hello" (5 chars, fontSize 20) centered at x=300 -> `estimatedWidth = 5 * 20 * 0.5 = 50` -> `x = 300 - 25 = 275`

### Layout & Design

- **Canvas range**: keep all elements within 0-1200 x 0-800 when possible
- **Minimum shape size**: rectangles/ellipses with text should be at least 120x60px
- **Element spacing**: keep at least 20-30px spacing to prevent overlap
- **Clear hierarchy**: use different colors and shapes to distinguish information levels
- **Graphic elements**: use rectangles, circles, arrows, and similar shapes to organize information
- **No emoji**: do not use emoji in diagram text. For visual markers, use simple shapes (circle, square, arrow) or color distinctions

### Color Palette

**Text colors (strokeColor for text):**

| Purpose             | Color     | Notes                                                             |
| ------------------- | --------- | ----------------------------------------------------------------- |
| Title               | `#1e40af` | Deep blue                                                         |
| Subtitle/connectors | `#3b82f6` | Bright blue                                                       |
| Body text           | `#374151` | Dark gray (on white background, do not go lighter than `#757575`) |
| Emphasis/focus      | `#f59e0b` | Gold                                                              |

**Shape fill colors (backgroundColor, fillStyle: "solid"):**

| Color     | Meaning      | Typical Usage                                  |
| --------- | ------------ | ---------------------------------------------- |
| `#a5d8ff` | Light blue   | Inputs, data sources, main nodes               |
| `#b2f2bb` | Light green  | Success, outputs, completed items              |
| `#ffd8a8` | Light orange | Warnings, pending items, external dependencies |
| `#d0bfff` | Light purple | In-progress work, middleware, special items    |
| `#ffc9c9` | Light red    | Errors, critical items, alerts                 |
| `#fff3bf` | Light yellow | Notes, decisions, planning                     |
| `#c3fae8` | Light cyan   | Storage, data, cache                           |
| `#eebefa` | Light pink   | Analysis, metrics, statistics                  |

**Section background colors (large rectangles + `opacity: 30`, for layered diagrams):**

| Color     | Meaning                |
| --------- | ---------------------- |
| `#dbe4ff` | Frontend/UI layer      |
| `#e5dbff` | Logic/processing layer |
| `#d3f9d8` | Data/tools layer       |

**Contrast rules:**

- On white backgrounds, text must not be lighter than `#757575`
- On light fills, use darker text variants (for example, on light green use `#15803d`, not `#22c55e`)
- Avoid light gray text (`#b0b0b0`, `#999`) on white backgrounds

Reference: [references/excalidraw-schema.md](references/excalidraw-schema.md)

## JSON Structure

**Obsidian mode:**

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://github.com/zsviczian/obsidian-excalidraw-plugin",
  "elements": [...],
  "appState": { "gridSize": null, "viewBackgroundColor": "#ffffff" },
  "files": {}
}
```

**Standard / Animated mode:**

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [...],
  "appState": { "gridSize": null, "viewBackgroundColor": "#ffffff" },
  "files": {}
}
```

## Element Template

Each element requires these fields (do NOT add extra fields like `frameId`, `index`, `versionNonce`, `rawText` -- they may cause issues on excalidraw.com. `boundElements` must be `null` not `[]`, `updated` must be `1` not timestamps):

```json
{
  "id": "unique-id",
  "type": "rectangle",
  "x": 100,
  "y": 100,
  "width": 200,
  "height": 50,
  "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 1,
  "opacity": 100,
  "groupIds": [],
  "roundness": { "type": 3 },
  "seed": 123456789,
  "version": 1,
  "isDeleted": false,
  "boundElements": null,
  "updated": 1,
  "link": null,
  "locked": false
}
```

`strokeStyle` values: `"solid"` (solid, default) | `"dashed"` (dashed) | `"dotted"` (dotted). Dashed lines are useful for optional paths, async flows, or weak relationships.

Text elements add:

```json
{
  "text": "Display text",
  "fontSize": 20,
  "fontFamily": 5,
  "textAlign": "center",
  "verticalAlign": "middle",
  "containerId": null,
  "originalText": "Display text",
  "autoResize": true,
  "lineHeight": 1.25
}
```

**Animated mode additionally requires** a `customData` field:

```json
{
  "id": "title-1",
  "type": "text",
  "customData": {
    "animate": {
      "order": 1,
      "duration": 500
    }
  },
  ...other fields
}
```

See [references/excalidraw-schema.md](references/excalidraw-schema.md) for all element types.

---

## Additional Technical Requirements

### Text Elements handling

- The `## Text Elements` section in Markdown **must be empty**, using only `%%` as separators
- The Obsidian Excalidraw plugin **automatically fills text elements** from JSON data
- Do not manually list all text content

### Coordinates and layout

- **Coordinate system**: top-left corner is origin (0,0)
- **Recommended range**: keep all elements within 0-1200 x 0-800 px
- **Element IDs**: each element must have a unique `id` (string values such as "title" and "box1" are fine)

### Required Fields for All Elements

**IMPORTANT**: Do NOT include `frameId`, `index`, `versionNonce`, or `rawText` fields. Use `boundElements: null` (not `[]`), and `updated: 1` (not timestamps).

```json
{
  "id": "unique-identifier",
  "type": "rectangle|text|arrow|ellipse|diamond",
  "x": 100,
  "y": 100,
  "width": 200,
  "height": 50,
  "angle": 0,
  "strokeColor": "#color-hex",
  "backgroundColor": "transparent|#color-hex",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid|dashed|dotted",
  "roughness": 1,
  "opacity": 100,
  "groupIds": [],
  "roundness": { "type": 3 },
  "seed": 123456789,
  "version": 1,
  "isDeleted": false,
  "boundElements": null,
  "updated": 1,
  "link": null,
  "locked": false
}
```

### Text-Specific Properties

Text elements (`type: "text"`) require additional properties (do NOT include `rawText`):

```json
{
  "text": "Display text",
  "fontSize": 20,
  "fontFamily": 5,
  "textAlign": "center",
  "verticalAlign": "middle",
  "containerId": null,
  "originalText": "Display text",
  "autoResize": true,
  "lineHeight": 1.25
}
```

### appState configuration

```json
"appState": {
  "gridSize": null,
  "viewBackgroundColor": "#ffffff"
}
```

### files field

```json
"files": {}
```

## Common Mistakes to Avoid

- **Text offset** — For standalone text elements, `x` is the left edge, not center. You must calculate centering manually or text will drift to one side
- **Element overlap** — Elements with similar `y` values can stack. Check at least 20px spacing before placing new elements
- **Insufficient canvas padding** — Do not place content against canvas edges. Keep 50-80px padding around the layout
- **Title not centered over the diagram** — Center the title based on the overall diagram width, not at fixed `x=0`
- **Arrow label overflow** — Long labels (for example, "ATP + NADPH") can exceed short arrows. Keep labels concise or increase arrow length
- **Low contrast** — Light text on white is nearly invisible. Keep text at `#757575` or darker, and use darker variants for colored text
- **Font too small** — Below 14px is unreadable at normal zoom; body text minimum is 16px

## Implementation Notes

### Auto-save & File Generation Workflow

When generating an Excalidraw diagram, **you must automatically execute the following steps**:

#### 1. Select the most suitable diagram type

- Refer to the "Diagram Types & Selection Guide" table above based on the content characteristics provided by the user
- Analyze the core communication goal and choose the most suitable visualization form

#### 2. Generate a meaningful filename

Choose file extensions based on output mode:

| Mode     | Filename Pattern                    | Example                                          |
| -------- | ----------------------------------- | ------------------------------------------------ |
| Obsidian | `[topic].[type].md`                 | `business-model.relationship.md`                 |
| Standard | `[topic].[type].excalidraw`         | `business-model.relationship.excalidraw`         |
| Animated | `[topic].[type].animate.excalidraw` | `business-model.relationship.animate.excalidraw` |

- Prefer concise, descriptive naming for clarity

#### 3. Auto-save using the Write tool

- **Save location**: current working directory (detected automatically from environment variables)
- **Full path**: `{current_directory}/[filename].md`
- This keeps the workflow portable and avoids hardcoded paths

#### 4. Ensure the Markdown structure is exactly correct

**Must be generated in the following format** (no modifications allowed):

```markdown
---
excalidraw-plugin: parsed
tags: [excalidraw]
---

==⚠ Switch to EXCALIDRAW VIEW in the MORE OPTIONS menu of this document. ⚠== You can decompress Drawing data with the command palette: 'Decompress current Excalidraw file'. For more info check in plugin settings under 'Saving'

# Excalidraw Data

## Text Elements

%%

## Drawing

\`\`\`json
{Complete JSON data}
\`\`\`
%%
```

#### 5. JSON data requirements

- Include the complete Excalidraw JSON structure
- All text elements must use `fontFamily: 5`
- Replace `"` in text with `『』`
- Replace `()` in text with `「」`
- JSON must be valid and pass syntax checks
- All elements must have unique `id` values
- Include both `appState` and `files: {}` fields

#### 6. User feedback and confirmation

Report the following to the user:

- The diagram has been generated
- The exact save location
- How to view it in Obsidian
- Design rationale (what diagram type was selected and why)
- Whether adjustments or revisions are needed

### Example Output Messages

**Obsidian mode:**

```
Excalidraw diagram generated!

Saved to: business-model.relationship.md

How to use:
1. Open this file in Obsidian
2. Click the MORE OPTIONS menu in the top-right corner
3. Select Switch to EXCALIDRAW VIEW
```

**Standard mode:**

```
Excalidraw diagram generated!

Saved to: business-model.relationship.excalidraw

How to use:
1. Open https://excalidraw.com
2. Click the top-left menu -> Open -> select this file
3. Or drag the file directly onto the excalidraw.com page
```

**Animated mode:**

```
Excalidraw animated diagram generated!

Saved to: business-model.relationship.animate.excalidraw

Animation order: title (1) -> main framework (2-4) -> connectors (5-7) -> explanatory text (8-10)

Generate animation:
1. Open https://dai-shi.github.io/excalidraw-animate/
2. Click Load File and select this file
3. Preview the animation
4. Click Export to output SVG or WebM
```
