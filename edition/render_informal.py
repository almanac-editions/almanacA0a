#!/usr/bin/env python3
"""Render informal.html — the INK layer as a page, so all three layers have one.

TITLED "The informal proof", not "the informal layer": the Overseer named the front-page link and a
reader who clicks one phrase should land on a page carrying that phrase.

WHY. The orange layer had a page (the receipts ledger) and the blue layer had one (formal.html),
while the ink layer — the argument a human reads, and the one every other row presupposes — was a
row of raw links to two PDFs and a report. Three layers, two of them explained and one of them
handed over as files. The Overseer asked for the third (2026-09-04).

WHAT HEADS IT, and it is the Overseer's instruction rather than a layout choice: THE PAPER and THE
EXPLANATION. Those are the two documents written to be READ; everything below them — the signed
goal, the proof, the referee reports, the chain — is the record they are accountable to. A reader
who wants the mathematics gets it in the first screen; a reader who wants to check it scrolls.

IT INVENTS NOTHING. Every date, verdict, hash and sentence about the referee chain is read out of
CONCORDANCE.json's ink row, which carries them because that row was written to carry them. Where a
document does not ship, it is named and not linked, rather than linked and broken.
"""
import html
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_docs import MARK, PAGE, pdf_pages  # one page shell and one page-count, so the three layer pages cannot drift apart


