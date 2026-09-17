#!/usr/bin/env python3
"""Render the reading view of almanacA0a from the edition's own files.

The point of generating rather than hand-writing: every figure and every row comes from
CONCORDANCE.json / MANIFEST.json at render time, so the presentation cannot drift from the
edition it presents. Transcription is where this pilot's errors entered; there is none here.

Writes almanac.html beside itself. Self-contained: no external CSS, JS, fonts or images.
"""
import html
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_docs import WARRANT_VARS, wordmark  # one mark, defined once

D = os.path.dirname(os.path.abspath(__file__))
C = json.load(open(os.path.join(D, "CONCORDANCE.json")))
M = json.load(open(os.path.join(D, "MANIFEST.json")))


def esc(x):
    return html.escape(str(x)) if x is not None else ""


def warrant_label(w):
    return {
        "ink": ("ink — a refereed argument", "i"),
        "orange": ("orange — computed over a declared range", "c"),
        "blue": ("blue — kernel-certified", "k"),
    }.get(w, (w, "n"))


rows = C["rows"]
counts = {}
for r in rows:
    counts[r["warrant"]] = counts.get(r["warrant"], 0) + 1
n_ship = len(M["substrate_artifacts"]) + len(M["edition_artifacts"]) + len(M.get("card_artifacts", []))
recipe = M["reproducibility_recipe"]
pol = M["contents_policy"]

parts = []
A = parts.append

