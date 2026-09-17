#!/usr/bin/env python3
"""Render the edition's markdown guides to HTML, so a browser shows a page and not a text file.

WHY. A web server hands `.md` to a browser as plain text; on the published site the guides arrived
as an unstyled wall. The Overseer asked for HTML and this is it. The markdown files STAY — they are
what an unzipped copy and an AI agent read, and `AGENTS.md` routes to one of them by name.

WHEN IT RUNS. Inside the build, AFTER the build-class banner is stamped into the markdown and
BEFORE checksums are taken. That ordering is not cosmetic: this build has already learned twice
that a transform applied after hashing puts a file on the reader's disk that the integrity record
does not describe.

DEPENDENCY: `markdown` (BSD-3-Clause), installed for the interpreter that runs this. It refuses
rather than degrading — a guide silently shipped as raw markup inside an .html file would look like
a rendering failure to every reader and like a success to the build.
"""
import html
import os
import re
import sys

# THE DEPENDENCY IS CHECKED WHERE IT IS USED, NOT AT IMPORT. This module is now also the one
# place the MARK and the warrant colours are defined, and four renderers import those. A module
# that exits on import took the whole build down with it when `markdown` was absent — measured
# 2026-09-04 on the Linux host, where the estate had moved and the package was not installed: five
# renderers that need nothing from markdown refused to run. It still refuses rather than
# degrading; it just refuses at the point of the act.
def _markdown():
    try:
        import markdown
    except ImportError:
        sys.exit("render_docs: needs the `markdown` package:  python3 -m pip install --user markdown")
    return markdown

DOCS = ["FOR_A_HUMAN.md", "FOR_AN_AI_AGENT.md", "EDITION.md",
        "EMBEDDING_NOTE.md", "AUTHORSHIP.md", "ANCESTRY.md",
        # markdown that lives deeper than the root but is still something a reader is sent to
        "source/informal/proofv0a.ledger.cas_receipts.md",
        "source/informal/REFEREE_REPORT_PROOFv0a.md",
        # the rest of the referee chain the ink layer's page walks a reader through. They shipped
        # as .md only, which a browser hands over as an unstyled wall - the same defect the guides
        # had before this file existed, left in place for the three documents that carry the
        # verdicts. Added 2026-09-04 with informal.html, which links them.
        "source/informal/EDITORIAL_REFEREE_REPORT_2026-08-12.md",
        "source/informal/EDITION_ACCEPTANCE_2026-08-13.md",
        "source/informal/CITATION_VERIFICATION_2026-08-09.md"]


# ---------------------------------------------------------------------------- THE MARK
# EVERY HTML FACE OF THIS ALMANAC CARRIES THE MARK (Overseer, 2026-09-04: "there should be an
# almanac logo ... on every html page in the almanac as well"). Six of the guides already carried
# the square cut, floated, because their MARKDOWN carries it and the markdown is also read
# unrendered; formal.html and the two source pages carried nothing at all. So the shell supplies it
# and skips the page that already has one — one mark per page, never two.
#
# TWO CUTS, ONE DRAWING (the rule the asset files already state): the SQUARE cut where the mark
# sits in a margin beside prose, the horizontal WORDMARK where it sits in a masthead. The wordmark
# is inline SVG rather than an <img> so it follows the page's own ink colour through the theme
# toggle and fetches nothing; the square cut is the shipped asset, in a <picture> so it follows
# prefers-color-scheme.
SERIES_URL = "https://github.com/almanac-editions"   # the series' home; every mark links here
MARK = ('<a href="https://github.com/almanac-editions" style="text-decoration:none;display:inline-block" '
        'aria-label="almanac editions — the series home">'
        '<picture class="mark">'
        '<source media="(prefers-color-scheme: dark)" srcset="__ROOT__almanac-mark-dark.svg">'
        '<img src="__ROOT__almanac-mark.svg" width="92" alt="almanac">'
        '</picture></a>')

# The three warrant colours as CSS variables, so a page that has its own palette can still set the
# mark's two coloured a's from ONE definition. The values are index.html's --cat-1/--cat-2 and its
# dark-theme pair; the mark must not be a different orange on a different page.
WARRANT_VARS = """
:root{--w-orange:#eb6834;--w-blue:#2a78d6}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--w-orange:#d95926;--w-blue:#3987e5}}
:root[data-theme="dark"]{--w-orange:#d95926;--w-blue:#3987e5}
"""


def pdf_pages(path):
    """How many pages a shipped PDF has, MEASURED — or None, and then nobody prints a number.

    Every reader-facing page-count in this edition has to come from here. "12 pp." was typed into
    the front page on 2026-09-04 and was correct that hour; the same day's sweep found three other
    typed counts that had stopped being true when the world moved, which is the whole argument
    against typing this one. pdfTeX compresses its object streams, so the naive /Type /Page scan
    finds nothing on our own PDFs — pdfinfo is tried first and the scan is the fallback for a host
    without poppler.
    """
    import shutil
    import subprocess
    if shutil.which("pdfinfo"):
        try:
            out = subprocess.run(["pdfinfo", path], capture_output=True, text=True, timeout=30)
            for line in out.stdout.splitlines():
                if line.startswith("Pages:"):
                    return int(line.split(":", 1)[1].strip())
        except (OSError, ValueError, subprocess.SubprocessError):
            pass
    try:
        with open(path, "rb") as fh:
            data = fh.read()
    except OSError:
        return None
    n = len(re.findall(rb"/Type\s*/Page[^s]", data))
    return n if 0 < n < 2000 else None