def build(directory):
    con = json.load(open(os.path.join(directory, "CONCORDANCE.json"), encoding="utf-8"))
    ink = [r for r in con["rows"] if r.get("warrant") == "ink"]
    e = html.escape

    def have(rel):
        return os.path.exists(os.path.join(directory, rel))

    def link(rel, text, tail=""):
        """Link it if it ships; otherwise name it. A broken link is worse than a plain name."""
        return f'<a href="{e(rel)}">{text}</a>{tail}' if have(rel) else f"{text}{tail} <em>(not in this package)</em>"

    out = ["<h1>The informal proof</h1>",
           "<p>This is the <strong>ink</strong> layer: an argument written for a human reader and "
           "refereed. No proof kernel certifies it and no computation bounds it &mdash; the check is "
           "a referee reading the proof. It is also the layer every other row presupposes, because "
           "a kernel certifies <em>a formal statement</em> and something has to say that the "
           "statement is the one that was signed.</p>"]

    # ---------------------------------------------------------------- what heads the page
    pages = pdf_pages(os.path.join(directory, "paper.pdf"))
    pp = f", {pages}&nbsp;pp." if pages else ""
    out += ['<h2>Read it</h2>',
            '<table><tbody>',
            "<tr><td><strong>" + link("paper.pdf", "The paper") + f"</strong> (PDF{pp})</td>"
            "<td>The mathematics written up to be read: the statement for general "
            "<em>n</em>, which this edition does <strong>not</strong> prove, and the case "
            "<em>n</em>&nbsp;=&nbsp;1, which it does. Assembled from the documents below, every "
            "definition, statement and proof step lifted verbatim.</td></tr>",
            "<tr><td><strong>" + link("almanac.explained.html", "The mathematics explained") +
            "</strong></td><td>The same result at length, for a general reader, with the formulas "
            "typeset. No renderer, no network.</td></tr>",
            "</tbody></table>"]

    # ---------------------------------------------------------------- the record beneath them
    out += ["<h2>The record they are accountable to</h2>",
            "<p>The statement and the proof are <strong>separate documents on purpose</strong>: the "
            "goal was signed and hash-frozen before any proving began, so the claim &ldquo;the proof "
            "proves the statement that was signed&rdquo; has content that can be checked rather than "
            "assumed.</p>",
            "<ul>",
            "<li>" + link("source/informal/goalv0a.pdf", "The signed goal") + " (PDF) &mdash; also as "
            + link("source/informal/goalv0a.tex", "LaTeX source") + "</li>",
            "<li>" + link("source/informal/proofv0a.pdf", "The informal proof") + " (PDF) &mdash; also as "
            + link("source/informal/proofv0a.tex", "LaTeX source") + "</li>",
            "<li>" + link("source/informal/REFEREE_REPORT_PROOFv0a.html",
                          "The adversarial referee&rsquo;s report") + "</li>",
            "</ul>"]

    # ---------------------------------------------------------------- the chain, from the row
    for r in ink:
        ref = r.get("referee") or {}
        chain = ref.get("chain") or []
        if chain:
            out += ["<h2>How it was refereed</h2>",
                    "<table><thead><tr><th>stage</th><th>date</th><th>what happened</th>"
                    "</tr></thead><tbody>"]
            for st in chain:
                what = st.get("on_this_claim") or st.get("what") or ""
                bits = []
                if st.get("verdict"):
                    bits.append(f"<strong>{e(st['verdict'])}</strong>")
                if st.get("by"):
                    bits.append("by " + e(st["by"]))
                if st.get("read"):
                    bits.append("read: " + e(st["read"]))
                for key, label in (("read_sha256", "bytes read"), ("report_sha256", "report"),
                                   ("document_sha256", "document")):
                    if st.get(key):
                        bits.append(f"{label} <code>{e(st[key][:12])}&hellip;</code>")
                if st.get("report"):
                    rel = "source/informal/" + st["report"]
                    as_html = rel[:-3] + ".html"
                    if have(as_html):
                        bits.append(f'<a href="{e(as_html)}">the report</a>')
                    elif have(rel):
                        bits.append(f'<a href="{e(rel)}">the report</a>')
                    else:
                        bits.append("report <code>" + e(st["report"]) + "</code>")
                if st.get("document"):
                    rel = "source/informal/" + st["document"]
                    as_html = rel[:-3] + ".html"
                    if have(as_html):
                        bits.append(f'<a href="{e(as_html)}">the acceptance</a>')
                    elif have(rel):
                        bits.append(f'<a href="{e(rel)}">the acceptance</a>')
                if st.get("read_bytes_kept_at"):
                    bits.append("kept at <code>" + e(st["read_bytes_kept_at"]) + "</code>")
                lead = " &middot; ".join(bits)
                out.append(f"<tr><td><strong>{e(st.get('stage',''))}</strong></td>"
                           f"<td>{e(st.get('date',''))}</td>"
                           f"<td>{lead}{'<br>' if lead and what else ''}{e(what)}</td></tr>")
            out.append("</tbody></table>")

        if ref.get("independence"):
            out += ["<h2>What ink does not mean</h2>",
                    f"<p>{e(ref['independence'])}</p>"]

        if ref.get("the_limit_stated"):
            out += ["<h2>The limit, stated on its own face</h2>",
                    f"<blockquote><p>{e(ref['the_limit_stated'])}</p></blockquote>"]

        dv = ref.get("delta_verification") or {}
        if dv:
            out += ["<h3>What was done about it</h3>",
                    f"<p>{e(dv.get('what_was_compared',''))} &mdash; "
                    f"{e(dv.get('size_of_delta',''))}. Verified by {e(dv.get('by',''))}.</p>",
                    f"<p><strong>The decisive test.</strong> {e(dv.get('the_decisive_test',''))}</p>"]
            if dv.get("direction_of_the_three_deltas"):
                out.append("<p>Every change ran toward more rigour:</p><ul>")
                out += [f"<li>{e(d)}</li>" for d in dv["direction_of_the_three_deltas"]]
                out.append("</ul>")
            if dv.get("reproduced_by"):
                out.append(f"<p>{e(dv['reproduced_by'])}</p>")
            if dv.get("what_it_licenses"):
                out.append(f"<p><strong>{e(dv['what_it_licenses'])}</strong></p>")

        out += ["<h2>The row this layer carries</h2>",
                "<table><thead><tr><th>result</th><th>what it says</th></tr></thead><tbody>",
                f"<tr><td><strong>{e(r['id'])}</strong></td>"
                f"<td>{e((r.get('informal') or {}).get('statement',''))}</td></tr>",
                "</tbody></table>",
                f"<p>Its convention frame: {e(r.get('convention_frame',''))}</p>"]

    out += ["<p>Every other result in this edition is in "
            "<a href=\"index.html\">the concordance</a>, with the two layers that can be machine-"
            "checked: <a href=\"source/informal/proofv0a.ledger.cas_receipts.html\">the proof "
            "ledger</a> and <a href=\"formal.html\">the formal layer</a>.</p>"]

    open(os.path.join(directory, "informal.html"), "w", encoding="utf-8").write(
        PAGE.replace("__TITLE__", "The informal proof").replace("__BODY__", "\n".join(out))
            .replace("__MARK__", MARK).replace("__ROOT__", ""))
    return "informal.html"


if __name__ == "__main__":
    d = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.abspath(__file__))
    print("  rendered " + build(d))
