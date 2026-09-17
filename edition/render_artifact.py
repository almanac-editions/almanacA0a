#!/usr/bin/env python3
"""Render the READER'S EDITION of almanacA0a — the artifact form.

Generated from CONCORDANCE.json and MANIFEST.json at render time. There is no transcription
step anywhere in this file: every row, count, hash and pin is read from the edition's own
data. Transcription is where this pilot's two substantive errors entered, and the reader's
edition is the last place that should be reintroduced.

Emits almanac.artifact.html — a fragment (no doctype/html/head/body), for publishing.
"""
import html
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_docs import WARRANT_VARS, wordmark  # one mark, defined once

D = os.path.dirname(os.path.abspath(__file__))
C = json.load(open(os.path.join(D, "CONCORDANCE.json")))
M = json.load(open(os.path.join(D, "MANIFEST.json")))
GAPS = open(os.path.join(D, "gaps", "GAPS.md")).read()

CAPRUN = re.compile(r"\b(?:[A-Z][A-Z0-9''\-]{2,}(?:\s+|$)){2,}")


def esc(x):
    return html.escape(str(x)) if x is not None else ""


def rich(text):
    """Escape, then bold the author's own ALL-CAPS emphasis runs. Text is never altered."""
    s = esc(text)
    return CAPRUN.sub(lambda m: "<strong>" + m.group(0).rstrip() + "</strong> ", s)


rows = C["rows"]
cnt = {}
for r in rows:
    cnt[r["warrant"]] = cnt.get(r["warrant"], 0) + 1
n_k, n_c = cnt.get("blue", 0), cnt.get("orange", 0)
n_gaps = GAPS.count("\n### ")
cards = M.get("card_artifacts", [])
subs, eds = M["substrate_artifacts"], M["edition_artifacts"]
n_ship = len(subs) + len(eds) + len(cards)
rec = M["reproducibility_recipe"]
# 2026-08-30: the register carries PATH + HASH, with no links. The old BASE pointed at the
# estate's internal Tailscale server — unreachable from outside (and inside: ISTA blocks
# Tailscale), and an internal address does not belong in a shipped page. A reader locates
# a file by its path in the record or in the distributable, and verifies it by its hash.

GROUP_ORDER = [
    ("informal", "The manuscript", "The statement and its proof, in source and typeset form."),
    ("formal", "The formal development", "Lean sources and the certification record."),
    ("instrument", "The instrument", "The Julia package, with the dependency pin that makes it re-runnable."),
    ("oracle", "The oracle referee", "The independent computational check on the span identity."),
    ("semiformal", "The claim ledger", "Every computational claim with its declared range, and the oracle receipts."),
    ("card", "The cards", "This project's own writing about other people's statements, each with its convention frame."),
    ("ancestry", "Ancestry", "The citation-verification cycle of record."),
    ("referee report on the proof", "Referee report", ""),
    ("editorial referee report (criterion 6)", "Editorial referee report", ""),
    ("faithfulness", "Faithfulness panel", "Three independent engines judging whether the formal statement says what the manuscript says."),
    ("closure", "Closure records", ""),
    ("edition", "The edition itself", "Including the machine-readable register and manifest."),
]


def group_of(a):
    return a["role"].split(":")[0]


def artifact_index():
    all_a = M["substrate_artifacts"] + M["edition_artifacts"] + M["card_artifacts"]
    by = {}
    for a in all_a:
        by.setdefault(group_of(a), []).append(a)
    # A role whose prefix is not in GROUP_ORDER would be dropped from the page in
    # silence, while the manifest went on claiming the set is complete. Fail loud.
    unknown = sorted(set(by) - {k for k, _, _ in GROUP_ORDER})
    if unknown:
        raise SystemExit(f"render_artifact: {len(unknown)} role group(s) not in "
                         f"GROUP_ORDER, would ship unlisted: {unknown}")
    out = []
    for key, title, blurb in GROUP_ORDER:
        items = sorted(by.get(key, []), key=lambda x: x["path"])
        if not items:
            continue
        out.append(f'<details class="grp"><summary><span class="gname">{esc(title)}</span>'
                   f'<span class="gcount">{len(items)}</span></summary>')
        if blurb:
            out.append(f'<p class="gblurb">{esc(blurb)}</p>')
        out.append('<ul class="files">')
        for a in items:
            name = a["path"].rsplit("/", 1)[-1]
            # F-E10: a file cannot carry its own hash. The manifest records null there
            # rather than the previous render's value; say so on the page instead of
            # printing twelve characters that will never resolve.
            # AND THE PAGE DECIDES THIS BY PATH, NOT BY WHETHER THE MANIFEST HAPPENS TO HOLD
            # A HASH (2026-09-13, the Ethics Officer's cold re-run): --repin had been writing a
            # real hash into this page's own row, so the page printed its previous render's
            # hash, and a render -> re-pin -> render loop could never settle. A page's own row
            # is self-referential whatever the manifest says about it.
            own = a["path"].endswith("/almanac.artifact.html")
            h = (f'{esc(a["sha256"])[:12]}…' if a.get("sha256") and not own
                 else "self-referential — no hash")
            out.append(f'<li><span class="fname">{esc(name)}</span>'
                       f'<span class="fpath">{esc(a["path"])}</span>'
                       f'<span class="fhash mono">{h}</span></li>')
        out.append("</ul></details>")
    return "".join(out)


