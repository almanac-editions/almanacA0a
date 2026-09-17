#!/usr/bin/env python3
"""Render almanac.explained.html from dist_src/explained_src.html.

WHY A GENERATOR EXISTS FOR THIS PAGE (2026-08-29): the explained page was the last hand-written
face in the edition — everything else is generated precisely so the presentation cannot drift
from the edition it presents. When the Overseer asked for properly typeset mathematics, the page
got a template and this renderer at the same time, so it now has a regeneration path like the rest.

THE MATHEMATICS IS AUTHORED AS TeX IN THE TEMPLATE — \\( .. \\) inline, \\[ .. \\] display —
QUOTED from the informal proof of record, never retyped from a rendered view (transcription is
where this pilot's errors entered):

    ../../informal/proofv0a.tex
    sha256 bbd6f055bd5aff614d1a6575b24949d8fd2b805ebda20e33e5c706f28713bbae  (at authoring)

with the proof's own macros expanded: \\At = A_t, \\Ft = F_t, \\Nev = \\mathcal N^{ev},
\\Yc = \\check Y.

THE PAGE'S NOTATION IS DELIBERATELY LIGHTER THAN THE RECORD'S (2026-09-13, the Overseer on the
published page: "still hat Y ... can you simplify the notation on that page?"). Page-local
renames, all declared in the glossary's last row ("in the paper") so a reader crossing to the
paper is never stranded: A for \\At, F for \\Ft, N for \\Nev, Y for \\check Y (the check
mark is now named in WORDS and the glyph never appears), nu_r written in Y rather than X, and
the nu_r called q-binomial polynomials with "divided classes" given as the record's name. The
statement itself is quoted unchanged under the renaming. The two earlier divergences below stand.

UPRIGHT GL (2026-09-15, the Overseer: "can we have GL_n and so GL_1 everywhere with {\\rm GL}"): every
GL_k in the template is \\mathrm{GL}_k; latex2mathml emits mathvariant="normal", the one value MathML
Core honours, so no Unicode substitution is involved. The paper and the Madrid deck changed the same day.

STATUS WORDS CORRECTED BY THE TREE OWNER (2026-09-15, hypervisorA REPORT
20260915T115334Z-hypervisorA-460541-2e50, each measured): the flow-up bases and the ordered-pair
input are on the CLOSED, KERNEL-CERTIFIED rank-one record sandboxA1b (closed 2026-07-18; goalv1b
clauses I, III, IV, V), and theorem bilateralLaurentBasisV1b_integral_iff_unique_expansion
(Sandbox/A1/UQ/GOALv1bBilateralLaurentBasis.lean, clean triple) proves the bilateral one-variable
lattice FREE on the signed bilateral Newton rows; unrecorded is only the base change from
Z[Q^±1,z1^±1,z2^±1] to A = Z[v^±1,t^±1], q = v^2. GL_3 (sandboxA2 GOALv2) is kernel-certified in full,
24 decls, 2026-08-11, closure signature outstanding; for GL_n the STATEMENT is kernel-checked
(Sandbox/AN/SignedGoalA.lean, 49 decls, 2026-08-31), the proof is not; HQ-C-003 is open beyond the
GL_n lattice (the GL_n instance is HQ-C-021, adopted). The first version of the paragraph, an hour
older, called the bases "candidates" -- wrong, and weaker than the truth.

OPENNESS IS RELATIVE TO THIS RECORD, AND SAYS SO (2026-09-15, the Overseer: "we have later work
for 1. Freeness ... sandboxA1c or results planned for sandboxA1d which find various basis, in
particular of flow up basis, or the E_a E_b basis -- just be clear in how you formulate openness";
"for rank >1 we also have basically results, but not necessarily completely machine-verified"). The
closing section now defines "open" as not settled by this closed record and states, per item, what
the programme holds since and under which warrant: the A1c candidates' ordered-pair basis E_aE_b
(candidate_gl2_integral_primitive_kernel.tex, "Integral ordered-pair theorem", unadopted) and flow-up
rows, CAS-bounded, not kernel-certified; the adopted informal GoalA proof for GL_n (SP-2026-036 v3,
2026-08-24), no closed record, no kernel; the general-lattice centre conjecture HQ-C-003 open. The
second witness's last sentence points there instead of saying "open" bare.

ONE OUTBOUND LINK (2026-09-15, the Overseer): the eyebrow's "almanacA0a" is an anchor to the
artifact's own repository, https://github.com/almanac-editions/almanacA0a. The no-network gate below
allows that one URL by value and nothing else; the renderer-family promise (nothing LOADED from the
network) is untouched -- an anchor is navigation, not a resource.

THE BINOMIAL POLYNOMIALS ARE WRITTEN OUT (2026-09-15, the Overseer: "write out the formula for
'binomial polynomials' so that it is clear that it is a polynomial"): the Pólya paragraph now displays
binom(x,k) = x(x-1)...(x-k+1)/k!, names it a degree-k polynomial in x with rational coefficients, and
points back at x(x-1)/2 from the opening example.

THE STATEMENT IS HUMAN-FACING FIRST (2026-09-15, the Overseer on the published page: "the
statement of the result is the most important ... gently explain all the notation you will use in
the statement, and formulate the result precisely but elementarily (do not insist on the original
notation) we do not need to have a statement about A-modules"): the notation is now explained in
prose BEFORE the theorem, in the order it is used; the theorem is stated as an equivalence for one
Laurent polynomial f -- "f is grid-integral iff f = sum a_{u,r} Y^u nu_r(Y) with a_{u,r} in A" --
which is Goal (iii) of goalv0a.tex read element by element (the record's "N^ev = sum A_t Y^u nu_r"
is the equality of the two sets); the rings are the blackboard \\mathbb A and \\mathbb F (the
Overseer: "if you use A=Z[v^+-1,t^+-1] then use it as \\mathbb{A} and same for \\mathbb{F}"); and
the page-local letter N is gone -- the set is named in words ("the grid-integral Laurent
polynomials") and the paper's \\mathcal N^{ev} is given in the "in the paper" note. The three
witnesses and the open-problems list were re-worded to match; their mathematics is unchanged.
hypervisorA's review of the restatement (REPORT 20260915T092821Z-hypervisorA-353316-3ebe): reads as
the same claim as Goal (iii), element by element; one page finding fixed before push -- the box title
said "in rank one", which the page's own convention reserves for GL_2 (GL_1 is rank 0), now "for
GL_1" -- and their nit: "coefficients not in A" is false for nu_0, now "for r >= 1".

TWO DELIBERATE DIVERGENCES FROM THE RECORD'S NOTATION, both on the referee's instruction
(a referee's comments on the built page, 2026-09-11, relayed by the Overseer: the check "is very
irritating", and readers "just do not know why we have such awkward notation"):

  1. THE GRID COORDINATE IS WRITTEN Y, NOT \\check Y. The check marks the cocharacter side of
     the torus, which carries information in higher rank and none at GL_1 -- so on a companion
     page it is cost with no payload. The glossary's last row says, in words, that the paper
     decorates the letter with a check mark; since 2026-09-13 the glyph itself never appears.
  2. EVERY SYMBOL IS MOTIVATED, NOT MERELY DEFINED. The glossary now says why v is squared, why
     t is carried, what the subscript on A_t is for, and that nu_r(q^n) is the Gaussian binomial
     coefficient binom(n,r)_q -- which is what makes "the q-analogue of binom(x,k)" a fact rather
     than an analogy. That identity is a cancellation from the quoted definition
     (nu_r(q^n) = prod_s (q^{n-s}-1)/(q^{r-s}-1)), re-derived by hand and checked symbolically
     for 0<=r<=4, -6<=n<=6 at authoring; the project oracle was unreachable that day, so the
     caption's oracle sentence is scoped to the seven TABULATED values, which it warrants.

One deliberate divergence class: instantiations the proof itself licenses
(e.g. nu_1 = (X-1)/(q-1) is the r=1 case of the quoted definition) and the page's worked table
values, which were CAS-checked against the definition when the page was written and re-derived
by hand at templating.

THE TeX IS PRE-RENDERED TO MathML AT BUILD TIME (latex2mathml — a BUILD-time dependency only;
the reader needs nothing). The output keeps the renderer-family promise LITERALLY: no external
CSS, JS, fonts or images, and no JavaScript at all — MathML is markup and the browser's own
engine typesets it. A CDN MathJax/KaTeX would have put a network service behind an artifact
whose whole claim is that it needs none.
"""
import os, re, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_docs import WARRANT_VARS, wordmark  # one mark, defined once

