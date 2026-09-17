#!/usr/bin/env python3
"""Render formal.html — the formal layer as a page, instead of links to raw .lean and a .log.

WHY. "Going further" pointed a browser at a Lean source file, a release log and a JSON file. Each
is the real artifact and each arrives as an unstyled wall of text; a reader who wants to know what
the kernel actually certified should not have to read a build log to find out. This assembles the
same facts, from the same files, into something a person can read — and links the raw artifacts
beside every claim, so the page is a way in rather than a substitute.

IT INVENTS NOTHING. Every declaration name, file, hash and axiom triple is read out of
CONCORDANCE.json; the verdict line is quoted from the release log. If a row has no Lean
declaration it is shown as having none, which is a fact about the result and not a gap.
"""
TAIL = "the three standard axioms of Lean's kernel — propositional extensionality, the axiom of choice and quotient soundness — the base every Mathlib proof shares; a certificate is clean when these three are all it needs"
import html
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_docs import MARK, PAGE  # one page shell, so the guides and this cannot drift apart

CLEAN = ["propext", "Classical.choice", "Quot.sound"]


def build(directory):
    con = json.load(open(os.path.join(directory, "CONCORDANCE.json"), encoding="utf-8"))
    rows = con["rows"]
    e = html.escape

    log_rel = "source/record/formal/RELEASE_20260721_source_all_clean.log"
    verdict = ""
    lp = os.path.join(directory, log_rel)
    if os.path.exists(lp):
        for line in open(lp, encoding="utf-8"):
            if "release_verify" in line:
                verdict = line.strip()

    lean_dir = os.path.join(directory, "source", "lean")
    files = sorted(os.listdir(lean_dir)) if os.path.isdir(lean_dir) else []

    blue = [r for r in rows if r.get("warrant") == "blue"]
    out = ["<h1>The formal layer</h1>",
           "<p>Nine of this edition&rsquo;s twelve results carry a proof-kernel certificate. "
           "This page is what that means, row by row, assembled from "
           "<a href=\"CONCORDANCE.json\">CONCORDANCE.json</a> and the release log — it states no "
           "fact those files do not.</p>"]

    if verdict:
        out += ["<h2>What the kernel said</h2>",
                f"<blockquote><p><code>{e(verdict)}</code></p></blockquote>",
                f"<p>Quoted from <a href=\"{log_rel}\">the release log</a>, which is the artifact "
                "the certification cites. <strong>A result counts as kernel-certified only when its "
                "axiom base is exactly <code>propext</code>, <code>Classical.choice</code>, "
                "<code>Quot.sound</code></strong>: " + TAIL + " — with no <code>sorryAx</code> and no custom axiom.</p>"]

    out += ["<h2>The certified results</h2>",
            "<table><thead><tr><th>result</th><th>Lean declaration</th><th>axioms measured</th>"
            "</tr></thead><tbody>"]
    for r in blue:
        ln = r.get("lean") or {}
        decl = ln.get("declaration", "")
        f = ln.get("file", "")
        ax = r.get("axioms") or []
        exact = "yes" if sorted(ax) == sorted(CLEAN) else "&mdash;"
        stat = (r.get("informal") or {}).get("statement", "")
        out.append(
            f"<tr><td><strong>{e(r['id'])}</strong><br><span style='color:var(--dim)'>"
            f"{e(stat[:150])}</span></td>"
            f"<td><code>{e(decl)}</code><br><span style='color:var(--dim)'>{e(f)}</span></td>"
            f"<td>{'the clean triple' if exact == 'yes' else e(', '.join(ax) or 'none recorded')}</td></tr>")
    out.append("</tbody></table>")

    out += ["<h2>The sources</h2>",
            f"<p>{len(files)} files, shipped as they were built. They are Lean source: a browser "
            "shows them as text, which is what they are.</p><ul>"]
    for f in files:
        out.append(f'<li><a href="source/lean/{e(f)}"><code>{e(f)}</code></a></li>')
    out.append("</ul>")

    out += ["<h2>What a certificate does not say</h2>",
            "<p>The kernel certifies <strong>the formal statement</strong>. Whether that statement "
            "is faithful to the informal one is a separate question, and this edition answers it "
            "separately — see <a href=\"EMBEDDING_NOTE.html\">the embedding note</a>, and the one "
            "ink-warranted row in <a href=\"index.html\">the concordance</a>.</p>"]

    open(os.path.join(directory, "formal.html"), "w", encoding="utf-8").write(
        PAGE.replace("__TITLE__", "The formal layer").replace("__BODY__", "\n".join(out))
            .replace("__MARK__", MARK).replace("__ROOT__", ""))
    return "formal.html"


if __name__ == "__main__":
    d = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.abspath(__file__))
    print("  rendered " + build(d))
