#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime
import shutil


def main() -> int:
    src_dir = Path("/usr/share/gnome-shell/extensions/pop-shell@system76.com")
    local_base = Path.home() / ".local/share/gnome-shell/extensions"
    dst_dir = local_base / "pop-shell@system76.com"

    if not dst_dir.exists():
        shutil.copytree(src_dir, dst_dir)

    file = dst_dir / "extension.js"
    ts = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = dst_dir / f"extension.js.bak-{ts}"
    shutil.copy2(file, backup)

    text = file.read_text()
    text_new = text.replace(
        """if (!indicator) {
            indicator = new PanelSettings.Indicator(ext);
            panel.addToStatusArea('pop-shell', indicator.button);
        }""",
        """if (!indicator) {
            indicator = new PanelSettings.Indicator(ext);
            panel.addToStatusArea('pop-shell', indicator.button);
            indicator.button.visible = false;
        }""",
    )
    text_new = text_new.replace(
        "indicator.button.visible = !sessionMode.isLocked;",
        "indicator.button.visible = false;",
    )

    if text_new == text:
        print("No changes applied: expected patterns not found")
        return 1

    file.write_text(text_new)
    print(f"Patched: {file}")
    print(f"Backup: {backup}")
    print("Reload extension:")
    print(
        "  gnome-extensions disable pop-shell@system76.com && gnome-extensions enable pop-shell@system76.com"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