P = []
A = P.append

# A COMPLETE DOCUMENT, NOT A FRAGMENT. This page began at <title> — no doctype, no <html>,
# no <head>, and so NO CHARSET AND NO VIEWPORT. Two consequences, both found by serving the
# built almanac over the tailnet and looking at it on a phone (2026-09-03): a browser with no
# charset falls back to Latin-1 and every em dash arrives as \u00e2\u20ac\u201d, and with no
# viewport the page renders at desktop width on a handset. index.html and almanac.html always
# had these; these two never did.
A("<!DOCTYPE html>")
A("<html lang='en'><head>")
A("<meta charset='utf-8'>")
A("<meta name='viewport' content='width=device-width, initial-scale=1'>")
A("<title>almanacA0a — a bilateral q-Pólya theorem</title>")

A("""<style>
:root{
  --paper:#f3f5f6; --panel:#e9edef; --ink:#16191c; --dim:#525a61; --faint:#7d868d;
  --rule:#d3dade; --hair:#e2e7ea; --struct:#2f4a6b;
  --kern:#1f5f5b; --comp:#7a5a18; --caution:#8c3a2e;
  --measure:1680px;   /* the SHEET fills the screen; prose is metered separately */
  --prose:88ch;       /* readable line length inside a wide page */
}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){
  --paper:#101315; --panel:#191d20; --ink:#e6eaed; --dim:#a2abb2; --faint:#79838a;
  --rule:#2a3034; --hair:#22282c; --struct:#8fb0d2;
  --kern:#74b8b1; --comp:#c9a461; --caution:#e09383;
}}
:root[data-theme="dark"]{
  --paper:#101315; --panel:#191d20; --ink:#e6eaed; --dim:#a2abb2; --faint:#79838a;
  --rule:#2a3034; --hair:#22282c; --struct:#8fb0d2;
  --kern:#74b8b1; --comp:#c9a461; --caution:#e09383;
}
*{box-sizing:border-box}
body{
  margin:0; background:var(--paper); color:var(--ink);
  font:400 17px/1.65 Charter,"Iowan Old Style","Palatino Linotype",Palatino,"Times New Roman",serif;
  -webkit-font-smoothing:antialiased;
  padding-inline:clamp(1.25rem,4vw,4.5rem);
}
.sheet{max-width:var(--measure); margin-inline:auto; padding-block:4.5rem 7rem}
@media(max-width:640px){.sheet{padding-block:2.75rem 4.5rem}}
/* narrative prose gets a measure; the register and tables use the full sheet */
p,.lede,li,.deck{max-width:var(--prose)}

.lbl{font-family:ui-sans-serif,-apple-system,"Segoe UI",system-ui,sans-serif;
  font-size:.68rem; font-weight:600; letter-spacing:.13em; text-transform:uppercase; color:var(--faint)}
.mono,code{font-family:ui-monospace,"SF Mono",Menlo,Consolas,monospace; font-size:.84em}
code{background:var(--panel); padding:.1em .34em; border-radius:2px}

.masthead{border-top:3px solid var(--ink); padding-top:1.1rem}
h1{font-size:clamp(2rem,5.5vw,2.85rem); line-height:1.08; margin:.4rem 0 .5rem;
  font-weight:600; letter-spacing:-.018em; text-wrap:balance}
.deck{font-size:1.12rem; color:var(--dim); margin:0 0 1.4rem; text-wrap:balance}
.byline{display:flex; flex-wrap:wrap; gap:.4rem 1.4rem; padding:.8rem 0;
  border-top:1px solid var(--hair); border-bottom:1px solid var(--hair)}

.state{display:flex; flex-wrap:wrap; gap:.45rem; margin:1.3rem 0}
.pill{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.7rem;
  font-weight:600; letter-spacing:.09em; text-transform:uppercase;
  padding:.32rem .62rem; border:1px solid currentColor; border-radius:2px; color:var(--dim)}
.pill.on{color:var(--struct)} .pill.off{color:var(--caution)}

h2{font-size:1.34rem; font-weight:600; letter-spacing:-.008em; margin:3.6rem 0 .2rem; text-wrap:balance}
h2+.rule{height:2px; background:var(--ink); margin-bottom:1.1rem}
h3{font-size:1.02rem; font-weight:600; margin:2.1rem 0 .45rem}
p{margin:0 0 1.05rem; text-wrap:pretty} .lede{font-size:1.1rem; color:var(--dim)}
.fine{font-size:.9rem; color:var(--dim)}

.disclose{border-left:2px solid var(--caution); padding:.15rem 0 .15rem 1.1rem; margin:1.5rem 0}
.disclose .lbl{color:var(--caution); display:block; margin-bottom:.3rem}

.split{display:grid; gap:0; margin:1.2rem 0 .4rem}
.grade{display:grid; grid-template-columns:auto 1fr; gap:.2rem 1rem; align-items:baseline;
  padding:.85rem 0; border-top:1px solid var(--hair)}
.grade:last-child{border-bottom:1px solid var(--hair)}
.grade .n{font-size:1.75rem; font-weight:600; font-variant-numeric:tabular-nums; line-height:1}
.grade .of{color:var(--faint); font-size:.9rem; font-weight:400}
.grade .name{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.74rem;
  font-weight:700; letter-spacing:.11em; text-transform:uppercase}
.grade .what{grid-column:2; font-size:.92rem; color:var(--dim); max-width:var(--prose)}
.g-k .n,.g-k .name{color:var(--kern)} .g-c .n,.g-c .name{color:var(--comp)}
.g-i .n,.g-i .name{color:var(--ink)}

.register{margin:1.6rem 0}
.entry{display:grid; grid-template-columns:8rem minmax(0,1fr); gap:0 2.2rem;
  padding:2.1rem 0; border-top:1px solid var(--rule)}
.entry:last-child{border-bottom:1px solid var(--rule)}
@media(max-width:640px){.entry{grid-template-columns:1fr; gap:.7rem}}
.gutter{display:flex; flex-direction:column; gap:.4rem}
.gutter .id{font-family:ui-monospace,"SF Mono",Menlo,monospace; font-size:.72rem;
  color:var(--faint); letter-spacing:.02em}
.wbadge{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.62rem;
  font-weight:700; letter-spacing:.1em; text-transform:uppercase; line-height:1.35;
  padding-top:.35rem; border-top:2px solid currentColor}
.w-k{color:var(--kern)} .w-c{color:var(--comp)}
.w-i{color:var(--ink)}
.claim{font-size:1.12rem; line-height:1.45; margin:0 0 1.15rem; max-width:var(--prose); text-wrap:pretty}
.facets{display:grid; grid-template-columns:5.6rem minmax(0,1fr); gap:.55rem 1.3rem; margin:0;
  font-size:.945rem; line-height:1.58; align-items:baseline}
.facets.short{margin-bottom:1rem; padding-bottom:.9rem; border-bottom:1px dotted var(--hair)}
@media(min-width:1000px){
  .facets.short{grid-template-columns:5.6rem minmax(0,1fr) 5.6rem minmax(0,1fr); column-gap:2.6rem}
}
.facets dt{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.64rem;
  font-weight:600; letter-spacing:.11em; text-transform:uppercase; color:var(--faint); padding-top:.18rem}
.facets dd{margin:0; color:var(--dim)}
.facets.long dd{max-width:var(--prose)}
.alsodecl{display:inline-block; color:var(--faint); font-size:.94em}
.src dt{font-family:inherit; font-size:.95rem; font-weight:600; color:var(--ink)}
.src{grid-template-columns:minmax(0,11rem) minmax(0,1fr)}
.facets dd.strong{color:var(--ink)}
@media(max-width:640px){.facets,.facets.short{grid-template-columns:1fr; gap:.15rem}
  .facets dt{margin-top:.55rem}}

.tbl{width:100%; border-collapse:collapse; font-size:.92rem; margin:1rem 0}
.tbl th,.tbl td{text-align:left; padding:.52rem .7rem .52rem 0; border-bottom:1px solid var(--hair);
  vertical-align:top}
.tbl th{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.66rem;
  font-weight:600; letter-spacing:.11em; text-transform:uppercase; color:var(--faint)}
.tbl td.num{font-variant-numeric:tabular-nums; white-space:nowrap}
.scroll{overflow-x:auto}
ul{margin:0 0 1rem; padding-left:1.15rem} li{margin:0 0 .4rem}
a{color:var(--struct)}
.display{font-size:1.06rem; margin:1.1rem 0 1.3rem; padding:.9rem 0;
  border-top:1px solid var(--hair); border-bottom:1px solid var(--hair); max-width:none}
.display code{background:none; padding:0; font-size:1em}
.grp{border-top:1px solid var(--hair)}
.grp:last-of-type{border-bottom:1px solid var(--hair)}
.grp summary{cursor:pointer; padding:.7rem 0; display:flex; gap:.9rem; align-items:baseline;
  list-style:none}
.grp summary::-webkit-details-marker{display:none}
.grp summary::before{content:"+"; font-family:ui-monospace,Menlo,monospace; color:var(--faint);
  font-size:.95rem; width:1ch}
.grp[open] summary::before{content:"–"}
.grp summary:focus-visible{outline:2px solid var(--struct); outline-offset:3px}
.gname{font-weight:600}
.gcount{font-family:ui-monospace,Menlo,monospace; font-size:.78rem; color:var(--faint);
  font-variant-numeric:tabular-nums}
.gblurb{font-size:.9rem; color:var(--dim); margin:0 0 .6rem 2ch; max-width:var(--prose)}
.files{list-style:none; margin:0 0 .9rem; padding:0 0 0 2ch;
  display:grid; grid-template-columns:1fr; gap:.3rem}
@media(min-width:1000px){.files{grid-template-columns:repeat(2,minmax(0,1fr)); column-gap:2.6rem}}
.files li{display:grid; grid-template-columns:minmax(0,1fr) auto; gap:.1rem .9rem;
  align-items:baseline; font-size:.9rem; padding-bottom:.25rem;
  border-bottom:1px dotted var(--hair)}
.files a{text-decoration:none; border-bottom:1px solid var(--rule)}
.files a:hover{border-bottom-color:var(--struct)}
.fname{font-weight:620}
.fpath{grid-column:1/-1; font-family:ui-monospace,Menlo,monospace; font-size:.7rem;
  color:var(--faint); word-break:break-all}
.fhash{font-size:.7rem; color:var(--faint)}
.stems{display:grid; grid-template-columns:minmax(0,10rem) minmax(0,1fr); gap:.4rem 1.3rem;
  font-size:.93rem; margin:1rem 0}
@media(max-width:640px){.stems{grid-template-columns:1fr; gap:.1rem}}
.stems dt{font-family:ui-monospace,Menlo,monospace; font-size:.86rem; color:var(--ink)}
.stems dd{margin:0; color:var(--dim)}
.colophon{margin-top:4.5rem; padding-top:1.3rem; border-top:3px solid var(--ink);
  font-size:.86rem; color:var(--dim)}

/* THE MARK, on every html face of the almanac (Overseer, 2026-09-04). Horizontal cut here,
   because it sits in a masthead and the square cut is for a margin beside prose. */
.wordmark{display:block;margin:0 0 .7rem;height:38px;width:126px}
__WARRANT_VARS__
</style>""")