def wordmark(fill="var(--ink)", width=126, height=38, klass="wordmark"):
    """The horizontal ALMANAC wordmark (W1, adopted 2026-08-29), inline and asset-free.

    The word carries the form: "almanac" has exactly three a's, one per KIND OF WARRANT, and they
    run INK -> ORANGE -> BLUE left to right — the same order the layers are listed in and the
    concordance is filtered by. `textLength` pins the set width so a system-font fallback cannot
    reflow the mark.
    """
    # THE MARK IS THE SERIES' AND LINKS TO THE SERIES' HOME (the Overseer, 2026-09-17: "should not
    # clicking the almanac logo everywhere take us back to https://github.com/almanac-editions?").
    # The edition's own name in a masthead keeps linking to the edition; the mark is "almanac".
    return (f'<a href="{SERIES_URL}" style="text-decoration:none;display:inline-block" '
            'aria-label="almanac editions — the series home">'
            f'<svg class="{klass}" width="{width}" height="{height}" viewBox="0 0 190 58" '
            'role="img" aria-label="almanac">'
            '<text x="5" y="43" '
            'font-family="Georgia, \'Iowan Old Style\', \'Times New Roman\', serif" '
            f'font-size="44" fill="{fill}" textLength="180" lengthAdjust="spacingAndGlyphs">'
            'alm<tspan fill="var(--w-orange,#eb6834)">a</tspan>'
            'n<tspan fill="var(--w-blue,#2a78d6)">a</tspan>c</text></svg></a>')


PAGE = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>__TITLE__ — almanacA0a</title>
<style>
:root{--paper:#fbfbfa;--ink:#16181a;--dim:#585f66;--rule:#e3e6e8;--link:#2a78d6;--code:#f2f4f5}
@media (prefers-color-scheme:dark){
 :root{--paper:#14171a;--ink:#e9edf0;--dim:#9aa4ac;--rule:#2a3036;--link:#7cb2f2;--code:#1c2126}}
*{box-sizing:border-box}
body{background:var(--paper);color:var(--ink);margin:0;
 font:16.5px/1.65 -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif}
main{max-width:47rem;margin:0 auto;padding:2.6rem 1.2rem 5rem}
h1,h2,h3{line-height:1.25;margin:2.2rem 0 .7rem}
h1{font-size:1.8rem;margin-top:0} h2{font-size:1.28rem;border-bottom:1px solid var(--rule);padding-bottom:.3rem}
h3{font-size:1.06rem}
a{color:var(--link)} p,li{overflow-wrap:anywhere}
code{background:var(--code);padding:.12em .35em;border-radius:3px;font-size:.9em}
pre{background:var(--code);padding:.85rem 1rem;border-radius:5px;overflow-x:auto}
pre code{background:none;padding:0}
table{border-collapse:collapse;width:100%;margin:1rem 0;font-size:.94em;display:block;overflow-x:auto}
th,td{border:1px solid var(--rule);padding:.42rem .6rem;text-align:left;vertical-align:top}
blockquote{margin:1rem 0;padding:.1rem 1rem;border-left:3px solid var(--rule);color:var(--dim)}
hr{border:0;border-top:1px solid var(--rule);margin:2rem 0}
.back{display:inline-block;margin-bottom:1.6rem;font-size:.92em}
.mark{float:right;margin:0 0 1.2rem 1.5rem;width:92px}
.mark img{display:block;width:92px;height:auto}
@media (max-width:520px){.mark,.mark img{width:64px}}
img{max-width:100%;height:auto}
</style>
</head>
<body><main>
__MARK__
<a class="back" href="__ROOT__index.html">&larr; the almanac</a>
__BODY__
</main></body></html>
"""


def convert(directory):
    made = []
    markdown = _markdown()
    present = {d for d in DOCS if os.path.exists(os.path.join(directory, d))}
    for name in sorted(present):
        src = os.path.join(directory, name)
        text = open(src, encoding="utf-8").read()
        body = markdown.markdown(
            text, extensions=["extra", "sane_lists", "toc"], output_format="html5")
        # A link to a sibling guide should land on the guide's PAGE, not on its source. Only the
        # ones actually rendered here are rewritten - a link to a markdown file that stays markdown
        # must keep pointing at the file that exists.
        for other in present:
            body = body.replace(f'href="{other}"', f'href="{other[:-3]}.html"')
        title = next((re.sub(r"<[^>]+>", "", m) for m in re.findall(r"<h1[^>]*>(.*?)</h1>", body)),
                     name[:-3].replace("_", " ").title())
        out = os.path.join(directory, name[:-3] + ".html")
        os.makedirs(os.path.dirname(out), exist_ok=True)
        depth = name.count("/")
        # ONE MARK PER PAGE. Six of these guides carry the square cut in their own markdown — it is
        # there for the reader of the UNRENDERED file — and a shell that added a second would put
        # two marks on one page. Detection is on the rendered body, which is the thing that ships.
        mark = "" if "almanac-mark" in body else MARK
        open(out, "w", encoding="utf-8").write(
            PAGE.replace("__TITLE__", html.escape(title)).replace("__BODY__", body)
                .replace("__MARK__", mark).replace("__ROOT__", "../" * depth))
        made.append(os.path.relpath(out, directory))
    return made


if __name__ == "__main__":
    d = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.abspath(__file__))
    for f in convert(d):
        print(f"  rendered {f}")
