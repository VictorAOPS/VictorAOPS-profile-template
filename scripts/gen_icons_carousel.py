#!/usr/bin/env python3
import argparse
import io
import re
import sys
import urllib.parse
import urllib.request

import cairosvg
from PIL import Image


def parse_skillicons_urls(text: str):
    # NOTE: Use single backslashes inside a raw string.
    # - `\.` matches a literal dot
    # - `\?` matches a literal question mark
    urls = re.findall(r"https://skillicons\.dev/icons\?[^\s\)\"']+", text)
    frames = []
    for url in urls:
        parsed = urllib.parse.urlparse(url)
        qs = urllib.parse.parse_qs(parsed.query)
        ids_raw = (qs.get("i") or [""])[0]
        if not ids_raw:
            continue
        ids = [s for s in ids_raw.split(",") if s]
        perline_raw = (qs.get("perline") or [str(len(ids))])[0]
        try:
            perline = int(perline_raw)
        except ValueError:
            perline = len(ids)
        theme = (qs.get("theme") or ["dark"])[0]
        frames.append((ids_raw, perline, theme))
    return frames


def fetch_svg(ids_raw: str, perline: int, theme: str) -> bytes:
    url = f"https://skillicons.dev/icons?i={ids_raw}&theme={theme}&perline={perline}"
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return r.read()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", default="STACK_ICONS.md")
    ap.add_argument("--output", default="images/icons/icons-carousel.gif")
    ap.add_argument("--duration-ms", type=int, default=1100)
    args = ap.parse_args()

    try:
        text = open(args.input, "r", encoding="utf-8").read()
    except FileNotFoundError:
        print(f"Missing input file: {args.input}", file=sys.stderr)
        return 2

    frames = parse_skillicons_urls(text)
    if not frames:
        print("No skillicons.dev URLs found in input.", file=sys.stderr)
        return 2

    # Transparent background so the GIF blends with GitHub theme.
    bg = (0, 0, 0, 0)
    pad_x, pad_y = 18, 14

    imgs = []
    max_w = 0
    max_h = 0
    for ids_raw, perline, theme in frames:
        svg = fetch_svg(ids_raw, perline, theme)
        # Render at intrinsic size (48px icons) so it matches skillicons rows.
        png_bytes = cairosvg.svg2png(bytestring=svg)
        icon = Image.open(io.BytesIO(png_bytes)).convert("RGBA")
        canvas = Image.new("RGBA", (icon.width + pad_x * 2, icon.height + pad_y * 2), bg)
        canvas.alpha_composite(icon, (pad_x, pad_y))
        imgs.append(canvas)
        max_w = max(max_w, canvas.width)
        max_h = max(max_h, canvas.height)

    padded = []
    for im in imgs:
        out = Image.new("RGBA", (max_w, max_h), bg)
        x = (max_w - im.width) // 2
        y = (max_h - im.height) // 2
        out.alpha_composite(im, (x, y))
        padded.append(out)

    padded[0].save(
        args.output,
        save_all=True,
        append_images=padded[1:],
        duration=args.duration_ms,
        loop=0,
        disposal=2,
        optimize=True,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