A('<div class="sheet"><div class="masthead">')
A("__WORDMARK__")
A('<div class="lbl">Project Sandbox · Almanac series · pilot edition</div>')
A("<h1>almanacA0a</h1>")
A('<p class="deck">The Laurent polynomials taking values in <code>A_t</code> at every point of the '
  "multiplicative grid are exactly the <code>A_t</code>-span of the divided classes.</p>")
A(f'<div class="byline"><span class="lbl">Tamás Hausel</span>'
  f'<span class="lbl">assembled {esc(C["assembled_utc"])}</span>'
  f'<span class="lbl">{len(rows)} entries · {n_ship} artifacts</span></div>')
A("</div>")

A('<h2>The theorem</h2><div class="rule"></div>')
A('<p class="lede">Let <code>v, t</code> be independent indeterminates and <code>q = v²</code>. Write '
  "<code>A_t = ℤ[v^{±1}, t^{±1}]</code> and <code>F_t = ℚ(v)[t^{±1}]</code>. For <code>χ ∈ ℤ</code> "
  "let <code>ev_χ</code> be the <code>F_t</code>-algebra map with <code>ev_χ(Y̌) = q^χ</code>, and "
  "put <code>ν_0 = 1</code>, <code>ν_r(X) = ∏_{s&lt;r} (X − q^s)/(q^r − q^s)</code>.</p>")