HERE = os.path.dirname(os.path.abspath(__file__))
OUT  = os.path.join(HERE, "almanac.explained.html")

# THE TEMPLATE LIVES IN THIS FILE, like render_almanac.py's and render_index.py's page skeletons —
# one source of truth that SHIPS with the almanac, so an unzipped copy can regenerate the page.
# A COMPLETE DOCUMENT, NOT A FRAGMENT. This page began at <title> — no doctype, no <html>,
# no <head>, and so NO CHARSET AND NO VIEWPORT. Two consequences, both found by serving the
# built almanac over the tailnet and looking at it on a phone (2026-09-03): a browser with no
# charset falls back to Latin-1 and every em dash arrives as \u00e2\u20ac\u201d, and with no
# viewport the page renders at desktop width on a handset. index.html and almanac.html always
# had these; these two never did.
TEMPLATE = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>The Multiplicative Grid</title>
<style>
:root{
  --paper:#f4f6f7; --panel:#e8edef; --ink:#131a1e; --dim:#4e5b63; --faint:#7b878e;
  --rule:#c9d4d9; --hair:#dde5e8;
  --struct:#2f4a6b; --kern:#1f5f5b; --comp:#7a5a18; --caution:#8c3a2e;
  --measure:84ch;   /* was 66ch; widened 2026-09-13 on the Overseer's word so the title sits on one line */
}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){
  --paper:#0e1215; --panel:#171d21; --ink:#e7ecef; --dim:#a3aeb4; --faint:#77838a;
  --rule:#283138; --hair:#1e262b;
  --struct:#8fb2d6; --kern:#74bcb4; --comp:#cba765; --caution:#e2968a;
}}
:root[data-theme="dark"]{
  --paper:#0e1215; --panel:#171d21; --ink:#e7ecef; --dim:#a3aeb4; --faint:#77838a;
  --rule:#283138; --hair:#1e262b;
  --struct:#8fb2d6; --kern:#74bcb4; --comp:#cba765; --caution:#e2968a;
}
*{box-sizing:border-box}
body{
  margin:0; background:var(--paper); color:var(--ink);
  font:400 18px/1.72 "Iowan Old Style","Palatino Linotype",Palatino,"Book Antiqua",Georgia,serif;
  -webkit-font-smoothing:antialiased;
  padding-inline:clamp(1.1rem,5vw,2rem);
}
.wrap{max-width:var(--measure); margin-inline:auto; padding-block:clamp(3rem,9vw,6rem) 6rem}
p,li,dd,dt{max-width:var(--measure)}
p{margin:0 0 1.15rem; text-wrap:pretty}

.eyebrow{font-family:ui-sans-serif,-apple-system,"Segoe UI",system-ui,sans-serif;
  font-size:.68rem; font-weight:650; letter-spacing:.19em; text-transform:uppercase;
  color:var(--faint); margin:0 0 1.1rem}
h1{font-size:clamp(2.2rem,6.5vw,3.4rem); line-height:1.02; letter-spacing:-.028em;
  font-weight:600; margin:0 0 1.3rem; text-wrap:balance}
@media(min-width:700px){h1{white-space:nowrap}}   /* one line on any desk; phones may still wrap */
h2{font-size:1.5rem; line-height:1.2; letter-spacing:-.014em; font-weight:600;
  margin:4.2rem 0 1.2rem; text-wrap:balance}
h2::before{content:""; display:block; width:2.4rem; height:2px;
  background:var(--ink); margin-bottom:1.1rem}
