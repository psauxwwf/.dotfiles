#!/usr/bin/env python3

import os
import re
import sys
from pathlib import Path


TARGET_FILES = [
    Path("/usr/share/themes/Dracula/gnome-shell/gnome-shell.css"),
    Path("/usr/share/themes/Dracula/gnome-shell/legacy/gnome-shell.css"),
]

SELECTOR_SIZES = {
    "stage": "13pt",
    ".notification-banner": "13pt",
    ".message-secondary-bin > .event-time": "13pt",
    ".summary-source-counter": "13pt",
}


def set_font_size(css_text: str, selector: str, size: str) -> tuple[str, bool]:
    pattern = re.compile(rf"({re.escape(selector)}\s*\{{)([^{{}}]*)(\}})", re.MULTILINE)
    match = pattern.search(css_text)
    if not match:
        return css_text, False

    body = match.group(2)
    if re.search(r"font-size\s*:\s*[^;]+;", body):
        new_body = re.sub(
            r"font-size\s*:\s*[^;]+;", f"font-size: {size};", body, count=1
        )
    else:
        if body.endswith("\n"):
            new_body = body + f"  font-size: {size};\n"
        else:
            new_body = body + f"\n  font-size: {size};\n"

    start, end = match.span()
    return css_text[:start] + match.group(1) + new_body + match.group(3) + css_text[
        end:
    ], True


def patch_file(path: Path) -> bool:
    if not path.exists():
        print(f"skip: {path} does not exist")
        return False

    original = path.read_text(encoding="utf-8")
    updated = original
    changed_selectors = []

    for selector, size in SELECTOR_SIZES.items():
        updated, changed = set_font_size(updated, selector, size)
        if changed:
            changed_selectors.append(f"{selector} -> {size}")

    if updated == original:
        print(f"no changes: {path}")
        return False

    backup = path.with_suffix(path.suffix + ".bak")
    if not backup.exists():
        backup.write_text(original, encoding="utf-8")

    path.write_text(updated, encoding="utf-8")
    print(f"patched: {path}")
    print(f"backup:  {backup}")
    for item in changed_selectors:
        print(f"  {item}")
    return True


def main() -> int:
    if os.geteuid() != 0:
        print(
            "Run this script with sudo so it can write into /usr/share/themes.",
            file=sys.stderr,
        )
        return 1

    changed_any = False
    for path in TARGET_FILES:
        changed_any = patch_file(path) or changed_any

    return 0 if changed_any else 1


if __name__ == "__main__":
    raise SystemExit(main())