A("<p><strong>The polynomials have coefficients in <code>F_t</code>; what is required to lie in "
  "<code>A_t</code> are their values.</strong> That gap is the whole of the theorem — with "
  "coefficients already in <code>A_t</code> there would be nothing to prove.</p>")
A('<p class="display"><code>N^ev = Σ<sub>u∈ℤ</sub> Σ<sub>r≥0</sub> A_t · Y̌^u ν_r(Y̌)</code></p>')
A("<p><strong>The divided classes are genuinely needed</strong>, and one element shows it. It is not "
  "the case that every grid-integral Laurent polynomial already has its coefficients in "
  "<code>A_t</code> — that is refuted by <code>ν_1(Y̌) = (Y̌−1)/(q−1)</code>, which lies in "
  "<code>N^ev</code> and not in <code>A_t[Y̌^{±1}]</code>: its value at <code>Y̌ = q^χ</code> is "
  "<code>(q^χ−1)/(q−1) = 1 + q + ⋯ + q^{χ−1}</code>, integral at every node, while its one coefficient "
  "<code>(q−1)^{-1}</code> is not in <code>A_t</code>. So <code>A_t[Y̌^{±1}] ⊊ N^ev</code>, strictly.</p>")
A("<p><strong>This is a spanning statement, not a basis theorem, and it does not improve to one.</strong> "
  "The generating family satisfies the relation <code>(q−1)·ν_1(Y̌) − Y̌ + 1 = 0</code> over "
  "<code>A_t</code>, so it is not independent. Whether <code>N^ev</code> is free over <code>A_t</code> "
  "on some other family is open.</p>")
A("<p><strong>The evenness of the grid is a hypothesis, not a convenience.</strong> It is not the "
  "case that the divided classes stay integral when the grid is refined from the even nodes "
  "<code>q^χ = v^{2χ}</code> to all powers of <code>v</code> — that is refuted by a single value. "
  "Since <code>q = v²</code>, at the odd node <code>v³</code> one has "
  "<code>ν_1(v³) = (v³−1)/(v²−1) = (v²+v+1)/(v+1)</code>, which is not in <code>A_t</code>, while "
  "<code>ν_1</code> is integral at every even node. Refine the grid and the theorem fails.</p>")

A('<h2>Where the statement came from</h2><div class="rule"></div>')
A("<p>The signed goal states three clauses about the even hybrid family form at rank one: that it is "
  "an <code>A_t</code>-subalgebra, that the Harish–Chandra projection restricts to an isomorphism "
  "onto the Weyl-invariants, and the span identity above.</p>")