h3{font-size:1.06rem; font-weight:650; margin:2.4rem 0 .5rem; letter-spacing:-.004em}
.lede{font-size:1.24rem; line-height:1.55; color:var(--dim); margin-bottom:2rem}
strong{font-weight:650}
code,.mono{font-family:ui-monospace,"SF Mono",Menlo,Consolas,monospace; font-size:.86em;
  font-variant-ligatures:none}
code{background:var(--panel); padding:.08em .32em; border-radius:2px}
a{color:var(--struct); text-underline-offset:3px}
a:focus-visible{outline:2px solid var(--struct); outline-offset:3px; border-radius:2px}

/* full-width figure bands */
.band{margin:2.4rem calc(50% - 50vw); padding:2.2rem calc(50vw - 50%);
  background:var(--panel); border-block:1px solid var(--hair)}
.band > *{max-width:var(--measure); margin-inline:auto}
.cap{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.78rem;
  line-height:1.5; color:var(--dim); margin:1.1rem auto 0}

.display{font-family:ui-monospace,"SF Mono",Menlo,Consolas,monospace;
  font-size:1.02rem; line-height:1.9; margin:1.6rem 0; padding:1.2rem 0;
  border-block:1px solid var(--rule); text-align:center; overflow-x:auto}
.display .big{font-size:1.18rem}

/* the grid figure */
.gridfig{overflow-x:auto; padding-bottom:.4rem}
.grid{border-collapse:collapse; margin:0 auto; font-variant-numeric:tabular-nums}
.grid th,.grid td{padding:.55rem .85rem; text-align:center; white-space:nowrap;
  font-family:ui-monospace,Menlo,monospace; font-size:.86rem}
.grid th{font-family:ui-sans-serif,system-ui,sans-serif; font-size:.66rem;
  letter-spacing:.13em; text-transform:uppercase; color:var(--faint); font-weight:650;
  border-bottom:1px solid var(--rule); padding-bottom:.5rem}
.grid td.node{color:var(--struct); font-weight:600}
.grid td.val{color:var(--ink)}
.grid tr.off td{color:var(--caution)}
.grid tr.off td.node{color:var(--caution); font-weight:600}
.grid .tag{font-family:ui-sans-serif,system-ui,sans-serif; font-size:.62rem;
  letter-spacing:.12em; text-transform:uppercase; color:var(--faint)}

/* witnesses */
.wit{border-left:2px solid var(--rule); padding:.1rem 0 .1rem 1.3rem; margin:1.8rem 0}
.thm{background:var(--panel); border-left:3px solid var(--struct); padding:1rem 1.3rem .6rem; margin:2rem 0; border-radius:2px}
.thm .edge{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.7rem; font-weight:650; letter-spacing:.14em; text-transform:uppercase; color:var(--struct); display:block; margin-bottom:.5rem}
.thm p{margin-bottom:.6rem}
.thm .display{margin:.4rem 0}
.wit .edge{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif;
  font-size:.7rem; font-weight:650; letter-spacing:.13em; text-transform:uppercase;
  color:var(--caution); display:block; margin-bottom:.45rem}
.wit p:last-child{margin-bottom:0}

/* grade chips */
.grades{display:grid; gap:0; margin:1.6rem 0}
.grade{display:grid; grid-template-columns:5.2rem 1fr; gap:.2rem 1.3rem; align-items:baseline;
  padding:1rem 0; border-top:1px solid var(--hair)}
.grade:last-child{border-bottom:1px solid var(--hair)}
.grade .n{font-family:ui-monospace,Menlo,monospace; font-size:1.5rem; font-weight:600;
  font-variant-numeric:tabular-nums; line-height:1}
.grade .nm{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.7rem;
  font-weight:700; letter-spacing:.12em; text-transform:uppercase}
.grade .wh{grid-column:2; font-size:.95rem; color:var(--dim)}
.g-k .n,.g-k .nm{color:var(--w-blue)} .g-c .n,.g-c .nm{color:var(--w-orange)}
.g-n .n,.g-n .nm{color:var(--faint)}
@media(max-width:520px){.grade{grid-template-columns:1fr} .grade .wh{grid-column:1}}

/* descent steps */
.steps{list-style:none; margin:1.6rem 0; padding:0; display:grid; gap:1.9rem}
.steps li{display:grid; grid-template-columns:5.6rem 1fr; gap:0 1.4rem; max-width:none}
.steps .yr{font-family:ui-sans-serif,-apple-system,system-ui,sans-serif; font-size:.72rem;
  font-weight:700; letter-spacing:.1em; color:var(--faint); padding-top:.35rem;
  font-variant-numeric:tabular-nums}
.steps .bd{max-width:var(--measure)}
.steps h3{margin-top:0}
@media(max-width:560px){.steps li{grid-template-columns:1fr; gap:.3rem}}

dl.defs{display:grid; grid-template-columns:auto 1fr; gap:.6rem 1.4rem; margin:1.5rem 0;
  align-items:baseline}
dl.defs dt{font-family:ui-monospace,Menlo,monospace; font-size:.88rem; color:var(--struct);
  white-space:nowrap}
dl.defs dd{margin:0; color:var(--dim); font-size:.97rem}
@media(max-width:520px){dl.defs{grid-template-columns:1fr; gap:.15rem}
  dl.defs dt{margin-top:.7rem}}

math{font-size:1.05em}
.display math[display="block"]{font-size:1.25rem; margin:.15rem 0}
.note{font-size:.95rem; color:var(--dim)}
.colophon{margin-top:5rem; padding-top:1.4rem; border-top:2px solid var(--ink);
  font-size:.86rem; line-height:1.6; color:var(--dim)}
.colophon p{max-width:none}

/* THE MARK, on every html face of the almanac (Overseer, 2026-09-04). Horizontal cut here,
   because it sits in a masthead and the square cut is for a margin beside prose. */
.wordmark{display:block;margin:0 0 .7rem;height:38px;width:126px}
__WARRANT_VARS__
</style>

<div class="wrap">

