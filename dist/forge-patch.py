#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime
import subprocess
import sys

FILE = (
    Path.home()
    / ".local/share/gnome-shell/extensions/forge@jmmaranan.com/lib/extension/window.js"
)
OLD_CONDITION = """    for (let override of overrides) {
      // if the window is already floating
      if (override.wmClass === wmClass && override.mode === "float" && !override.wmTitle) return;
    }"""
NEW_CONDITION = """    for (let override of overrides) {
      // if the window is already floating
      if (
        override.wmClass === wmClass &&
        override.mode === "float" &&
        !override.wmTitle &&
        (!withWmId || override.wmId === wmId)
      )
        return;
    }"""
ASSIGN_LINE = "    this.ext.configMgr.windowProps = currentProps;"
CACHE_LINE = "    this.windowProps = currentProps;"


def find_method_block(src: str, method_name: str):
    start = src.find(f"  {method_name}(")
    if start == -1:
        return None
    brace_open = src.find("{", start)
    if brace_open == -1:
        return None
    depth = 0
    i = brace_open
    while i < len(src):
        ch = src[i]
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return start, i + 1
        i += 1
    return None


def patch_method(method_src: str):
    changed = False
    # 1) Patch old float check (only if old block exists)
    if OLD_CONDITION in method_src:
        method_src = method_src.replace(OLD_CONDITION, NEW_CONDITION, 1)
        changed = True
    # 2) Ensure cache refresh line exists exactly after assignment line (once)
    idx = method_src.find(ASSIGN_LINE)
    if idx != -1:
        insert_at = idx + len(ASSIGN_LINE)
        after = method_src[insert_at:]
        expected_prefix = "\n" + CACHE_LINE
        if not after.startswith(expected_prefix):
            method_src = (
                method_src[:insert_at] + expected_prefix + method_src[insert_at:]
            )
            changed = True
    return method_src, changed


def main():
    if not FILE.exists():
        print(f"File not found: {FILE}")
        sys.exit(1)
    src = FILE.read_text(encoding="utf-8")
    original = src
    changed_any = False
    for method in ("addFloatOverride", "removeFloatOverride"):
        block = find_method_block(src, method)
        if not block:
            continue
        start, end = block
        method_src = src[start:end]
        patched_method_src, changed = patch_method(method_src)
        if changed:
            src = src[:start] + patched_method_src + src[end:]
            changed_any = True
    if not changed_any:
        print("Already patched (no changes needed).")
        return
    backup = FILE.with_name(FILE.name + f".bak.{datetime.now():%Y%m%d-%H%M%S}")
    backup.write_text(original, encoding="utf-8")
    FILE.write_text(src, encoding="utf-8")
    print(f"Patch applied: {FILE}")
    print(f"Backup created: {backup}")
    # Restart extension to apply changes
    for cmd in (
        ["gnome-extensions", "disable", "forge@jmmaranan.com"],
        ["gnome-extensions", "enable", "forge@jmmaranan.com"],
    ):
        subprocess.run(cmd, check=False)
    print("Forge restarted. Done.")


if __name__ == "__main__":
    raise SystemExit(main())