A("<p><strong>At <em>GL</em><sub>1</sub> the first two are formalities.</strong> The root system is "
  "empty, so the algebra is commutative and its centre is the whole of it; the Weyl group is trivial, "
  "so the invariance condition is empty; and the Harish–Chandra projection is the identity map. They "
  "are recorded because the goal was posed as the rank-one case of a programme about centres in "
  "higher rank, where they carry weight. <strong>The mathematics in this record is the span "
  "identity</strong>, and this edition is about that.</p>")

A('<h2>How the theorem descends</h2><div class="rule"></div>')
A("<p><strong>The statement proved here is a known theorem</strong>, reached along a line that is "
  "worth setting out, because each step changed what the question was about. Every source named "
  "below is held, and each is carded in this edition with the convention frame under which we read "
  "it.</p>")

A("<h3>Pólya, 1915 — the additive origin</h3>")
A("<p>A polynomial with rational coefficients can take integer values at every integer without having "
  "integer coefficients; <code>binom(x,2) = x(x−1)/2</code> is the standard witness. Pólya's theorem "
  "is that these <em>integer-valued</em> polynomials are exactly the <code>ℤ</code>-span of the "
  "binomial polynomials <code>binom(x,k)</code> — the failure of integrality in the coefficients is "
  "completely accounted for by a change of basis. Everything below is a deformation of that sentence. "
  "<span class=\"fine\">(<em>Über ganzwertige ganze Funktionen</em>, Rend. Circ. Mat. Palermo 40; "
  "printed as 1919 in Harman–Hopkins §1, and the standard modern reference is Cahen–Chabert, AMS "
  "Surveys 48.)</span></p>")

A("<h3>Gel'fond and Gramain — moving the grid from arithmetic to geometric</h3>")
A("<p>The natural next question is what happens when integrality is imposed not at "
  "<code>0, 1, 2, …</code> but along a <strong>geometric progression</strong> "
  "<code>1, q, q², …</code>. For entire functions that is Gel'fond, 1933 — Gramain calls it the "
  "<em>analogue multiplicatif</em> of Pólya's additive problem. For polynomials it is Gramain's own "
  "Proposition 2.2: for an integer <code>q ≥ 2</code>, the polynomials integral at every "
  "<code>q^k</code> are the <code>ℤ</code>-module generated by the <strong>Gauss binomial "
  "polynomials</strong> — and those are exactly the divided classes <code>ν_r</code> of this record. "
  "He remarks that such results are <em>sans doute classiques</em> yet <em>ne semblent pas "
  "disponibles dans la littérature</em>, and proves them for that reason, which is what makes him "
  "the citable source for the result.</p>")
A('<p class="fine">Gramain, Lecture Notes in Mathematics 1415, pp. 123–137; the statement is Prop. '
  "2.2, p. 124. The volume's articles number independently, so a citation must name the article. "
  "Cahen–Chabert reach the same case only as an exercise, and attribute it to this proposition.</p>")

A("<h3>Harman and Hopkins — the q-deformation, and then both directions</h3>")
A("<p>Deforming the coefficients rather than the grid gives the quantum question: which "
  "<code>P ∈ ℚ(q)[x]</code> satisfy <code>P([n]_q) ∈ ℤ[q]</code>? Their §1 answers it on the "
  "<em>additive</em> grid of <code>q</code>-integers, with a free basis of <code>q</code>-binomial "
  "polynomials — Pólya's theorem, deformed. Their §4 then takes the nodes over all of <code>ℤ</code> "
  "rather than <code>ℕ</code>, inverting <code>q</code> in the coefficients: the "
  "<strong>bilateral</strong> form, which is the one this record needs.</p>")
A("<p><strong>And their §4 contains the remark that joins the two lines.</strong> Setting "
  "<code>z = 1 + (q−1)x</code> turns evaluation at <code>x = [n]_q</code> into evaluation at "
  "<code>z = q^n</code> — the additive grid becomes the geometric one, node for node. Their own "
  "closing observation is that adjoining square roots <code>K² = z</code>, <code>v² = q</code> "
  "produces the Cartan part of Lusztig's integral form of <code>U_v(sl₂)</code>. That is this "
  "record's setting, arrived at from the other side: the programme's frame <em>is</em> the "
  "square-root cover their remark constructs.</p>")
A('<p class="fine">Harman–Hopkins, <em>Quantum integer-valued polynomials</em>, arXiv:1601.06110, '
  "read against the arXiv source. Two of their statements are not used here: the freeness of their "
  "basis, and the Lusztig identification, which is an unproved remark in the source and is carded as "
  "one.</p>")

A("<h3>What this record adds to the line</h3>")
A("<p>Two additions, each a routine transport of the known theorem. The grid variable is inverted, "
  "so the objects are <strong>Laurent</strong> polynomials — at a grid of units this is a simple "
  "clearing argument. And the coefficients carry a <strong>free parameter <code>t</code></strong>, "
  "which arrives from the hybrid family setting the goal was posed in and rides through the argument "
  "as a spectator, the integrality test decomposing coefficient-wise. No predecessor is located for "
  "that parameter; three independent cards record its absence from the sources.</p>")
