#!/usr/bin/env python3
"""Sort glossary.yaml by 'short' in 五十音順 (Japanese reading order).

Required:
  pip install pykakasi

Usage:
  python sort_glossary.py
"""
import re
import sys
from pathlib import Path

try:
    import pykakasi
except ImportError:
    print("Required: pip install pykakasi", file=sys.stderr)
    sys.exit(1)


def reading_key(short: str, kks) -> str:
    """Convert Japanese to hiragana for 五十音順 sort."""
    if not short:
        return ""
    result = kks.convert(short)
    return "".join(item.get("hira", item.get("orig", "")) for item in result)


def parse_blocks(text: str) -> list[tuple[str, str, str]]:
    """Split YAML into blocks. Returns list of (key, short_value, full_block)."""
    blocks = []
    key_re = re.compile(r"^([a-z][a-z0-9-]*):\s*$", re.MULTILINE)
    short_re = re.compile(r"^  short:\s*(.+)\s*$", re.MULTILINE)

    for m in key_re.finditer(text):
        key = m.group(1)
        start = m.start()
        next_m = key_re.search(text, start + 1)
        end = next_m.start() if next_m else len(text)
        block = text[start:end].rstrip()
        short_m = short_re.search(block)
        short_val = short_m.group(1).strip() if short_m else ""
        blocks.append((key, short_val, block))
    return blocks


def main() -> None:
    kks = pykakasi.kakasi()
    p = Path(__file__).parent / "glossary.yaml"
    text = p.read_text(encoding="utf-8")
    blocks = parse_blocks(text)
    blocks.sort(key=lambda b: reading_key(b[1], kks))

    out = "\n\n".join(block for _, _, block in blocks) + "\n"
    p.write_text(out, encoding="utf-8")
    print("Sorted glossary.yaml by short (五十音順)")


if __name__ == "__main__":
    main()