__WORDMARK__
<p class="eyebrow">Project Sandbox · <a href="https://github.com/almanac-editions/almanacA0a">almanacA0a</a> · a reader's companion</p>
<h1>The multiplicative&nbsp;grid</h1>

<p class="lede">A polynomial can take whole-number values everywhere you look and still not have
whole-number coefficients. This is the story of one small theorem that says exactly which
polynomials do that on a geometric grid — and of how far that theorem has been checked.</p>

<p><strong>The mathematics here is classical, and the theorem is not a new one.</strong> The
question is Pólya's, from 1915; the geometric grid is Gel'fond's, from 1933, and Gramain's, from
1990; the deformed two-sided form is Harman and Hopkins', from 2016. What this record adds to them
is two routine transports, set out in full further down. What is unusual is not the theorem but the
record: it was proved, machine-verified and then edited into a form a stranger can check, and every
claim on this page carries a statement of what warrants it.</p>

<h2>The oldest version of the question</h2>

<p>Take the polynomial \(x(x-1)/2\). Its coefficients are halves — not whole numbers —
yet at every integer it returns an integer: 0, 0, 1, 3, 6, 10. The halving always cancels,
because among any two consecutive integers one is even.</p>

<p>So "has integer coefficients" and "takes integer values" are different properties, and the
second is strictly weaker. <strong>Pólya's theorem</strong> (1915) says exactly how much weaker:
the polynomials taking integer values at every integer are precisely the integer combinations of
the <em>binomial polynomials</em>
\[\binom{x}{k}\;=\;\frac{x(x-1)(x-2)\cdots(x-k+1)}{k!},\qquad k=0,1,2,\dots\]
— for each \(k\) a polynomial in \(x\) of degree \(k\), with rational coefficients; \(\binom{x}{2}=x(x-1)/2\)
is the one above. The failure of integrality in the coefficients
is entirely accounted for by changing basis. Everything below is a deformation of that sentence.</p>

<h2>What this record proves</h2>

<p>Pólya's sentence has three ingredients: the points where the values are tested (the integers),
the numbers that the values and the coefficients are measured against (the integers again), and
the binomial polynomials that mediate between the two. The theorem in this record deforms each of
the three. Here they are, one at a time, in the notation this page will use; the statement follows,
and nothing in it will not have been explained first.</p>

<p><strong>Two variables.</strong> Throughout, \(v\) and \(t\) are two independent formal
variables — letters about which nothing is assumed. Everything is written in terms of the square
\(q=v^{2}\), for a reason that will become a hypothesis below: only <em>even</em> powers of \(v\)
ever occur, and that is what the word <em>even</em> means on this page. The second variable \(t\)
is a spectator. It is there because the question was posed for a whole family of algebras at once,
one for each value of \(t\), and it rides through the argument without ever being constrained —
but it has to be carried.</p>

<p><strong>Two rings.</strong> Write
\(\mathbb A=\mathbb Z[v^{\pm1},t^{\pm1}]\) for the whole-number combinations of powers of
\(v\) and \(t\), positive or negative. On this page <em>integral</em> means <em>lies in
\(\mathbb A\)</em>. Write \(\mathbb F=\mathbb Q(v)[t^{\pm1}]\) for the larger ring in which
fractions in \(v\) are also allowed — \(1/(q-1)\), for instance — while \(t\) still appears through
its powers alone. Every element of \(\mathbb A\) is an element of \(\mathbb F\), and the gap between
the two is the whole theorem.</p>

<p><strong>The grid.</strong> In place of the integers, values are tested on the
<strong>geometric</strong> progression \(q^{\chi}\), where \(\chi\) runs over all the integers, of
either sign:
\(\dots,\,q^{-2},\,q^{-1},\,1,\,q,\,q^{2},\,\dots\)</p>

<p><strong>The polynomials, and their values.</strong> A <em>Laurent polynomial in \(Y\)</em> is a
finite sum \(f(Y)=\sum_k c_k\,Y^{k}\) in which the exponents \(k\) are integers of either sign and
the coefficients \(c_k\) lie in \(\mathbb F\). Its value at a point of the grid is \(f(q^{\chi})\),
obtained by substituting \(q^{\chi}\) for \(Y\). Call \(f\) <em>grid-integral</em> if
\(f(q^{\chi})\) lies in \(\mathbb A\) for every integer \(\chi\). This is the deformation of "takes
an integer value at every integer".</p>

<p><strong>The \(q\)-binomial polynomials.</strong> Set \(\nu_0(Y)=1\) and, for \(r\ge1\),
\[\nu_r(Y)=\prod_{s=0}^{r-1}\frac{Y-q^{s}}{q^{r}-q^{s}}.\]
For \(r\ge1\) their coefficients lie in \(\mathbb F\)
and not in \(\mathbb A\) — already \(\nu_1(Y)=(Y-1)/(q-1)\) — but their values on the grid are integral, and
in exactly Pólya's way: at the node \(Y=q^{n}\) the value \(\nu_r(q^{n})\) is the Gaussian
binomial coefficient \({\binom{n}{r}}_{q}\), for every integer \(n\), positive or negative. That
is the \(q\)-analogue of the fact that \(\binom{x}{k}\) takes the value \(\binom{n}{k}\) at
\(x=n\), and it is what makes \(\nu_r\) the right replacement for \(\binom{x}{k}\).</p>

<div class="thm">
  <span class="edge">Theorem — the exact \(q\)-Pólya theorem for \(\mathrm{GL}_1\)</span>
  <p>Let \(f(Y)\) be a Laurent polynomial in \(Y\) with coefficients in \(\mathbb F\). Then
  \(f\) is grid-integral — that is, \(f(q^{\chi})\in\mathbb A\) for every integer \(\chi\) — if
  and only if \(f\) can be written as a finite sum</p>
  <div class="display">\[f(Y)\;=\;\sum a_{u,r}\;Y^{u}\,\nu_r(Y)\]</div>
  <p>with integer shifts \(u\) of either sign, indices \(r\ge0\), and coefficients
  \(a_{u,r}\) in \(\mathbb A\).</p>