A("<p><strong>What is new is that the statement is machine-checked.</strong> No theory of "
  "integer-valued polynomials, classical or <code>q</code>-deformed, is present in Mathlib — not "
  "Pólya's theorem, not a <code>q</code>-analogue. The deliverable of this record is a proof with a "
  "clean axiom base, together with a per-entry account of what warrants each piece.</p>")
A("<p>One observation in this record belongs to it and to none of the ancestors: <strong>the "
  "evenness of the grid is essential, and one value shows it.</strong> <code>ν_1</code> is integral "
  "at every node <code>q^χ</code>, and at the odd node <code>v³</code> takes the value "
  "<code>(v²+v+1)/(v+1)</code>, which is not in <code>A_t</code>. The divided classes do not survive "
  "refinement of the grid, and that is why the goal reads <em>even</em>.</p>")

A('<h2>How the three layers relate</h2><div class="rule"></div>')
A("<p>The record exists as an informal manuscript, a computational instrument, and a formal "
  "development. The register below is what joins them: one entry per result, naming the same object "
  "in all three under a stated convention frame.</p>")
A("<p><strong>The instrument and the formal development are two independent implementations, joined "
  "by a shared naming discipline.</strong> Each stem — <code>nu</code>, <code>grid</code>, "
  "<code>expand</code>, <code>newton</code> — carries the same name in the manuscript, in the Julia "
  "package and in the Lean sources, and a human reading both is what identifies them. Agreement "
  "between the two is established by testing, over the bounds printed in each entry. The kernel "
  "certifies the formal statement; the instrument computes and refutes over a stated range; the "
  "register records which of the two stands behind each entry.</p>")

A('<h2>What warrants what</h2><div class="rule"></div>')
A("<p>The grades below are <strong>different kinds of claim</strong>, and are "
  "given equal weight. No declaration in this development refers to the Julia package, and none is "
  "planned: a computed entry is warranted by its range and never by the kernel.</p>")
A('<p class="fine">A computed entry records the <strong>range</strong> its computation ran over and '
  "an <strong>anchor</strong> to the certificate, and never the computed values themselves. A reader "
  "who wants the values follows the anchor. This edition reports that a claim\u2019s warrant is a "
  "bounded computation; it never argues from the computation.</p>")
A('<div class="split">')
A(f'<div class="grade g-i"><div class="n">{cnt.get("ink",0)}<span class="of"> / {len(rows)}</span></div>'
  '<div class="name">ink</div><div class="what">An argument written out for a human reader and '
  "refereed. The row records who refereed it, when, at which hash, and with what verdict.</div></div>")
A(f'<div class="grade g-c"><div class="n">{n_c}<span class="of"> / {len(rows)}</span></div>'
  f'<div class="name">orange</div><div class="what">Verified by computation over a stated bound, '
  "which is part of the claim, and it is printed in the entry.</div></div>")
A(f'<div class="grade g-k"><div class="n">{n_k}<span class="of"> / {len(rows)}</span></div>'
  f'<div class="name">blue</div><div class="what">A formal declaration states this '
  "entry's claim, and its axiom base is exactly the three standard axioms of Lean's kernel — propositional extensionality (<code>propext</code>), the axiom of choice (<code>Classical.choice</code>) and quotient soundness (<code>Quot.sound</code>) — the base every Mathlib proof shares; a certificate is clean when these three are all it needs — "
  "no <code>sorryAx</code>, no custom axiom. Every axiom result here was measured first-hand, not "
  "quoted from the closure record.</div></div>")
A("</div>")
A('<p class="fine">Each warrant below was measured on that entry&rsquo;s own declaration.</p>')



A('<h2>The register</h2><div class="rule"></div>')
A(f'<p class="fine">{len(rows)} entries, every one kept and every one carrying its ancestry. An '
  "entry that could not be completed appears with its missing field named: a kept entry that says "
  "<code>none</code> shows the register's true extent.</p>")
A('<div class="register">')
for r in rows:
    # A ROW WAS BEING MISLABELLED. This read `"k" if warrant == "blue" else "c"`, so the ink
    # row printed as "computed over declared range" — a false statement about a result,
    # produced by a two-way test that outlived the arrival of a third warrant.
    wk = {"blue": "k", "orange": "c", "ink": "i"}[r["warrant"]]
    wname = {"k": "blue", "c": "orange", "i": "ink"}[wk]
    A(f'<article class="entry"><div class="gutter"><span class="id">{esc(r["id"])}</span>'
      f'<span class="wbadge w-{wk}">{wname}</span></div><div>')
    A(f'<p class="claim">{esc(r["informal"]["statement"])}</p><dl class="facets short">')
    inf = r["informal"]
    A(f'<dt>informal</dt><dd>{esc(inf.get("label") or "—")}'
      + (f'<br><span class="mono">{esc(inf["file"])}</span>' if inf.get("file") else "") + "</dd>")
    cas = r.get("cas") or {}
    A("<dt>computed</dt><dd>" + (esc(cas.get("object")) if cas.get("object")
      else "<em>no computational claim</em>") + "</dd>")
    ln = r.get("lean")
    if ln:
        also = ln.get("also") or []
        extra = "".join(f'<br><span class="mono alsodecl">{esc(a.split(" (")[0])}</span>' for a in also)
        A(f'<dt>formal</dt><dd><span class="mono">{esc(ln["declaration"])}</span>{extra}</dd>')
    else:
        A("<dt>formal</dt><dd><em>stated in the manuscript; no declaration in this development "
          "carries it</em></dd>")
    if r.get("axioms"):
        A(f'<dt>axioms</dt><dd class="strong mono">{esc(", ".join(r["axioms"]))}</dd>')
    A("</dl>")
    A('<dl class="facets long">')
    if r.get("declared_range"):
        A(f'<dt>range</dt><dd class="strong">{rich(r["declared_range"])}</dd>')
    if r.get("evidence_anchor"):
        A(f'<dt>evidence</dt><dd>{esc(r["evidence_anchor"])}</dd>')
    A(f'<dt>ancestry</dt><dd>{esc(r.get("ancestry_print") or "")}</dd>')
    A("</dl></div></article>")