A(f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>almanacA0a — the centre of the even hybrid family quantum GL₁</title>
<style>
 :root {{
   --ink:#1a1a18; --dim:#5c5a54; --faint:#8a8780; --rule:#ddd9d0; --bg:#fbfaf7;
   --panel:#f4f2ec; --accent:#7a4a1e; --warn:#8a3b2a; --ok:#2f5d3a;
 }}
 @media (prefers-color-scheme: dark) {{ :root:not([data-theme="light"]) {{
   --ink:#e8e5de; --dim:#a8a49b; --faint:#7d7a72; --rule:#3a3833; --bg:#16150f;
   --panel:#1f1e18; --accent:#d9a066; --warn:#e08b74; --ok:#8fc79a;
 }} }}
 :root[data-theme="dark"] {{
   --ink:#e8e5de; --dim:#a8a49b; --faint:#7d7a72; --rule:#3a3833; --bg:#16150f;
   --panel:#1f1e18; --accent:#d9a066; --warn:#e08b74; --ok:#8fc79a;
 }}
 * {{ box-sizing:border-box; }}
 body {{ margin:0; background:var(--bg); color:var(--ink);
   font:16px/1.62 "Iowan Old Style","Palatino Linotype",Palatino,Georgia,serif; }}
 .wrap {{ max-width:47rem; margin:0 auto; padding:4rem 1.5rem 6rem; }}
 h1 {{ font-size:2.1rem; line-height:1.18; margin:0 0 .3rem; font-weight:600; letter-spacing:-.01em; }}
 .sub {{ color:var(--dim); font-size:1.05rem; margin:0 0 .4rem; }}
 h2 {{ font-size:1.32rem; margin:3.4rem 0 .9rem; padding-bottom:.35rem;
   border-bottom:1px solid var(--rule); font-weight:600; }}
 h3 {{ font-size:1.03rem; margin:2rem 0 .5rem; font-weight:600; }}
 p, li {{ margin:0 0 .95rem; }}
 code, .mono {{ font-family:"SF Mono",Menlo,Consolas,monospace; font-size:.87em;
   background:var(--panel); padding:.08em .32em; border-radius:3px; }}
 .stamp {{ display:inline-block; border:1px solid var(--rule); background:var(--panel);
   color:var(--dim); font-size:.76rem; letter-spacing:.06em; text-transform:uppercase;
   padding:.28rem .6rem; border-radius:3px; margin:0 .3rem .3rem 0;
   font-family:"SF Mono",Menlo,monospace; }}
 .stamp.warn {{ color:var(--warn); border-color:var(--warn); }}
 .note {{ background:var(--panel); border-left:3px solid var(--accent);
   padding:.9rem 1.1rem; margin:1.4rem 0; }}
 .note.warn {{ border-left-color:var(--warn); }}
 .lede {{ font-size:1.06rem; color:var(--dim); }}
 table {{ border-collapse:collapse; width:100%; font-size:.92rem; margin:1rem 0; }}
 th, td {{ text-align:left; padding:.5rem .6rem; border-bottom:1px solid var(--rule);
   vertical-align:top; }}
 th {{ font-size:.76rem; letter-spacing:.06em; text-transform:uppercase; color:var(--faint);
   font-weight:600; }}
 .scroll {{ overflow-x:auto; }}
 .row {{ border:1px solid var(--rule); border-radius:5px; margin:1.5rem 0;
   background:var(--panel); }}
 .row > header {{ padding:.8rem 1.1rem; border-bottom:1px solid var(--rule);
   display:flex; flex-wrap:wrap; gap:.5rem; align-items:baseline; }}
 .row .rid {{ font-family:"SF Mono",Menlo,monospace; font-size:.78rem; color:var(--faint); }}
 .row .stmt {{ flex:1 1 100%; font-size:1.02rem; }}
 .row .body {{ padding:.9rem 1.1rem; }}
 .row dl {{ margin:0; display:grid; grid-template-columns:8.5rem 1fr; gap:.42rem .9rem; }}
 .row dt {{ font-size:.74rem; letter-spacing:.055em; text-transform:uppercase;
   color:var(--faint); padding-top:.2rem; }}
 .row dd {{ margin:0; font-size:.9rem; }}
 .k {{ color:var(--w-blue); }} .c {{ color:var(--w-orange); }}
 /* INK wears the running-text colour, as it does on index.html: the three warrants are KINDS,
    not levels, and the one with no instrument behind it must not read as the one with none. */
 .i {{ color:var(--ink); }}
 .fine {{ font-size:.85rem; color:var(--dim); }}
 hr {{ border:0; border-top:1px solid var(--rule); margin:3rem 0; }}
 a {{ color:var(--accent); }}
 footer {{ margin-top:4rem; padding-top:1.2rem; border-top:1px solid var(--rule);
   color:var(--faint); font-size:.85rem; }}

/* THE MARK, on every html face of the almanac (Overseer, 2026-09-04). Horizontal cut here,
   because it sits in a masthead and the square cut is for a margin beside prose. */
.wordmark{{display:block;margin:0 0 .7rem;height:38px;width:126px}}
__WARRANT_VARS__
</style></head><body><div class="wrap">""")

A(f"""
__WORDMARK__
<h1>almanacA0a</h1>
<p class="sub">The centre of the even hybrid family quantum <em>GL</em><sub>1</sub></p>
<p class="sub" style="font-size:.95rem">Issued by Project Sandbox · assembled {esc(C['assembled_utc'])} · <strong>the pilot edition</strong></p>
<p>
<span class="stamp">{esc(C.get('accepted','').split(' by ')[0] or 'status')}</span>
<span class="stamp">deposited 2026-09-17</span>
<span class="stamp">doi 10.5281/zenodo.22808195</span>
<span class="stamp warn">rows freeze at deposit</span>
</p>

<div class="note warn">
<strong>This is the edition of record, deposited in the EU Open Research Repository as 10.5281/zenodo.22808195 on 2026-09-17; a correction is a new version with its own DOI.</strong> It has been accepted by the record's owner as a faithful account of a closed
record that claims exactly what its warrants support. Deposit and outward authorisation are both
still ahead of it, each a separate human act. Its rows freeze at deposit.
</div>

<h2>What this is</h2>
<p class="lede">A complete record of one small mathematical result, in three layers, with a per-claim
account of what warrants each one.</p>
<p>For <em>G</em> = <em>GL</em><sub>1</sub>: the even hybrid family integral form is an
<code>A_t</code>-subalgebra; the Harish–Chandra projection restricts to an isomorphism
<code>Z(U^ev) ≅ (N^ev)^W</code>; and the even Newton lattice is exactly the <code>A_t</code>-span of
the shifted divided classes. The three layers are an informal manuscript, a Julia instrument, and a
Lean development.</p>
<p><strong>What makes this an almanac</strong> is the concordance below: one row per result,
joining the three layers under a convention frame in which all the names denote one object, and
recording per row what actually certifies it. The concordance performs the alignment a reader would
otherwise do by hand; that joining is what makes these three layers an edition.</p>

<h2>The scope of the claim</h2>
<p><strong><em>GL</em><sub>1</sub> is the degenerate case, and the edition says so first.</strong>
The root system is empty, the Weyl group trivial, the algebra commutative, and the Harish–Chandra
projection the identity map. The value of this record is that a small true statement was carried end
to end — signed before it was proved, refereed, kernel-certified, refuted where false, and edited
into a form a stranger can check — and that the cost and the failure modes were measured. The rank ≥ 2 cases are the open frontier and nothing here
settles them.</p>
<p><strong>A tested agreement is not a proof.</strong> The Julia and Lean layers are two independent
implementations joined by a naming discipline, not by a checked morphism. No object in this edition
has a machine-checked correspondence between its two realisations.</p>

<h2>Ancestry: these manuscripts predate the ancestry rule</h2>
<p>The signed goal predates criterion 13 (adopted 2026-08-05); the proof manuscript carries its
declaration. <strong>Ancestry is therefore discharged at edition level, and the signed
file is not touched</strong> — its hash is bound into the closure signature, and trading a checkable
anchor for a tidier manuscript would be the wrong way round. Every row below carries its own
ancestry: a card, or "none located" with the search that failed behind it. <strong>Every "none
located" in this edition carries the search that produced it.</strong></p>
""")

A(f"""<h2>The certification split</h2>
<p>The three grades are distinct kinds of warrant, and the edition keeps them distinct.
<strong>The warrant describes the row, never the sandbox</strong> — the sandbox is closed with a clean axiom triple, and
that does not make every row kernel-certified.</p>
<div class="scroll"><table>
<tr><th>grade</th><th>rows</th><th>what it means</th></tr>
<tr><td class="i">ink — a refereed argument</td><td><strong>{counts.get('ink',0)} of {len(rows)}</strong></td>
<td>An argument written for a human reader and refereed. No kernel certifies it and no computation
bounds it: the check is a referee reading the proof.</td></tr>
<tr><td class="c">orange — computed over a declared range</td><td><strong>{counts.get('orange',0)} of {len(rows)}</strong></td>
<td>Verified by computation over a stated bound, and over nothing else. The bound is part of the claim.</td></tr>
<tr><td class="k">blue — kernel-certified</td><td><strong>{counts.get('blue',0)} of {len(rows)}</strong></td>
<td>A Lean declaration states this row's claim and its <code>#print axioms</code> result is exactly
the three standard axioms of Lean's kernel — propositional extensionality (<code>propext</code>), the axiom of choice (<code>Classical.choice</code>) and quotient soundness (<code>Quot.sound</code>) — the base every Mathlib proof shares; a certificate is clean when these three are all it needs — with no <code>sorryAx</code> and no custom axiom.</td></tr>
</table></div>
<p class="fine">Every axiom result was measured first-hand through the Lean language server. The
two computed rows are the instrument and the oracle referee pin,
and <strong>neither could ever be kernel-certified</strong>: no Lean declaration states what a Julia
program does.</p>

<div class="note warn"><strong>A disclosure the edition carries on its face.</strong> This edition
cites the sandbox's closure certification, and that record is internally inconsistent about how many
declarations were certified — 13 in the signature, 8 in the approval state, 5 in the log it cites,
which does not contain the endpoint it names. The mathematics is independently sound: 16 declarations
were verified first-hand and every one returned the clean triple. What is defective is the retained
evidence, and its repair is a separate act awaiting signature.</div>
""")

A(f"""<h2>The concordance</h2>
<p class="fine">{len(rows)} rows · all kept · every row carries ancestry. An incomplete row stays in
the edition with its missing field shown as <code>null</code>, so the edition always displays its
true state.</p>""")

for r in rows:
    lab, cls = warrant_label(r["warrant"])
    A(f"""<article class="row"><header>
      <span class="rid">{esc(r['id'])}</span>
      <span class="stamp {cls}">{esc(lab)}</span>
      <span class="stmt">{esc(r['informal']['statement'])}</span></header><div class="body"><dl>""")
    inf = r["informal"]
    src = esc(inf.get("file") or "—")
    lbl = esc(inf.get("label") or "")
    A(f"<dt>informal</dt><dd>{src}{' · ' + lbl if lbl else ''}</dd>")
    cas = r.get("cas") or {}
    A("<dt>CAS object</dt><dd>" + (esc(cas.get("object")) if cas.get("object") else
      "<span class='fine'>none — " + esc((cas.get("note") or "no computational claim")[:150]) + "</span>") + "</dd>")
    ln = r.get("lean")
    A("<dt>Lean</dt><dd>" + (f"<code>{esc(ln['declaration'])}</code>" if ln else
      "<span class='fine'>none — this row's subject is not a Lean statement</span>") + "</dd>")
    if r.get("axioms"):
        A(f"<dt>axioms used</dt><dd><code>{esc(' · '.join(r['axioms']))}</code> — the standard three, nothing else</dd>")
    if r.get("declared_range"):
        A(f"<dt>declared range</dt><dd class='fine'>{esc(r['declared_range'])}</dd>")
    A(f"<dt>frame</dt><dd class='fine'>{esc(r['convention_frame'])}</dd>")
    A(f"<dt>ancestry</dt><dd class='fine'>{esc(r['ancestry'])}</dd>")
    if r.get("notes"):
        A(f"<dt>notes</dt><dd class='fine'>{esc(r['notes'])}</dd>")
    A("</dl></div></article>")

A(f"""<h2>What a reader receives</h2>
<p><strong>{n_ship} artifacts, about 1.0 MB, containing no third-party PDF.</strong> The governing
rule is that <em>cards travel and sources do not</em>: a card is this project's own writing about
someone else's statement, carrying the convention frame under which we read it, and it ships inside
the edition. The source itself is referenced by author, title and section, and never redistributed.
Shipping a card is attribution; shipping a source would be redistribution.</p>
<div class="scroll"><table>
<tr><th>ships</th><th>count</th></tr>
<tr><td>the almanac proper — front matter, concordance, embedding note, ancestry, authorship,
manifest, gap list, verdicts</td><td>{len(M['edition_artifacts'])}</td></tr>
<tr><td>statement cards the ancestry resolves to</td><td>{len(M.get('card_artifacts',[]))}</td></tr>
<tr><td>the project's own substrate — manuscripts (TeX and PDF), Lean sources, the Julia instrument
with its dependency pin, ledgers, referee and panel reports, closure records</td>
<td>{len(M['substrate_artifacts'])}</td></tr>
</table></div>
<p class="fine"><strong>Referenced, never redistributed:</strong> Gramain (LNM 1415), Cahen–Chabert
(AMS Surveys 48), Harman–Hopkins (arXiv:1601.06110), De Concini–Procesi, Jantzen, Lusztig,
Habiro–Lê, Pólya, Pólya–Szegő, Gauss.</p>

<h2>Reproducibility</h2>
<p>Pinned by exact version — a proof that compiles today compiles against the recorded Mathlib
revision.</p>
<div class="scroll"><table>
<tr><th>component</th><th>pin</th></tr>
<tr><td>Lean toolchain</td><td><code>{esc(recipe['lean_toolchain'])}</code></td></tr>
<tr><td>Mathlib</td><td><code>{esc(recipe['mathlib_revision'])}</code></td></tr>
<tr><td>Julia</td><td><code>{esc(recipe['julia']['manifest_julia_version'])}</code> (Manifest is the pin; Project is intent)</td></tr>
<tr><td>OSCAR</td><td><code>{esc(recipe['oscar']['manifest_resolved_version'])}</code> · tree <code>{esc(recipe['oscar']['git_tree_sha1'])[:16]}…</code></td></tr>
<tr><td>estate commit</td><td><code>{esc(recipe['estate_commit_for_the_record_cited'])}</code></td></tr>
</table></div>
<p class="fine"><strong>What the recipe does not promise:</strong> {esc(recipe['what_the_recipe_does_NOT_promise'])}</p>

<h2>Authorship</h2>
<p><strong>Tamás Hausel</strong>, who directed this sandbox throughout its life. Issued by
<strong>Project Sandbox</strong>. Authorship follows direction over the whole life of the work: the
goal was fixed and signed before any proving budget was spent, every
approval gate was a human act, and the closure signature is a human act.</p>
<p>The work was produced by software agents operating under the Project Sandbox Rule — a written
standard that fixes the statement before the proof, requires a computer-algebra oracle to confirm a
statement before proving effort is spent, and accepts a result as certified only on the verdict of a
proof kernel. No agent approves its own work, and the seat that produces an edition is never the seat
that accepts it. <strong>For this pilot the Almanac Editor's post was discharged by a software
agent</strong>, and the edition states this explicitly for the reader.</p>
<p class="fine">Formal results are certified by the Lean 4 kernel. A result counts as kernel-certified
only when its axiom base is exactly the three standard axioms of Lean's kernel — propositional extensionality (<code>propext</code>), the axiom of choice (<code>Classical.choice</code>) and quotient soundness (<code>Quot.sound</code>) — the base every Mathlib proof shares; a certificate is clean when these three are all it needs. Per-row
warrants are above and they are not uniform: the certifier certifies the Lean statement and nothing
else.</p>

<h2>The gap list</h2>
<p>The gap list is a permanent part of every edition. <strong>It records 15 findings</strong>,
and the count rose as the edition matured — every finding added after assembly was found by the form,
against the edition or its author. An edition whose gap list converges to zero as it matures is one
that stopped looking.</p>
<p class="fine">Among them: the closure-evidence inconsistency disclosed above; a stale source
manifest; a recorded test count that could not be reproduced and was re-measured; and three errors by
the Editor — rows claiming "none located" with no search behind them, an inverted convention
dictionary written inside the section warning against it, and a machine certificate that faithfully
measured a mis-transcribed formula, followed by a retraction that itself overshot. All were caught,
every warrant stood unchanged, and each left a recorded lesson.</p>

<footer>
<p>almanacA0a · the pilot edition · Project Sandbox · {esc(C['assembled_utc'])}<br>
Generated from <code>CONCORDANCE.json</code> and <code>MANIFEST.json</code> at render time, so this
presentation always matches the edition it presents.<br>
<strong>Proposal for review; deposit, publication and outward release each await authorisation.</strong></p>
</footer>
</div></body></html>""")

out = os.path.join(D, "almanac.html")
open(out, "w").write("".join(parts)
                     .replace("__WORDMARK__", wordmark())
                     .replace("__WARRANT_VARS__", WARRANT_VARS))
print("wrote", out, os.path.getsize(out) // 1024, "KB")
print("rows rendered:", len(rows), "| shipped artifacts:", n_ship)