</div>

<p>Read it against Pólya: his \(\mathbb Z\) is our \(\mathbb A\), his \(\binom{x}{k}\) is our
\(\nu_r(Y)\), and the shifts \(Y^{u}\) are there because the grid runs in both directions. Read
from right to left the theorem is the easy inclusion — each \(Y^{u}\nu_r(Y)\) is grid-integral
because the Gaussian binomials lie in \(\mathbb A\), and sums of integral values are integral. The
content is the other direction: <strong>every grid-integral Laurent polynomial is such a
combination</strong>. The combination need not be unique — the second witness below shows the
family is dependent — so this is a theorem about spanning, and it says exactly that.</p>

<p class="note"><strong>In the paper</strong> the same objects wear more dress: the rings carry a
subscript, \(A_t\) and \(F_t\), as a reminder that \(t\) is present; the grid coordinate carries a
check mark, which records where the grid comes from in higher rank and carries nothing at
\(\mathrm{GL}_1\); and the set of grid-integral Laurent polynomials is called the <em>even Newton
lattice</em> and written \(\mathcal N^{\mathrm{ev}}\), <em>ev</em> for the even powers. The
theorem is stated there as the equality of that set with the span of the shifted
\(q\)-binomial polynomials — the same statement, with the same content. This page drops the
decoration and nothing else.</p>

<h2>Where the difficulty lives</h2>

<p><strong>The polynomials have coefficients in \(\mathbb F\); what is required to lie in
\(\mathbb A\) are their values.</strong> If the coefficients were already in \(\mathbb A\)
there would be nothing to prove — the values would follow for free. The content is that a
polynomial can fail the coefficient test and pass the value test, and that the \(q\)-binomial polynomials
account for every way this can happen.</p>

<p>One element shows the gap is real. Take the first \(q\)-binomial polynomial:</p>

<div class="display">\[\nu_1(Y)=\frac{Y-1}{q-1}\]</div>

<p>Its single coefficient is \(1/(q-1)\). That coefficient does not lie in \(\mathbb A\), because
\(q-1\) cannot be inverted there. But watch what the polynomial itself does on the grid:</p>

<div class="band">
  <div class="gridfig">
    <table class="grid">
      <thead>
        <tr><th>node <span class="tag">\(Y=q^{\chi}\)</span></th><th>\(\nu_1\) evaluated there</th><th></th></tr>
      </thead>
      <tbody>
        <tr><td class="node">\(q^{-2}\)</td><td class="val">\(-q^{-1}-q^{-2}\)</td><td class="tag">integral</td></tr>
        <tr><td class="node">\(q^{-1}\)</td><td class="val">\(-q^{-1}\)</td><td class="tag">integral</td></tr>
        <tr><td class="node">\(q^{0}\)</td><td class="val">\(0\)</td><td class="tag">integral</td></tr>
        <tr><td class="node">\(q^{1}\)</td><td class="val">\(1\)</td><td class="tag">integral</td></tr>
        <tr><td class="node">\(q^{2}\)</td><td class="val">\(1+q\)</td><td class="tag">integral</td></tr>
        <tr><td class="node">\(q^{3}\)</td><td class="val">\(1+q+q^2\)</td><td class="tag">integral</td></tr>
        <tr class="off"><td class="node">\(v^{3}\)</td><td class="val">\(\frac{v^2+v+1}{v+1}\)</td><td class="tag">off the grid — not integral</td></tr>
      </tbody>
    </table>
  </div>
  <p class="cap">These are six nodes of a grid that runs on for ever in both directions, so the
  table illustrates the cancellation and is never the argument for it. What settles every node at
  once is the closed form \(\nu_1(q^{\chi})=(q^{\chi}-1)/(q-1)\), which equals
  \(1+q+\dots+q^{\chi-1}\) when \(\chi>0\) and \(-(q^{-1}+\dots+q^{\chi})\) when \(\chi<0\): a
  whole-number combination of powers of \(q\) either way. The last row is not a grid point at all,
  and there the cancellation fails; that row is the subject of the third witness below. The seven
  tabulated values were recomputed on the project's computer-algebra oracle while this page was
  written.</p>
</div>

<h2>Three ways the statement is tight</h2>

<p>Every clause in the statement is doing work, and one value each shows it. These are the sharp
edges of the result: what it delivers, what it stops short of, and the hypothesis it cannot do
without.</p>

<div class="wit">
  <span class="edge">The \(q\)-binomial polynomials are genuinely needed</span>
  <p><strong>\(\nu_1\) is grid-integral and its coefficient is not integral.</strong> The closed
  form above puts its value in \(\mathbb A\) at every one of the infinitely many nodes, while its
  single coefficient \((q-1)^{-1}\) lies outside \(\mathbb A\). So the grid-integral Laurent
  polynomials form a <em>strictly</em> larger set than \(\mathbb A[Y^{\pm1}]\), and the theorem
  says something the coefficients alone do not.</p>
</div>

<div class="wit">
  <span class="edge">It spans, and stops there</span>
  <p><strong>The generating family satisfies a relation:
  \((q-1)\,\nu_1(Y)-Y+1=0\) over \(\mathbb A\).</strong> So the shifted \(q\)-binomial
  polynomials span the grid-integral Laurent polynomials without being independent, and this is a
  <em>spanning</em> theorem — a basis theorem would be a stronger result and is not this one.
  Whether the grid-integral Laurent polynomials have a basis over \(\mathbb A\) is <strong>not settled
  by this record</strong>; the last section says what is known beyond it.</p>
</div>

<div class="wit">
  <span class="edge">The grid must be even</span>
  <p><strong>At the odd node \(v^{3}\) the value leaves \(\mathbb A\):</strong>
  \(\nu_1(v^3)=\frac{v^3-1}{v^2-1}=\frac{v^2+v+1}{v+1}\). Since \(q=v^2\), the grid is the
  <em>even</em> powers \(v^{2\chi}\), and \(\nu_1\) is integral at every one of
  them — but refine the grid to all powers of \(v\) and integrality breaks at the first
  new node. <strong>The word <em>even</em> in the statement is a hypothesis, not a
  convenience.</strong></p>
