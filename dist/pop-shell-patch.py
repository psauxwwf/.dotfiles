#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime
import shutil


def main() -> int:
    src_dir = Path("/usr/share/gnome-shell/extensions/pop-shell@system76.com")
    local_base = Path.home() / ".local/share/gnome-shell/extensions"
    dst_dir = local_base / "pop-shell@system76.com"
    file = dst_dir / "extension.js"
    block_old = """if (!indicator) {
            indicator = new PanelSettings.Indicator(ext);
            panel.addToStatusArea('pop-shell', indicator.button);
        }"""
    block_new = """if (!indicator) {
            indicator = new PanelSettings.Indicator(ext);
            panel.addToStatusArea('pop-shell', indicator.button);
            indicator.button.visible = false;
        }"""
    line_old = "indicator.button.visible = !sessionMode.isLocked;"
    line_new = "indicator.button.visible = false;"
    # Ensure local extension exists
    if not dst_dir.exists():
        if not src_dir.exists():
            print(f"Source extension directory not found: {src_dir}")
            return 1
        local_base.mkdir(parents=True, exist_ok=True)
        shutil.copytree(src_dir, dst_dir)
        print(f"Copied extension to: {dst_dir}")
    if not file.exists():
        print(f"File not found: {file}")
        return 1
    text = file.read_text(encoding="utf-8")
    # Idempotency check: already patched
    already_patched = (block_new in text) and (line_old not in text)
    if already_patched:
        print("Already patched. No changes needed.")
        return 0
    # Apply patch only if expected old patterns exist
    if block_old not in text and block_new not in text:
        print("Expected indicator block not found (neither old nor patched form).")
        return 1
    if line_old not in text and line_new not in text:
        print("Expected visibility line not found (neither old nor patched form).")
        return 1
    text_new = text.replace(block_old, block_new)
    text_new = text_new.replace(line_old, line_new)
    if text_new == text:
        print("No textual changes produced. Nothing to do.")
        return 0
    ts = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = dst_dir / f"extension.js.bak-{ts}"
    shutil.copy2(file, backup)
    file.write_text(text_new, encoding="utf-8")
    print(f"Patched: {file}")
    print(f"Backup: {backup}")
    print("Reload extension:")
    print(
        "  gnome-extensions disable pop-shell@system76.com && gnome-extensions enable pop-shell@system76.com"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