A("</div>")

A('<h2>The instrument</h2><div class="rule"></div>')
A("<p>The computational layer is a standalone Julia package, <code>GL1Newton</code>, extracted from "
  "the development substrate and pinned. It computes the objects the theorem is about, and it is the "
  "referee that decides the span identity independently of the proof.</p>")
A('<dl class="stems">')
for stem, what in [
    ("frame()", "the base data — <code>K = ℚ(q,t)</code> and the polynomial ring over it"),
    ("nu(R, r)", "the divided class <code>ν_r</code>"),
    ("grid(R, χ)", "the grid point <code>q^χ</code>, two-sided over all of <code>ℤ</code>"),
    ("nu_grid(R, r, χ)", "the value <code>ν_r(q^χ)</code>"),
    ("expand(R, f)", "the Newton coordinates of <code>f</code>, by triangular sweep"),
    ("az(c)", "membership of a scalar in <code>A_t</code>"),
    ("newton(R, f; window)", "grid-integrality as a <strong>bounded verdict</strong> — it returns the window alongside the answer, so a bounded check can never be read as a proof"),
    ("mem_span(R, f)", "membership in the span <code>Σ A_t ν_r</code> — deciding that this equals <code>newton</code> <em>is</em> the theorem"),
    ("laurent(R, f)", "membership in <code>A_t[Y̌^{±1}]</code>, which is strictly smaller"),
]:
    A(f"<dt>{stem}</dt><dd>{what}</dd>")
A("</dl>")
A("<p>A second module carries the symmetric quantum-bracket family on the <code>v</code>-side; the "
  "identity <code>ν_r(q^m) = v^{r(m−r)}·[m,r]</code> is the seam between the two, and it is checked.</p>")
A("<p><strong>Why the instrument is an independent referee.</strong> Its <code>newton</code> "
  "predicate was originally defined by the very span the theorem computes, which made it unable to "
  "referee the theorem. It was redefined by evaluation on the grid, and the independent pin then "
  "agreed with the span predicate on every one of the 60 random positives, 5 adversarial seeds and "
  "one separator, at window 8.</p>")
A(f'<p>The acceptance battery runs <strong>87 of 87</strong>, re-measured for this edition. Its '
  "ranges are printed in the entries that rest on it. To re-run it, instantiate the package against "
  "the pinned manifest and call its test suite; the pins are below.</p>")
A('<p class="fine">In the record: the package at <code>SandboxA/sandboxA0a/almanac/GL1Newton/</code> '
  '(source <code>src/GL1Newton.jl</code>, battery <code>test/runtests.jl</code>) · the referee pin at '
  '<code>SandboxA/sandboxA0a/n1_clause3_referee_pin.jl</code>.</p>')

A('<h2>Everything in this edition</h2><div class="rule"></div>')
A(f"<p>{n_ship} artifacts. Every one is listed here and every one opens. The rule is that "
  "<strong>cards travel while sources stay behind as citations</strong>: a card is this project's "
  "own writing about someone else's statement, carrying the frame under which we read it, and it "
  "ships. The source itself is referenced by author, title and section.</p>")
A(artifact_index())
A('<p class="fine"><strong>Held as references, cited by author, title and section:</strong> Gramain (Lecture Notes in Mathematics '
  "1415, pages 123–137), Cahen–Chabert (AMS Surveys 48), Harman–Hopkins (arXiv:1601.06110), De "
  "Concini–Procesi, Jantzen, Lusztig, Habiro–Lê, Pólya, Pólya–Szegő, Gauss.</p>")

A('<h2>Reproducibility</h2><div class="rule"></div>')
A("<p>Pinned by exact revision — a proof that compiles today compiles against "
  "<em>that</em> specific library revision.</p>")
A('<div class="scroll"><table class="tbl">')
A(f'<tr><th>component</th><th>pin</th></tr>'
  f'<tr><td>Lean toolchain</td><td class="mono">{esc(rec["lean_toolchain"])}</td></tr>'
  f'<tr><td>Mathlib</td><td class="mono">{esc(rec["mathlib_revision"])}</td></tr>'
  f'<tr><td>Julia</td><td class="mono">{esc(rec["julia"]["manifest_julia_version"])}</td></tr>'
  f'<tr><td>OSCAR</td><td class="mono">{esc(rec["oscar"]["manifest_resolved_version"])} · '
  f'{esc(rec["oscar"]["git_tree_sha1"])[:16]}…</td></tr>'
  f'<tr><td>record commit</td><td class="mono">{esc(rec["estate_commit_for_the_record_cited"])}</td></tr>'
  "</table></div>")