</div>

<p class="note">Each of these is settled by a single value, which is worth saying plainly: one
value is a complete proof of a statement of this shape, not evidence for it. Nothing here rests on
a sample.</p>

<h2>Where the statement came from</h2>

<p>The theorem is reached from known results along a line worth setting out, because each of the
four steps below changed what the question was about.</p>

<ol class="steps">
  <li><span class="yr">1915</span><div class="bd">
    <h3>Pólya — the additive origin</h3>
    <p>Integer-valued polynomials on the integers are the \(\mathbb Z\)-span of the binomial
    polynomials. The template for everything that follows.</p>
  </div></li>
  <li><span class="yr">1933 · 1990</span><div class="bd">
    <h3>Gel'fond, then Gramain — moving the grid</h3>
    <p>Ask for integrality along \(1,\,q,\,q^2,\,\dots\) instead. For entire functions that is
    Gel'fond, 1933 — the <em>multiplicative analogue</em> of Pólya's problem. For polynomials it is
    Gramain's Proposition 2.2: for an integer \(q\ge 2\), the polynomials integral at every
    \(q^{k}\) are generated by the Gauss binomial polynomials — <strong>which are
    exactly the \(\nu_r\) of this record.</strong></p>
  </div></li>
  <li><span class="yr">2016</span><div class="bd">
    <h3>Harman and Hopkins — deforming the coefficients</h3>
    <p>Which \(P\in\mathbb Q(q)[x]\) satisfy \(P([n]_q)\in\mathbb Z[q]\)? Their §1 answers it on
    the additive grid of \(q\)-integers; their §4 takes the nodes over all of
    \(\mathbb Z\), which is the <strong>bilateral</strong> form this record needs. Their §4 also
    contains the remark that joins the two lines: setting \(z=1+(q-1)x\) turns
    evaluation at \(x=[n]_q\) into evaluation at \(z=q^{n}\) — the
    additive grid becomes the geometric one, node for node.</p>
  </div></li>
  <li><span class="yr">this record</span><div class="bd">
    <h3>What is added — two routine transports</h3>
    <p>The grid variable is inverted, so the objects are <strong>Laurent</strong> rather than
    polynomial; at a grid of units that is a clearing argument, not a difficulty. And the
    coefficients carry a <strong>free parameter \(t\)</strong>, which arrives from the
    setting the goal was posed in and rides through as a spectator — the integrality test
    decomposes coefficient-wise.</p>
  </div></li>
</ol>

<h2>How far it has been checked</h2>

<p>The record exists in three layers — a written proof, a Julia instrument that computes the
objects, and a Lean development the proof kernel accepts. <strong>The grades below are different
kinds of claim, each meaning exactly what it states</strong>, and the edition keeps them
distinct.</p>

__GRADES__

<p class="note">The computed rows are the instrument (acceptance battery 87/87, with the grid
integrality checked for \(r\) in \(0\dots 8\) against \(\chi\) in \(-9\dots 9\), and a negative
control of 249 cases required to fail — which they do) and an independent oracle referee pin
(verdict <code>PROVED_BOUNDED</code>, 60 positive and 5 hostile seeds, 0 disagreements).</p>

<p><strong>The deliverable is the theorem with a clean axiom base.</strong>
No theory of integer-valued polynomials, classical or \(q\)-deformed, exists in Mathlib —
not Pólya's theorem, not a \(q\)-analogue. That absence is why the formal layer had to be
built rather than cited.</p>

<h2>The honest size of the result</h2>

<p><strong>First, what <em>rank</em> means here</strong>, because it is the one word on this page
with two readings. Rank is the <em>semisimple</em> rank: the number of simple roots. \(\mathrm{GL}_1\) has
none, so this record is the <strong>rank \(0\)</strong> case; \(\mathrm{GL}_2\) is rank 1, \(\mathrm{GL}_3\) is rank
2, and so on. The group \(\mathrm{GL}_1\) is of course one-dimensional, which is where the second reading
comes from, but nothing on this page uses it.</p>

<p><strong>At \(\mathrm{GL}_1\) this is the degenerate case, and the edition says so first.</strong>
The root system is empty, so the algebra is commutative and its centre is all of it; the Weyl group
is trivial; the Harish–Chandra projection is the identity map. Two of the three clauses in the
original goal are formalities at rank 0. <strong>The value of the record is that a small true
statement was carried end to end</strong>, and that the cost and the failure modes of doing so were
measured. Rank 1, which is \(\mathrm{GL}_2\), is a separate closed record of the same programme and is cited
in the paper; rank 2 and above are open, and nothing on this page bears on them.</p>

<p><strong>A tested agreement is not a proof.</strong> The Julia and Lean layers are two independent
implementations joined by a shared naming discipline, not by a checked morphism. Agreement between
them is established by testing, over the bounds printed above, and it licenses nothing beyond them.</p>

<p><strong>The ancestral result is not our result.</strong> The Harman–Hopkins bilateral quantum
Pólya theorem is the ancestor of the transported argument. The reconciliation that would identify
their lattice with this one is <strong>open</strong>.</p>

<h2>What is still open</h2>

<p>Three things, stated because an edition that lists only its results teaches a false boundary.
<strong>"Open" on this page means one thing: not settled by this closed record.</strong> The programme
has gone on with each of the three since the record closed, and what it holds is stated below with
its warrant, because the three grades of warrant are not interchangeable.</p>

