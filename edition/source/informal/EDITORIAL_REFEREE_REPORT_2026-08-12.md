# Human-facing editorial referee report — goalv0a.tex and proofv0a.tex

**Lens:** SANDBOX_STANDARD §1 criterion 6 (human-facing editorial referee), at full weight.
Route A makes these manuscripts the outward almanac artifact, so the reader I refereed for is a
competent mathematician **outside** this program, reading the PDF with no access to the sandbox
record.

**Date:** 2026-08-12.
**Subjects (as read):**

| file | sha256 | lines |
|---|---|---|
| `informal/goalv0a.tex` | `7c46f318f07d2703c94595a8a867bd297b65d48f15eee4e6a66d06e815b1d44d` | 111 |
| `informal/proofv0a.tex` | `c42cbf8fc204bc04773dc308e9dd4c29efb65d64a3ebc1a2eeaacc6feb875cd1` | 414 |

**Context read:** `versions/goalv0a_SIGNED_2026-07-19.tex` (byte-frozen anchor, sha `91a50173…5a7e`),
`versions/goalv0a_SIGNED_2026-07-19_current-notation.tex`, `versions/proofv0a_pre-notation_2026-08-10.tex`,
`REFEREE_REPORT_PROOFv0a.md` (hostile mathematical referee, CONFIRM-WITH-FINDINGS),
`CITATION_VERIFICATION_2026-08-09.md`, `../SCOPE_CONTRACT.md`, `../goalv0a.lock.json`,
`../APPROVAL_STATE.json`, `proofv0a.ledger.json` + `proofv0a.current.report.json`,
and the cited source at `corpus/literature/arxiv_src/1601.06110/{main.tex,main.bbl}` plus its
Library transcript.

**This report is advisory and read-only.** No manuscript byte was touched.

---

## VERDICT (also restated at the end)

**PASS-WITH-EDITS.** 2 BLOCKING · 15 EDITORIAL · 12 NIT. The mathematics is sound and the
statement has **not** drifted from the signed anchor (mechanical proof below). Both BLOCKING
findings are one-sentence fixes.

---

## Semantic-drift check vs the signed anchor

**VERDICT: NO DRIFT. The live `goalv0a.tex` is a pure notation transform of the byte-frozen
signed anchor, verified mechanically, not by eye.**

Method: I applied the lock's declared dictionary (`goalv0a.lock.json` →
`notation_migration_2026_08_10.dictionary`) to the *signed anchor's own bytes* —
`\Az→\At`, `\Kz→\Ft`, `A_z→A_t`, `K_z→F_t`, then `Q→q`, `q→v`, `z→t` on standalone
math tokens, then the product index `t→s` inside Definition 5 — and diffed the result against
the live edition with the three declared non-mathematical items normalised away:

1. the added migration note paragraph (live lines 25–30),
2. `\newtheorem{goal}` → `\newtheorem*{goal}` (post-signing style rule: the Goal is unnumbered),
3. `\boxed{…}` removed from clause (ii) (post-signing style rule: the Goal is displayed plainly),
4. `\date{July 19, 2026 --- draft, unsigned}` → `\date{}`.

**Result: byte-identical.** Every ring, every relation, every quantifier, all three clauses.
In particular: `A_t = Z[v^{±1}, t^{±1}]` **is** the signed `A_z = Z[q^{±1}, z^{±1}]` under the
dictionary — the family parameter was **renamed** (`z ↦ t`), not squared, and the base ring is the
same ring. `K_{n,+}K_{n,-}=t^{\,n}` is the signed `=z^{\,n}`. `ev_χ(Ŷ)=q^{χ}` is the signed
`=Q^{χ}`. Clause (iii)'s sum is the signed sum. **No weakening, no strengthening, no hypothesis
added, no convention changed.**

I ran the same transform against `versions/proofv0a_pre-notation_2026-08-10.tex`. The migration
of the proof is likewise mathematically inert; the only non-mechanical differences are (a) the
added edition note, (b) the index rename `t→s`, (c) three places where an over-eager earlier pass
had renamed **Harman–Hopkins' own** parameter `q` to `v` and the live edition correctly restores
their symbol (`$q$-Pascal`, `$q$-binomials`, `$q$-deformed`, `\mathcal R_q^{+}`), (d) a repaired
`$Z[…]$` → `$\Z[…]$` typo at line 99, (e) a `\qedhere` display upgrade at 241–244. All improvements.