A('<p class="fine">A re-run at these pins reproduces the symbolic results exactly; the arithmetic is '
  "exact in fraction fields over <code>ℤ[q]</code>, with no floating point anywhere in the record. "
  "Wall-clock time and search order may differ. Where a result is bounded, the bound is part of the "
  "claim and is re-runnable at that bound.</p>")

A('<h2>Authorship</h2><div class="rule"></div>')
A("<p><strong>Tamás Hausel</strong>, who directed this work throughout its life. Issued by "
  "<strong>Project Sandbox</strong>.</p>")
A("<p>Authorship here follows direction over the whole life of the work: the statement was fixed "
  "and signed before any proving effort was spent, every approval was a human act, and the closure "
  "signature is a human act.</p>")
A("<p>The work was produced by software agents operating under a written standard that fixes the "
  "statement before the proof, requires a computer-algebra oracle to confirm a statement — including "
  "against adversarial inputs — before proving effort is spent, and accepts a result as certified "
  "only on the verdict of a proof kernel. No agent approves its own work, and the seat that produces "
  "an edition is never the one that accepts it. The editorial work on this edition was done by a "
  "software agent under that standard.</p>")
A('<p class="fine">Formal results are certified by the Lean 4 kernel. Per-entry warrants are in the '
  "register and they are not uniform: the certifier certifies the formal statement and nothing "
  "else.</p>")

A('<h2>Errata and measurements</h2><div class="rule"></div>')
A('<p class="fine">Dated 2026-08-13. Everything below was measured directly.</p>')
A("<p><strong>Certification evidence.</strong> The closure signature of 2026-07-21 records thirteen "
  "certified declarations. The release log it cites contains five and does not contain the endpoint "
  "the signature names; a third record gives eight. The log is unaltered since it was hashed into the "
  "closure record. Sixteen declarations were checked directly on 2026-08-13 through the Lean language "
  "server, and each returned the axiom base <code>propext, Classical.choice, Quot.sound</code> — the standard three, nothing else.</p>")
A("<p><strong>The formal source description.</strong> The manifest of 2026-07-21 hashes seven files "
  "while declaring a five-file cone, and declares the non-degeneracy witnesses absent from the tree. "
  "They are in the tree, committed 2026-07-20, and were checked clean.</p>")
A("<p><strong>The acceptance battery.</strong> Recorded as 70/70 in three places; the test file "
  "contains 83 test statements; a re-run on 2026-08-13 gave 87/87.</p>")
A("<p><strong>Corrections to this edition.</strong> Four entries were first written as "
  "&ldquo;no predecessor located&rdquo; with no search behind them; searches were then run and "
  "predecessors were found for three. A convention dictionary in the ancestry section was written "
  "inverted, stating the base ring with <code>q</code> where the signed statement has <code>v</code>. "
  "A witness printed against the span identity — <code>ν_1(q³)</code> — was false in the current "
  "frame, having been carried over from a card written in the retired notation; the true witness is "
  "<code>ν_1(v³) = (v²+v+1)/(v+1)</code>, at an odd node. A claim that the additive-to-multiplicative "
  "substitution is not a lattice isomorphism was false; it is one.</p>")
A("<p><strong>A withdrawn certificate, and what it cost.</strong> This edition asserted that "
  "Gramain's normalisation differed from ours by a unit, and obtained a computer-algebra certificate "
  "for it. The certificate was sound and the claim was wrong: the formula typed into it carried a "
  "dropped minus sign, invisible at ordinary resolution and absent from the scan's text layer. "
  "Gramain divides where the transcription multiplied, so his classes are ours exactly. <strong>A "
  "certificate establishes its input, not its source.</strong> The claim and the certificate are "
  "withdrawn; the matter was settled instead from a sentence on the printed page — "
  "<em>&ldquo;On voit que G_n(q^n) = 1&rdquo;</em> — which forces the sign without needing to read "
  "the glyph.</p>")

A('<div class="colophon"><p><strong>almanacA0a</strong> · the pilot edition · Project Sandbox · '
  f"{esc(C['assembled_utc'])}</p>"
  "<p>Generated from the edition's own register and manifest at render time, so this presentation "
  "always matches the edition it presents; every figure in it is read from the edition's own data.</p>"
  "<p>Reviewed and accepted 2026-08-13 by the owner of the record. Proposal for review; deposit is "
  "a step still ahead of this edition.</p></div>")
A("</div>")

out = os.path.join(D, "almanac.artifact.html")
open(out, "w").write("\n".join(P)
                     .replace("__WORDMARK__", wordmark())
                     .replace("__WARRANT_VARS__", WARRANT_VARS))
print("wrote", out, os.path.getsize(out) // 1024, "KB")
print(f"entries {len(rows)} · warrants {cnt.get('ink',0)}ink/{n_c}orange/{n_k}blue · gaps {n_gaps} · artifacts {n_ship}")