<p><strong>A basis.</strong> This record proves that the grid-integral Laurent polynomials are spanned
by the shifted \(q\)-binomial polynomials and that this family is dependent; it exhibits no basis,
and nothing certified here decides whether the set is a free module over \(\mathbb A\). The
programme's closed, kernel-certified rank-one record (\(\mathrm{GL}_2\)) goes further: it exhibits bases —
the bilateral elementary basis, and the affine-Grassmannian and affine-flag <em>flow-up</em> bases —
and it proves, with the kernel's certificate, that the bilateral one-variable lattice is <em>free</em>
on the signed bilateral Newton rows (nodes taken in the order \(0,1,-1,2,-2,\dots\)): a Laurent
polynomial is integral at every signed node exactly when it has a unique expansion in those rows with
integral coefficients. What no record has done is carry that statement into this record's rings —
its coefficient ring has no square root of \(q\) and two spectator parameters where this one has
\(v\) and \(t\) — a routine base change of the kind this record itself performs, performed by nobody
for this statement. Work resting on the rank-one record's ordered-pair basis \(E_aE_b\), \(a\ge b\ge0\),
continues in a candidate manuscript, not adopted and not kernel-certified, and a further sandbox is
planned behind it.</p>

<p><strong>The four-way reconciliation.</strong> That Lusztig's toral lattice, this record's lattice,
the bilateral weight-Newton span and the transported Harman–Hopkins ring are one lattice under one
normalisation. Two of the three identifications are argued on the programme's own shelf, none is
chained, three frame differences block chaining by inspection, and the computer-algebra evidence
reaches degree 7. Open in the plain sense.</p>

<p><strong>Rank \(\ge2\).</strong> The two clauses that are formalities here carry the weight there,
and this record's argument does not transport. But the statement is not unknown. For \(\mathrm{GL}_3\) it is
kernel-certified in full — twenty-four declarations on the clean axiom triple, no <code>sorry</code>,
11 August 2026 — with the closure package filed and one criterion outstanding, the Overseer's
signature. For \(\mathrm{GL}_n\), every \(n\), the programme holds an informal proof, refereed and adopted on
24 August 2026: the <em>statement</em> is kernel-checked, the <em>proof</em> is not, no closed record
stands behind it, and its computational checks are bounded to declared ranges. What is open in the
plain sense is the general-lattice centre conjecture beyond the \(\mathrm{GL}_n\) lattice.</p>

<div class="colophon">
  <p><strong>This page is a companion: it explains, and the record certifies.</strong> The
  record-bearing edition — one row per result, joining all three layers under a stated convention
  frame, with per-row ancestry and a manifest of every shipped file and its hash — is a separate
  document, and where the two ever disagree the record is right and this page is wrong.</p>
  <p>Every mathematical claim on this page — the theorem, the three witnesses, the tabulated
  values, the open problems — is drawn from that edition's register. The seven grid values
  and the two identities in the witnesses were recomputed fresh on the project's warm
  computer-algebra oracle while this page was written. The closed form for \(\nu_1\), and the
  identification of \(\nu_r\)'s values with the Gaussian binomial coefficients, are cancellations
  from the definition quoted above — the powers of \(q^{s}\) divide out — and were confirmed
  symbolically over a range of \(r\) and \(\chi\) when this page was last revised.</p>
  <p>almanacA0a · pilot edition over the closed record <code>SandboxA/sandboxA0a</code> ·
  assembled by the Almanac Editor.</p>
</div>