**One caveat, and it is the report's first BLOCKING finding:** the sentence that *announces* the
migration to the reader (`goalv0a.tex:26–28`, `proofv0a.tex:34–36`) describes the dictionary in a
way that invites the reader to conclude the opposite of what I just verified. See B1.

---

## BLOCKING (a reader is misled)

### B1 — the migration sentence asserts `t = z²`, with `z` undefined, and thereby invites the reader to infer a ring change that did not happen

`goalv0a.tex:26–28`:

> Signed July 19, 2026; this is the notation-migrated edition of August 10, 2026
> (same statement, current symbols: the former $Q,q,z$ are written $q,v,t$, with
> $q=v^{2}$ and $t=z^{2}$).

`proofv0a.tex:34–36` carries the identical clause.

Three defects compound here:

1. **`z` is the only symbol in either manuscript that is used and never defined.** It occurs
   exactly twice in the two documents outside this sentence — nowhere in `goalv0a.tex`, and once
   in `proofv0a.tex:384` ("our square root of $t$"), which presupposes the very definition that is
   missing. First-use completeness fails on the manuscript's first line of prose.
2. **The parallel construction is false.** "$q=v^{2}$" restates the signed frame's own
   `Q=q^{2}` under the rename and is correct. "$t=z^{2}$" has no counterpart in the signed frame:
   the signed `z` had no square root. Set side by side as a matched pair, the two look like the
   two halves of one dictionary, which they are not.
3. **The natural misreading is exactly the drift the reader is checking for.** A reader who takes
   "the former `z` is written `t`, with `t=z²`" at face value concludes that the new family
   parameter is the *square* of the signed one, hence
   `A_t = Z[v^{±1}, z^{±2}] ⊊ Z[q^{±1}, z^{±1}] = A_z` — a strictly smaller base ring, i.e. a
   different (weaker) theorem. That conclusion is wrong, but the sentence is what produces it.
   The one paragraph whose job is to certify "same statement" is the one paragraph that
   undermines it.

**Proposed rewording (both files, identical clause):**

> Signed July 19, 2026; this is the notation-migrated edition of August 10–11, 2026. The
> statement is unchanged — only symbols were renamed, by the Sandbox-wide dictionary
> $Q\mapsto q$, $q\mapsto v$, $z\mapsto t$: the relation formerly written $Q=q^{2}$ now reads
> $q=v^{2}$, and the family parameter formerly written $z$ is now written $t$.

If the program wants the four-symbol current frame on the record, append one sentence rather than
folding it into the dictionary:

> (In the current Sandbox-wide frame, $v$ and $z$ denote the square roots $v^{2}=q$ and
> $z^{2}=t$; only $v$ and $t$ occur below.)

**Owner must confirm which reading is intended before editing** — if `t = z²` was meant as a
relation between the *signed* `z` and the current `t`, then my drift verdict above and the lock's
own dictionary are in conflict with the manuscript, and that is an AMEND-class question, not an
editorial one. Everything I measured says it was not meant that way.

### B2 — the Attribution remark attributes Harman–Hopkins' Lusztig identification to the wrong object

`proofv0a.tex:383–386`:

> The node-preserving affine substitution $\Yc=1+(q-1)x$ (their \S4
> $z$-variable --- their symbol, unrelated to our square root of $t$ --- which is
> remarked there to give the Cartan part of Lusztig's integral form) carries the
> grid node $x=[n]_q$ to $\Yc=q^{n}$ …

The `which` attaches to "their §4 $z$-variable", so the manuscript says HH remark that the
$z$-variable gives the Cartan part of Lusztig's integral form. **They do not.** The source
(`corpus/literature/arxiv_src/1601.06110/main.tex:417`, verbatim) says:

> Going one step further, if we formally adjoin square roots $K^2 = z$ and $v^2 = q$, then the
> ring $\mathcal{R}_q[K,v]$ is equivalent to the Cartan part of Luztig's [sic] integral form of the
> quantum group $U_{v}(\mathfrak{sl}_2)$.

The identification is of `R_q[K,v]` — the $z$-variable **plus** the adjoined square roots — not of
the $z$-variable. On an outward artifact whose citations are meant to be checkable, a reader who
opens the source finds the manuscript's claim inexact. The correction is also *more favourable*
to this program, and `CITATION_VERIFICATION_2026-08-09.md` step 3 already records why: HH's
adjoined `K` (with `K²=z`) and `v` (with `v²=q`) are literally this manuscript's `T^{+}`
(with `(T^{+})²=Ŷ`) and `v` — the program frame **is** the square-root cover their remark
constructs. The manuscript is giving away its own best sentence and misciting at the same time.

The em-dash aside ("their symbol, unrelated to our square root of $t$") should go with it: it
leans on the undefined `z` of B1, and post-migration the collision it defends against no longer
exists (their `z` vs our `t` are different letters now). The positive statement — their `z` **is**
our `Ŷ` — is the one the reader needs.

**Proposed rewording:**

> The node-preserving affine substitution $\Yc=1+(q-1)x$ is exactly their \S4 $z$-variable; it
> carries the grid node $x=[n]_q$ to $\Yc=q^{n}$ and carries each basis term $\qbinom{x}{k}$ onto
> $\nu_k(\Yc)$ \emph{term by term} --- the factors $(q-1)$ cancel in every Newton ratio. (They
> remark further that on adjoining square roots $K^{2}=z$, $v^{2}=q$ --- which is precisely the
> passage to our $T^{+}$ and our $v$ --- the ring $\mathcal R_q[K,v]$ is equivalent to the Cartan
> part of Lusztig's integral form of $U_v(\mathfrak{sl}_2)$. Nothing below rests on that remark.)

---

## EDITORIAL (should fix)

### E1 — `proofv0a.tex:150–151` — clause (ii)'s key equality rests on an injectivity that is never stated

> the middle equality because $\Uev=\Nev\subseteq U$ maps into
> $U\otimes_{\Ft}\operatorname{Frac}(\At)$.

"Maps into" is not enough to license `Uev ∩ (U ⊗ Frac(A_t)) = Uev`, which requires `Uev` to sit
*inside* the base-changed algebra as a subset — i.e. requires `U → U ⊗_{F_t} Frac(A_t)` to be
injective. It is (the hostile referee supplied the reason at its item 8), but the manuscript
never says so. This is the one place in the document where a careful reader is asked to accept a
step the text does not justify, and it is in the shortest, most-read proof.

**Proposed:** "…the middle equality because $U\hookrightarrow U\otimes_{\Ft}\operatorname{Frac}(\At)$
is injective — $\Ft\hookrightarrow\operatorname{Frac}(\At)=\mathbb Q(v,t)$ and $U$ is free over
$\Ft$ — so $\Uev=\Nev\subseteq U$ is literally a subset of the base-changed algebra."

### E2 — `proofv0a.tex:80` — `Φ⁺` is used in a document that never introduces a root system

> Because $\Phi^{+}=\emptyset$ at $GL_1$, the \emph{even hybrid family integral form} is …

`proofv0a.tex` advertises itself as *stand-alone* (title, and line 33). It defines `v`, `t`, `q`,
`A_t`, `F_t`, `U`, `T^±`, `Ŷ`, `ev_χ`, `N^ev`, `W` — but never `Φ` or `Φ⁺`. A reader without
`goalv0a.tex` meets an undefined symbol carrying the load of the definition.

**Proposed:** "Because the root system of $GL_1$ is empty ($\Phi=\Phi^{+}=\emptyset$), the …"

### E3 — `proofv0a.tex:310–340` — Lemma 3's proof states the same argument three times, and says so twice in its own voice

The core argument occupies lines 300–308 and is complete there. It is then repeated as
*The $t$-spectator argument* (310–325), which closes "This is the same conclusion reached above",
and again as *Base change* (327–340), which closes "Equivalently, and most directly:" followed by
a verbatim restatement of lines 306–308. The hostile referee already flagged the second repetition
as "correct but redundant (not load-bearing)". For the human reader this is the manuscript's
largest readability defect: 30 of a 40-line proof are restatement, twice self-declared as such,
and it reads as though the author did not trust the argument.

**Proposed:** keep 280–308 unchanged; replace 310–340 with two sentences, e.g.

> \emph{Where $t$ goes.}\; The map $\ev_m$ substitutes only $\Yc\mapsto q^{m}$; it touches neither
> $v$ nor $t$, so $V$ and $V^{-1}$ have entries in $\Z[q^{\pm1}]$ and the system decouples over the
> $t$-powers. No flatness or base-change argument is needed: $V^{-1}$ has entries in
> $\Z[q^{\pm1}]\subseteq\At$ and $\mathbf v\in\At^{d+1}$, so $\mathbf c\in\At^{d+1}$, and in
> particular honest odd powers of $v$ in the $c_r$ cause no difficulty.

This is the single largest quality gain available and the single largest diff; see the churn
analysis.

### E4 — `proofv0a.tex:375, 387` — the same object typeset two different ways, one of them a tall inline box

The document defines `\qbinom` (line 23) and uses it correctly six times (196, 199, 216, 236, 239,
242). The Attribution then writes the *same* $q$-binomial coefficient polynomial as
`$\begin{bmatrix}x\\k\end{bmatrix}_{q}$` twice. Besides the inconsistency, an inline `bmatrix` is a
two-row box in a text line: it inflates leading in the surrounding paragraph in the PDF. (This is
the referee's finding F1 half-discharged — the *un-deformed* `\binom` was correctly removed, but
the replacement did not use the document's own macro.)

**Proposed:** `$\qbinom{x}{k}$` at both sites.

### E5 — `proofv0a.tex:236–238` — `[k]_q!` used, only `[k]_q` defined

> $=\frac{[n+r-1]_q!\,/\,[n-1]_q!}{[r]_q!}=\qbinom{n+r-1}{r}$, where $[k]_q=(q^{k}-1)/(q-1)$ and the
> common powers of $(q-1)$ cancel.

The factorial is introduced in the display and glossed only for the non-factorial. It reappears at
line 377.

**Proposed:** "…where $[k]_q=(q^{k}-1)/(q-1)$, $[k]_q!=[1]_q[2]_q\cdots[k]_q$, and the common
powers of $(q-1)$ cancel."

### E6 — `proofv0a.tex:314–316` — wrong base ring named for the basis actually used

> expand each coordinate along the free $\Z[v^{\pm1}]$-basis of $t$-powers: $c_r=\sum_{k}c_{r,k}\,t^{k}$
> with $c_{r,k}\in\mathbb Q(v)$.

A `Z[v^{±1}]`-basis with coefficients declared in `Q(v)` is a mismatch: `{t^k}` is a basis of `F_t`
over `Q(v)` and of `A_t` over `Z[v^{±1}]`, and the argument uses both. As written the reader has
to repair the sentence before using it.

**Proposed:** "expand each coordinate along the $t$-powers — a basis of $\Ft$ over $\mathbb Q(v)$,
and of $\At$ over $\Z[v^{\pm1}]$ — writing $c_r=\sum_k c_{r,k}t^{k}$ with $c_{r,k}\in\mathbb Q(v)$."
(Survives the E3 compression; fold in whichever version is kept.)

### E7 — `proofv0a.tex:372, 378` — internal Library labels leak into the human-facing document

> Their \S1 Proposition (Prop.~\S1.2, \texttt{prop:qbinom}), the …
> … their \S4 Proposition (Prop.~\S4.3, \texttt{prop:localization}), …

`\texttt{prop:qbinom}` and `\texttt{prop:localization}` are LaTeX labels from this program's
transcript of the source. They are meaningless to an outside reader and read as machine noise in a
typeset paper. Separately, "Prop.~\S1.2" reads as a *section* number; the source prints
"Proposition 1.2".

**Proposed:** "their Proposition 1.2, the $q$-analogue of …" and "their Proposition 4.3,
$\mathcal R_q=\mathcal R_q^{+}\otimes_{\Z[q]}\Z[q^{\pm1}]$, is the bilateral localization."
(Both numbers verified against the source.)

### E8 — `proofv0a.tex:406–410` — `\cite{SandboxGL2}` is unresolvable to any reader outside the program

> \bibitem{SandboxGL2} SandboxA, \emph{The centre of the even hybrid family quantum $GL_2$}
> (closure record of the signed goal, revision A1+R5), Sandbox record, 2026.

No identifier, no location, no availability statement — yet this is the *sole* support for the
clause (ii) parenthetical (line 136) and for the "rank-one specialization of that transport" claim
(line 396), i.e. for the manuscript's entire in-program ancestry. On the outward artifact the
reader is told a result exists and given no way to reach it.

**Proposed:** state what it is and that it is internal, e.g. "…, signed goal `center-GL2`, closure
record (revision A1+R5), Project Sandbox internal record, 2026 (not publicly available)."

**Gate caution:** the obvious richer fix — naming the certified Lean declarations
(`nuNewtonIntegral_iff_mem_span`, `gl2_center_closed_newton_laurent`), which
`CITATION_VERIFICATION_2026-08-09.md` verified at their source lines — risks tripping
`manuscript_gate` P2 (`no … formalisation language`) and P3 (`no computational evidence`). Test the
gate before committing to that variant.

### E9 — `proofv0a.tex:134, 396` — "rank-one" here, "rank-0" everywhere else in the sandbox

> The rank-one, $\Phi^{+}=\emptyset$ degeneration of the even hybrid Harish--Chandra isomorphism …
> The $GL_1$ statement above is the rank-one specialization of that transport.

`SCOPE_CONTRACT.md` ("the **rank-0 base case** of the root GOAL"), `APPROVAL_STATE.json`
("GL_1 (the rank-0 base case…)") and `REPORT.md` ("degenerate at rank 0") all say rank **0**. Both
are defensible (torus rank 1, semisimple rank 0), and neither document defines which it means. A
route-A reader who reads the manuscript and then the sandbox page meets both numbers for the same
object.

**Proposed:** on first use, "the rank-one (equivalently, semisimple-rank-zero) degeneration …", or
drop the number: "the $GL_1$ degeneration of …". Harmonise with whatever the outward pages say.

### E10 — `goalv0a.tex` carries no `% criterion-13: adopted`, and the gate says that blocks publication of the edition [publication-gating]

`manuscript_gate.py --kind goal` on the live file returns **PASS**, but with:

> NOTE: criterion 13 (ancestry) is reported but NOT enforced for this file — it carries no
> `% criterion-13: adopted` line. … **An edition may not be published while any of its manuscripts
> still lacks the declaration.**

followed by five G9 NOTICEs (lines 42, 55, 68, 78, 89 — every definition, no citation and no
`\nopredecessor`). `proofv0a.tex` adopted the rule at its line 2 and passes P9 cleanly. Since route
A is a publication path, the goal manuscript is currently the thing standing in front of it.

**This is not an editorial edit and I do not recommend making it as one.** Adding the declaration
converts the five NOTICEs into FAILURES, so it must be accompanied by a citation or
`\nopredecessor` on five definitions of a **hash-locked, Overseer-signed statement**. Route to the
Overseer under the SANDBOX_STANDARD §5 amendment protocol, with the observation that four of the
five definitions are specializations of the root `informal/goal.tex` and the fifth (Newton divided
classes) has the Harman–Hopkins ancestry the proof already cites.

### E11 — `goalv0a.tex:58–60` — `ev_χ` is under-determined as defined (inherited; recommend NO edit)

> For $\chi\in X_\Lambda$ let $\mathrm{ev}_\chi$ be the $\At$-linear map on even toral elements
> determined by $\mathrm{ev}_\chi(\Yc)=q^{\,\chi}$.

An `A_t`-**linear map** on `F_t[Ŷ^{±1}]` is not determined by its value at `Ŷ`; multiplicativity
is what pins it. The proof silently upgrades this to "the $\Ft$-algebra homomorphism substituting
the unit $q^{\chi}$ for $\Yc$" (`proofv0a.tex:67–69`), which is correct and defines the same `N^ev`.
The looseness is **verbatim in the signed anchor** — it is not drift, and the hostile referee
recorded the same point (its finding 3).

**Recommendation: record, do not edit.** Repairing it touches the locked statement.

### E12 — `goalv0a.tex:32–34, 58, 64` — `X_Λ` is never said to *be* anything (inherited; recommend NO edit)

> the cocharacter lattice is $\Lambda=\mathbb Z$, and $X_\Lambda=\mathbb Z$.

The reader is told the value and never the meaning, then `χ` is quantified over `X_Λ` at line 58
and over `ℤ` at line 64, six lines apart, with no word that they are the same index set. Inherited
verbatim from the signed anchor. **Record, do not edit** (a gloss would change a definition of a
locked statement). Worth one line in whatever front-matter the almanac wraps around the PDF.

### E13 — `proofv0a.tex:36–38` — the opening sentence mislabels what is proved

> The result identifies the even hybrid integral form of the family quantum $GL_1$ with its
> centre and with a Newton (divided-class) lattice;

`U^{hyb,ev}` **is** `N^ev` by definition (line 81, and `goalv0a.tex` Def 3). So "identifies … with
a Newton lattice" describes a definition, not a result. The actual content of clause (iii) is the
identification of the *evaluation-integrality* lattice with the *span of the divided classes* —
which the next clause of the same sentence then correctly names as HH's theorem. The first thing
the reader is told about the paper is the one thing the paper does not do.

**Proposed:** "The result shows that the even hybrid integral form of the family quantum $GL_1$ —
cut out by integrality of all evaluations on the grid $q^{\mathbb Z}$ — is an $\At$-subalgebra, is
its own centre, and is spanned over $\At$ by the shifted Newton divided classes; clause~(iii) is the
bilateral quantum Pólya theorem of Harman and Hopkins, transported to the multiplicative grid of the
toral algebra (attribution remark at the end)."

### E14 — `proofv0a.tex:74` — the referee's finding 3 re-examined: the manuscript is RIGHT, no edit

> It is the unique $\At$-linear ring homomorphism with $\ev_\chi(\Yc)=q^{\chi}$, and it fixes
> $\Ft$ (hence $\At$) pointwise.

`REFEREE_REPORT_PROOFv0a.md` finding 3 calls this uniqueness claim not "literally forced". I
checked it and it **is** forced: an `A_t`-linear ring homomorphism fixes `Z[v^{±1}]` pointwise, and
a ring homomorphism into a domain that fixes `Z[v]` pointwise fixes every `a/b ∈ Q(v)` (from
`φ(a/b)·b = φ(a) = a`), hence fixes `F_t = Q(v)[t^{±1}]`; together with `ev_χ(Ŷ)=q^χ` that
determines the map on `F_t[Ŷ^{±1}]`. **No edit.** Recorded so the point is not re-raised a third
time. (The sentence order would read better as "It fixes `F_t` (hence `A_t`) pointwise, and is the
unique ring homomorphism doing so with `ev_χ(Ŷ)=q^χ`" — cosmetic only.)

### E15 — `proofv0a.tex:162–164` — a bare paragraph doing a `remark` environment's job

> \noindent
> There is no content here beyond commutativity: at $GL_1$ the rational centre is everything,
> $\HC$ is the identity, and Weyl invariance is vacuous.

The document declares a `remark` environment and uses it once (line 368). This paragraph is a
remark set as loose body text. (Its *content* is exactly the honesty item `SCOPE_CONTRACT.md`
requires "wherever v0a is cited", and it discharges it — the objection is only to the packaging.)
Wrapping it renumbers the Attribution remark 1→2; nothing in the ledger cites a Remark number.

---

## NIT

- **N1 — `goalv0a.tex:42, 55, 68, 78, 89, 97`.** All six `\label`s are orphans; the file contains
  no `\ref`. `goalv0a.aux` further shows `\newlabel{goal:main}{{}{1}}` — because the Goal
  environment is starred, the label resolves to an **empty** number, so any future
  `\ref{goal:main}` would silently print nothing. Latent, harmless today.
- **N2 — `proofv0a.tex:12`.** `\newtheorem{definition}{Definition}` is declared and never used
  (Conventions uses run-in `\emph{…}` headings).
- **N3 — `proofv0a.tex:9–13`.** `theorem`/`proposition`/`lemma` have independent counters, so
  "Proposition 1", "Theorem 1" and "Lemma 1" coexist. **Do not "fix" this.**
  `proofv0a.ledger.json` cites the numbers verbatim ("Lemma 1(a)", "Lemma 1(b)", "Lemma 1(c)",
  "Lemma 2", "Lemma 3 core", "Theorem 1 assembly"); a shared counter would silently desynchronise
  every ledger claim label from the manuscript.
- **N4 — `proofv0a.tex:99` vs `187`.** "$\Z[q^{\pm1}]$-*integral*" is defined in the body and used
  only in a subsection title.
- **N5 — `proofv0a.tex:33–35`.** "the notation-migrated edition of August 10, 2026 of the refereed
  proof of July 19, 2026" — stacked "of"s. Suggest "This is the August 10, 2026 notation-migrated
  edition of the proof of July 19, 2026 (refereed the following day)."
- **N6 — `goalv0a.tex:26`, `proofv0a.tex:34`.** The edition date is stale: both say "August 10,
  2026", but the live files also carry the 2026-08-11 `K_t → F_t` rename
  (`goalv0a.lock.json → f_t_rename_2026_08_11`; `proofv0a.ledger.json →
  document_revision_note_2026_08_11`). Fold "August 10–11" into the B1 rewrite.
- **N7 — `goalv0a.tex:51` vs `proofv0a.tex:57`.** `T^{\pm}:=K_{1,\pm}` vs `T^{\pm}=K_{1,\pm}`;
  likewise `goalv0a.tex:72` `\subset` vs `proofv0a.tex:81` `\subseteq` for the same inclusion.
- **N8 — `proofv0a.tex:218–220`.** The `q`-Pascal induction also needs the boundary
  `\qbinom{m}{r}=0` for `r>m`; only `\qbinom{m}{0}=1` is given.
- **N9 — `proofv0a.tex:369–370`.** The Attribution's own opening gives the reference inline
  ("(arXiv:1601.06110)") rather than `\cite{HarmanHopkins}` — in the one remark whose subject is
  attribution. Both then appear, with the bibliography, three times in one page.
- **N10 — `proofv0a.tex:373`.** Set-builder `:` in inline math; `\colon` (which the source itself
  uses) sets the spacing correctly.
- **N11 — `goalv0a.tex:50`.** "no generators $e_i,F_i$" — mixed case. This *matches* the
  program-wide convention (`[e_i,F_i]=K_i^+ − K_i^-`, root `CLAUDE.md`); leave it, but an outside
  reader will read it as a typo, so it may deserve a note in the almanac front matter.
- **N12 — `proofv0a.tex:401–404`.** Harman–Hopkins is cited by arXiv identifier only. The
  identifier is **correct** (verified against `corpus/literature/arxiv_src/1601.06110`). If the
  program wants the published venue it must be sourced separately — the local copy is the preprint
  and I did not verify a journal reference.

---

## Verified clean (checked, no finding — recorded so these are not re-litigated)

1. **"Pólya's 1919 theorem" (`proofv0a.tex:371–372`) is FAITHFUL to the source,** despite the
   misleading Library bib key `polya1915ganzwertige`. The source writes
   `\begin{proposition}[P\'olya 1919~\cite{polya1915ganzwertige}]` (`main.tex:99`) and the entry is
   *J. Reine Angew. Math.* **149** (1919), 97–116 (`main.bbl:266–284`). I flagged this as a
   suspected date error and it survived.
2. **Every Harman–Hopkins quotation is verbatim:** the `R_q^+` definition, "freely generated as a
   `Z[q]`-module by the `q`-binomial coefficient polynomials", the denominator `q^{C(k,2)}[k]_q!`,
   the additive grid `x=[n]_q`, Proposition 4.3 `R_q = R_q^+ ⊗_{Z[q]} Z[q^{±1}]`, and the node map
   `x=[n]_q ↦ Ŷ=q^n`. Numbering 1.2 and 4.3 both check out against the source's per-section counter.
3. **"their parameter $q$ coincides with our $q$ ($=v^{2}$), so their displayed formulas read
   verbatim on our side" (`proofv0a.tex:380–381`) is correct** and is the migration's genuine
   payoff — the pre-migration edition had to carry a dictionary here and no longer does.
4. **The term-by-term transport claim (`proofv0a.tex:386–388`) is exact.** I recomputed:
   `∏_{s<k}(q^k−q^s) = q^{C(k,2)} ∏_{i=1}^{k}(q^i−1)`, which is precisely HH's denominator, so
   `qbinom(x,k)|_{x=(Ŷ−1)/(q−1)} = ν_k(Ŷ)` on the nose and the `(q−1)` factors do cancel.
5. **The SCOPE_CONTRACT honesty stance is honoured, not oversold.** Clause (iii) is named as
   Harman–Hopkins' theorem in the *opening paragraph* (line 38), again in the theorem's own
   parenthetical (178–181), and the in-program `GL_2` ancestry is stated at 392–396 with the
   `GL_1` statement called "the rank-one specialization of that transport". The mandatory Weyl
   caveat is discharged at 162–164. I found **no** sentence claiming clause (iii) as new.
6. **No legacy symbol survives the migration** anywhere in either manuscript. `Q`, `A_z`, `K_z`,
   `K_t` and the product index `t` appear nowhere except inside the migration sentence itself
   (B1) and in the deliberate reference to HH's own `z` (B2).
7. **Both files build warning-free** (`goalv0a.log`, `proofv0a.log`: zero warnings, zero
   over/underfull boxes, no undefined references). `manuscript_gate`: goal PASS (8 rules + 1
   NOTICE, see E10), proof **PASS 9/9** with criterion-13 enforced.
8. **`goalv0a.pdf` sha `cfaa2f86…` matches `goalv0a.lock.json → current_edition_pdf_sha256`.**

---

## Which edits are worth the byte-churn

Any byte change to `proofv0a.tex` forces a ledger document re-pin
(`document_sha256_at_transcription`), a battery re-run, a PDF rebuild, and a gate re-run. **You pay
that once whether you fix one finding or fifteen — so batch them into a single pass, or do none.**

**Worth it — one batched pass on `proofv0a.tex`:** B2, E1, E2, E3, E4, E5, E6, E7, E8, E9, E13,
plus N5, N6, N8, N9, N10 folded in for free. E3 is the largest diff and the largest reader gain;
including it is the whole reason to open the file.

**Worth it — one pass on `goalv0a.tex`, confined to the migration note (lines 25–30):** B1, N6.
This paragraph is editorial matter added at migration; it is **not** part of the signed statement,
so it can be repaired without the amendment protocol. Update `current_edition_tex_sha256` and
`current_edition_pdf_sha256` in `goalv0a.lock.json` afterwards.

**Not worth it / must not be done as an editorial edit:**

- **N3** (shared theorem counter) — actively harmful; would desynchronise the ledger claim labels.
- **E11, E12** — inherited verbatim from the signed anchor; repairing them is a statement
  amendment (SANDBOX_STANDARD §5), not an editorial pass.
- **E10** — publication-gating, but the remedy touches five definitions of a locked statement.
  Overseer decision.
- **E14** — no edit; the manuscript is correct.
- **E15, N1, N2, N4, N7, N11, N12** — fold in only because the file is already open; none justifies
  a re-pin on its own.

---

## Collateral (outside my two subjects; read-only, reported to the owner)

Not findings against the manuscripts, but a route-A reader who follows the manuscript into the
record will hit these:

1. **`APPROVAL_STATE.json → notation_migration_2026_08_10.current_proof_tex_sha256 =
   "7110a472…"` is STALE.** The live `proofv0a.tex` is `c42cbf8f…`. The ledger and its report are
   *current* (both pin `c42cbf8f…`, re-pinned by `document_revision_note_2026_08_11` after the
   `F_t` rename); it is the approval record that was not carried forward. Anyone verifying the
   manuscript against the approval record today gets a hash mismatch.
2. **`CITATION_VERIFICATION_2026-08-09.md` addendum (lines 82–92)** quotes the same stale
   `7110a472…` and states the dictionary as "`A_z→A_t, K_z→K_t`" — superseded by the `F_t` naming
   of 2026-08-11, which the live manuscripts already use.
3. **`REPORT.md`** still reads "**Approval-2 … NOT SIGNED**"; `APPROVAL_STATE.json` records it
   SIGNED at `2026-07-20T12:59:23Z`. The report is dated 2026-07-20 (wave 3) and predates the
   signature by hours.
4. **Not a defect:** the ledger's claim strings are in legacy symbols (`[m r]_Q`, `Z[Q^{pm}]`,
   `z-spectator`). `proofv0a.ledger.json → frame` explicitly declares this — the expressions are
   code against the shared engine preload, whose API keeps the legacy names, and the note supplies
   the translation. Correctly handled.

---

## VERDICT

**PASS-WITH-EDITS.**

| class | count |
|---|---|
| BLOCKING | 2 |
| EDITORIAL | 15 |
| NIT | 12 |

**Semantic-drift check vs the signed anchor: NO DRIFT** — the live `goalv0a.tex` is byte-identical
to the mechanical dictionary transform of `versions/goalv0a_SIGNED_2026-07-19.tex` (sha
`91a50173…5a7e`), modulo the added migration note and the three declared post-signing style
conformances. The proof's migration is likewise mathematically inert.

Both BLOCKING findings are one-sentence repairs (B1 in both files, B2 in the proof). Neither the
mathematics nor the statement is in question; what is in question is that the paragraph certifying
"same statement" invites the reader to infer a smaller base ring (B1), and that the one place
where the manuscript reports what its cited source says, it reports something the source does not
say (B2). On an outward artifact both must go before publication. Everything else is quality of
exposition, and the compression of Lemma 3 (E3) is the item that would most change how the
manuscript reads.