</div>
"""

try:
    import latex2mathml.converter as l2m
except ImportError:
    sys.exit("latex2mathml is required at BUILD time only:  pip3 install --user latex2mathml")

s = TEMPLATE
counts = {"inline": 0, "display": 0}

def sub(kind, pattern, display):
    def repl(m):
        counts[kind] += 1
        try:
            return l2m.convert(m.group(1), display=display)
        except Exception as e:
            sys.exit(f"TeX failed to convert ({e}): {m.group(1)!r}")
    return pattern, repl

pat, repl = sub("display", re.compile(r"\\\[(.+?)\\\]", re.S), "block")
s = pat.sub(repl, s)
pat, repl = sub("inline", re.compile(r"\\\((.+?)\\\)", re.S), "inline")
s = pat.sub(repl, s)

# fail loudly rather than ship a half-rendered page
for leftover in (r"\\(", r"\\["):
    if leftover in s:
        sys.exit(f"unconverted TeX delimiter {leftover!r} left in output")

# mathvariant IS NOT A PROPERTY A READER'S BROWSER HONOURS (2026-09-13). latex2mathml emits
# \mathbb Z as <mi mathvariant="double-struck">Z</mi> and \mathcal N as <mi mathvariant="script">N</mi>.
# MathML Core -- what Chrome and Edge implement -- supports mathvariant ONLY with the value
# "normal"; every other value is ignored and the letter renders as an italic Z. The Overseer saw
# exactly that on the published page ("Z should be \mathbb Z"): the TeX source was right, the
# markup named the right variant, and the reader's engine dropped it silently. The fix is the one
# MathML Core itself prescribes: put the Unicode Mathematical Alphanumeric Symbol in the element
# and drop the attribute. U+2124 ℤ renders as ℤ everywhere. A variant this table does not know
# REFUSES the build rather than shipping a letter that will silently lose its face.
_STYLED_UPPER = {
    "double-struck": {"C": "ℂ", "H": "ℍ", "N": "ℕ", "P": "ℙ", "Q": "ℚ",
                      "R": "ℝ", "Z": "ℤ"},
    "script":        {"B": "ℬ", "E": "ℰ", "F": "ℱ", "H": "ℋ", "I": "ℐ",
                      "L": "ℒ", "M": "ℳ", "R": "ℛ"},
}
_STYLED_BASE = {"double-struck": 0x1D538, "script": 0x1D49C}
def _styled(m):
    variant, ch = m.group(1), m.group(2)
    if variant == "normal":
        return m.group(0)
    if variant not in _STYLED_BASE or len(ch) != 1 or not ("A" <= ch <= "Z"):
        sys.exit(f"render_explained: mathvariant={variant!r} on {ch!r} has no Unicode face in this "
                 f"renderer's table -- add it rather than ship a letter the browser will strip")
    u = _STYLED_UPPER[variant].get(ch) or chr(_STYLED_BASE[variant] + ord(ch) - ord("A"))
    return f"<mi>{u}</mi>"
s = re.sub(r'<mi mathvariant="([a-z-]+)">([^<]*)</mi>', _styled, s)
if 'mathvariant="' in s.replace('mathvariant="normal"', ""):
    sys.exit("render_explained: a non-normal mathvariant survived into the page")

# EVERY SCRIPT ELEMENT MUST HAVE THE ARITY MathML GIVES IT, AND latex2mathml WILL SILENTLY EMIT ONE
# THAT DOES NOT (2026-09-11). `\binom{n}{r}_{q}` converts to an <msub> with FOUR children -- the
# two parens, the fraction, and the subscript, all siblings -- because the converter takes the
# closing paren as the base rather than the group. A browser then lays them out in a row and the
# q stops being a subscript: the reader sees a DIFFERENT FORMULA, with no error anywhere. The fix
# at the source is a brace, `{\binom{n}{r}}_{q}`; the fix that keeps it fixed is this check, which
# is the same move as the placeholder guard -- the renderer refuses rather than ships something
# subtly wrong. Found while adding that very formula on the referee's notation instruction.
import xml.etree.ElementTree as _ET
_NS = "{http://www.w3.org/1998/Math/MathML}"
_ARITY = {"msub": 2, "msup": 2, "mover": 2, "munder": 2, "mfrac": 2, "mroot": 2,
          "msubsup": 3, "munderover": 3}
_bad = []
for _m in re.finditer(r"<math\b.*?</math>", s, re.S):
    _blob = _m.group(0)
    try:
        _root = _ET.fromstring(_blob)
    except _ET.ParseError as e:
        sys.exit(f"emitted MathML does not parse ({e}): {_blob[:200]}")
    for _el in _root.iter():
        _tag = _el.tag.replace(_NS, "")
        _want = _ARITY.get(_tag)
        if _want is not None and len(list(_el)) != _want:
            _bad.append(f"<{_tag}> has {len(list(_el))} children, MathML requires {_want}"
                        f"\n      in: {_blob[:240]}")
if _bad:
    sys.exit("render_explained: malformed MathML — a formula would render as a different formula:"
             "\n  - " + "\n  - ".join(_bad))
# THE GRADES ARE COUNTED, NOT TYPED, AND THEY RUN INK -> ORANGE -> BLUE.
# They were typed as 9/11, 2/11 and 0/11 with an em-dash where ink's description belongs, and had
# been wrong since 2026-08-31, when the twelfth row - the ink one - was added. The Overseer found it
# on the published page: "does not have ink certified statement (only 11 statements are mentioned)".
# FOURTH typed count in this edition to go stale; every other one is a measurement now, and so is
# this. The order is the standing one, ink -> orange -> blue, which this page had backwards too.
import json as _json
_con = _json.load(open(os.path.join(HERE, "CONCORDANCE.json"), encoding="utf-8"))
_w = [r.get("warrant") for r in _con["rows"]]
GRADES = """<div class="grades">
  <div class="grade g-n">
    <div class="n">{ink}<span class="nm" style="font-size:.62rem"> / {tot}</span></div>
    <div class="nm">ink \u2014 a refereed argument</div>
    <div class="wh">An argument written for a human reader and refereed. No kernel certifies it and
      no computation bounds it: the check is a referee reading the proof. The one here is the claim
      every other result rests on \u2014 that the proof proves the statement that was signed.</div>
  </div>
  <div class="grade g-c">
    <div class="n">{orange}<span class="nm" style="font-size:.62rem"> / {tot}</span></div>
    <div class="nm">orange \u2014 computed over a declared range</div>
    <div class="wh">Verified by computation over a stated bound, and over nothing else. The bound
      is part of the claim. Neither of these could ever be kernel-certified: no Lean declaration
      states what a Julia program does.</div>
  </div>
  <div class="grade g-k">
    <div class="n">{blue}<span class="nm" style="font-size:.62rem"> / {tot}</span></div>
    <div class="nm">blue \u2014 kernel-certified</div>
    <div class="wh">A Lean declaration states the claim and its axiom base is exactly
      <code>propext</code>, <code>Classical.choice</code>, <code>Quot.sound</code>: the three standard axioms of Lean's kernel — propositional extensionality, the axiom of choice and quotient soundness — the base every Mathlib proof shares; a certificate is clean when these three are all it needs \u2014 with no
      <code>sorryAx</code>, no custom axiom. Every one of these was measured first-hand
      through the Lean language server.</div>
  </div>
</div>""".format(ink=_w.count("ink"), orange=_w.count("orange"),
                 blue=_w.count("blue"), tot=len(_w))

# The mark goes in BEFORE the no-network check, so the check reads the bytes that ship.
s = s.replace("__WORDMARK__", wordmark()).replace("__WARRANT_VARS__", WARRANT_VARS)
s = s.replace("__GRADES__", GRADES)
if re.search(r"__[A-Z][A-Z0-9_]*__", s):
    sys.exit("render_explained: a placeholder survived into the page")

# The MathML xmlns URI is an identifier, never fetched. A NETWORK reference is something a tag
# would LOAD: a script, any src=, a <link href>. A navigation anchor loads nothing, and the page
# carries exactly one (2026-09-15, the Overseer: "could almanacA0a be clickable back to
# https://github.com/almanac-editions/almanacA0a"): the eyebrow's almanacA0a -> the artifact's own
# repository. That one URL is allowed BY VALUE; any other https href, anchor or not, still refuses.
REPO_URL = "https://github.com/almanac-editions/almanacA0a"
SERIES_URL = "https://github.com/almanac-editions"   # the mark links here (the Overseer, 2026-09-17)
_probe = s.replace(f'<a href="{REPO_URL}">', "<a>").replace(f'<a href="{SERIES_URL}"', "<a")
if re.search(r"<script\b", _probe) or re.search(r"""\b(?:src|href)\s*=\s*["']https?://""", _probe):
    sys.exit("output gained a script tag or a network reference — refusing to write")

open(OUT, "w", encoding="utf-8").write(s)
print(f"wrote {os.path.relpath(OUT, HERE)} ({len(s):,} bytes) — "
      f"{counts['display']} display + {counts['inline']} inline TeX runs -> MathML, "
      f"no scripts, no network references")
