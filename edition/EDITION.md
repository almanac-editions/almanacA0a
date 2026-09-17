<a href="https://github.com/almanac-editions">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="almanac-mark-dark.svg">
  <img src="almanac-mark.svg" align="right" width="110"
       alt="almanac — the word's three a's carry the three kinds of warrant: informal, computational, kernel-certified">
</picture>
</a>

# almanacA0a — the centre of the even hybrid family quantum GL₁

**Tamás Hausel** · Institute of Science and Technology Austria

**The pilot edition.** Assembled 2026-08-13 over the closed record `SandboxA/sandboxA0a`.

*This is the file to read first. Everything else in this directory is either machine-readable or a
reference.*

---

## What this is

A complete record of one small mathematical result, in three layers, with a per-claim account of
**what warrants each one**.

The result: for `G = GL₁`, the even hybrid family integral form `U^ev` is an `A_t`-subalgebra of
`U`; the Harish–Chandra projection restricts to an isomorphism `Z(U^ev) ≅ (N^ev)^W`; and the even
Newton lattice is exactly the `A_t`-span of the shifted divided classes,
`N^ev = Σ_u Σ_r A_t Y̌^u ν_r(Y̌)`.

The three layers: an **informal manuscript** (`informal/goalv0a.tex`, `informal/proofv0a.tex`), a
**Julia instrument** (`almanac/GL1Newton/`), and a **Lean development** (`Sandbox/A1/GL1/`, seven
modules).

**What makes this an almanac rather than an archive** is `CONCORDANCE.json`: one row per result,
joining the three layers by a convention frame under which all the names denote one object, and
recording per row what actually certifies it. The concordance does the aligning that a reader of
three parallel archives would otherwise have to do by hand.

## Ancestry: these manuscripts predate criterion 13, and ancestry is carried here

**Stated on the edition's face, because a reader is entitled to know it before anything else.**

This edition's two manuscripts are `informal/goalv0a.tex` (the signed goal, approval-1
2026-07-19) and `informal/proofv0a.tex` (the proof). **`goalv0a.tex` predates the project's
ancestry rule** — criterion 13, adopted 2026-08-05 — so its ancestry is carried at edition level
(§6a below). `proofv0a.tex` carries the rule's declaration in-file, and passes the manuscript gate
with the criterion enforced.

**Ancestry for the pre-criterion manuscript is therefore discharged at EDITION level** (edition
manifest §6a), leaving the signed file intact. That is a deliberate trade and the reasoning is
worth stating: `goalv0a.tex`'s sha256 is bound into the closure signature, and exchanging a
checkable anchor for a tidier-looking manuscript would be the wrong way round. **The criterion is
met in full.** Criterion 13 exists so that a reader can check ancestry *per claim*, and this edition
delivers exactly that, in a place that can be written without breaking a signature:

- `ANCESTRY.md` carries the edition-level search of record — what was searched, where, when, and
  what the searches turned up, including the ones that failed and what that failure taught;
- **every row of `CONCORDANCE.json` carries its own `ancestry` field** — a card id, or "none
  located" *with the search that failed behind it*;
- and this section states which manuscripts predate the rule.

A manuscript signed *after* 2026-08-05 gets no such treatment, and one touched substantively comes
under the rule at that touch.

**The three conditions are met**: `ANCESTRY.md` §§1, 7, 8 carry the searches; all eleven concordance
rows carry ancestry; this section is on the edition's face.

**And meeting them did real work — it caught a false claim before it was written.** On first
assembly four rows read *"none located, and none searched for"*, which §6 rightly calls an assertion
dressed as a finding. Worse, this Editor had advised the record's owner that the signed goal's five
definitions were plausibly all without predecessors — a reading endorsed in good faith and built into
a proposed act on the signed file. **The first search refuted it**: Definition 1's presentation half
has a genuine predecessor in Lusztig's *Introduction to Quantum Groups*, Prop. 3.2.4. On searching
all five, **at most one of the five proposed no-predecessor declarations survives, and even that one
is a half** — three definitions have located, quotable predecessors, and one (the divided classes
`ν_r`) turns out to be *exactly* the Harman–Hopkins `q`-binomial polynomial, verified symbolically
rather than by eye. Declaring otherwise would have written four false claims about the literature
into a signed lineage, where they would have looked verified forever.

## The scope of the claim

**GL₁ is the degenerate case, and the edition says so first.** The root system is empty, the Weyl
group is trivial, `U` is commutative, and the Harish–Chandra projection is the identity map. Clause
(ii) is therefore nearly vacuous at this rank. **The value of this record is that a small true
statement was carried end to end** — signed before it was proved,
refereed, kernel-certified, refuted-where-false, and then edited into a form a stranger can check —
and that the cost and the failure modes of doing so were measured. The rank ≥ 2 cases are the open
frontier and nothing here settles them.

**A tested agreement is not a proof.** The Julia layer and the Lean layer are two independent
implementations joined by a naming discipline, not by a checked morphism. Read `EMBEDDING_NOTE.md`
before drawing any conclusion about the code from a theorem, or about a theorem from the code.

**Nothing here claims the ancestral literature result is our result.** The Harman–Hopkins bilateral
quantum Pólya theorem is the ancestor of the transported argument for clause (iii). The four-way
lattice reconciliation that would identify their lattice with ours is **open**.

## The certification split

The three grades are distinct, and the edition keeps them distinct.

| grade | rows | what it means |
|---|---:|---|
| **ink** — a refereed argument | **1 of 12** | An argument written for a human reader and refereed. No kernel certifies it and no computation bounds it: the check is a referee reading the proof |
| **orange** — computed over a declared range | **2 of 12** | Verified by computation over a stated bound, and over nothing else |
| **blue** — kernel-certified | **9 of 12** | A Lean declaration states the row's claim, and its `#print axioms` result is exactly the three standard axioms of Lean's kernel — propositional extensionality (`propext`), the axiom of choice (`Classical.choice`) and quotient soundness (`Quot.sound`) — the base every Mathlib proof shares; a certificate is clean when these three are all it needs — with no `sorryAx` and no custom axiom |

**Every axiom result in this edition was measured first-hand on 2026-08-13**, through the Lean
language server. That first-hand measurement turned out to matter: see F-E1 below.

The two computed rows are the **instrument** and the **oracle referee pin** — and neither could ever
be kernel-certified, because no Lean declaration states what a Julia program does. That is the
manifest's rule and the record owner's explicit instruction on adopting the package: adoption makes
it a row, not a certificate.

## Was every row fillable?

**Yes — and every row was kept.** 12 rows, 9 with all three layers filled, 3 carrying a named absence: the two computed rows have no Lean declaration, and the ink row has neither, because what it claims is not the kind of thing either instrument can check.

The nulls are all of one kind: *this layer has nothing to say about this result.* Two rows are
formal-side guarantees with no counterpart environment in the manuscript (the non-degeneracy pin and
the coefficient-field bridge); two have no computational claim to make because the content is
definitional. **Each is named in the row rather than left blank**, because a dropped row makes an
edition look complete while a kept row with `lean: null` tells the truth.

## What this edition found

Assembling it surfaced **sixteen** findings — six at first assembly, the rest as the edition was
checked and re-checked — and they are the pilot's actual product. **The count rose as the edition matured, which is the correct direction**: every
finding added after assembly was found *by the form*, against the edition or its author. An edition
whose gap list converges to zero as it matures is one that stopped looking.

**One was blocking, and has been ruled.** The signed goal manuscript predates criterion 13, and
the manuscript gate stated that *an edition may not be published while any of its manuscripts still
lacks the declaration*. That stopped the edition dead. The general form outlives this pilot —
**criterion 13 was adopted after this goal was signed**, so every sandbox closed before the
criterion existed meets the same wall at its own edition — and it was ruled at the form level:
ancestry for a pre-criterion manuscript is now discharged at edition level (§6a above), with the
signed file intact. The finding changed the standard, which is
the more useful outcome than the edition quietly shipping.

**One is a record-keeping defect at the heart of the closure.** The closure signature records **13**
certified declarations; the release log it cites contains **5**; a third record says **8**. All
three cannot be right, and the endpoint the signature names does not appear in the log at all. The
log is unaltered since it was hashed into the closure record, so this is the evidence the closure
rests on.

**The reassuring half of that finding, measured rather than assumed:** the Editor verified the
endpoint `GOALv0a` directly, and it carries exactly the clean triple. So the *mathematical* claim is
sound; what is defective is the *retained evidence* for it. A third party re-running the public
re-verification would not be able to see most of what the signature asserts. **The concordance's
per-row warrant discipline is what made this visible** — had the edition been permitted the
inference the manifest forbids ("the sandbox is closed, therefore every row is certified"), nothing
would have surfaced.

**Two are stale records.** The formal source manifest is internally self-contradictory — it hashes
seven files while declaring a five-file cone, and declares a set of non-degeneracy witnesses absent
from the tree while listing the hash of the file containing them. Those witnesses are in the tree,
committed a day *before* the manifest that says they are missing, and are certified clean. Several
downstream documents still repeat the stale version.

**One is a number that could not be reproduced.** The instrument's acceptance battery is recorded as
`70/70` in three places; the test file statically contains 83 test statements. The Editor re-ran the
battery rather than ship a figure it could not reproduce: **87/87 PASS**. The edition prints the
number it measured and names the discrepancy.

**One is about the form itself.** The Editor is instructed to run `release_verify.sh --source`, and
that tool writes outside the Editor's chartered write surface, into a different closed sandbox's
tree. Two rules that are each correct are jointly unsatisfiable. The conflict stands recorded as a
finding, left for the form's owner to rule on.

**And one is about the sources.** The two literature cards carrying the ancestry this edition leads
with are **single-pass and unrefereed**, with a referee pass requested and still outstanding. They
are cited **with that label printed in the concordance row itself** — and their
convention frames, written in symbols the project retired on 2026-08-10, are restated by the edition
so that no reader is asked to transport retired notation themselves.

## Contents

| file | what it is |
|---|---|
| `EDITION.md` | this file |
| `CONCORDANCE.json` | **the spine** — one row per result, with its warrant |
| `EMBEDDING_NOTE.md` | what relates the code to the formal definitions, and what it does not establish |
| `ANCESTRY.md` | criterion 13 at edition level: the search of record, the frames, the findings |
| `AUTHORSHIP.md` | the authorship block |
| `MANIFEST.json` | the machine-readable inventory and the reproducibility recipe |
| `MEASUREMENT_LOG.md` | what the edition cost and what the gates caught — pinned by the manifest, **not distributed** with the edition; its figures are in `MANIFEST.json`'s cost block |

## Status

**ACCEPTED 2026-08-13 — DEPOSIT, PUBLICATION AND THE ROW-FREEZE ALL STILL LIE AHEAD.**

The record's owner has reviewed and **typed-accepted** this edition as *a faithful and
non-overclaiming account of the closed record* (`source/informal/EDITION_ACCEPTANCE_2026-08-13.md`).
Acceptance is exactly that and nothing more: **deposit, outward release and the row-freeze are the
later steps of the chain**, which runs *Editor (produced) → hypervisorA (accepted) → the
Librarian's door (deposit) → the Overseer (anything outward)*.

**Two conditions attached**, both of which this edition proposed against itself: deposit is
sequenced **after** the fresh certification log lands, so the public citation meets complete
evidence rather than the incomplete evidence disclosed below; and the drift protocol governs — when
record bytes move, the owner mails the Editor, who re-hashes and re-gates before deposit. **Rows
freeze at deposit.**

**One judgement the Editor offers rather than hides.** The edition would rather be deposited *after*
the closure-evidence repair (F-E1) than before it. **F-E1, stated here so that it travels:** the closure signature of the underlying record claims thirteen certified declarations and the certification log it cites evidences five; the edition's own concordance names its certified declarations one by one, and `replay/` re-derives thirty-one of them from source with their axioms — so the finding is about the record's evidence retention, not about any claim this edition makes. As things stand the edition faithfully cites the
sandbox's closure certification, and that citation points at evidence known to be incomplete. That
is disclosed here and in the concordance, so a deposit today would carry the full disclosure with
it — but citing
complete evidence is strictly better than citing incomplete evidence plus an explanation, and the
repair is already drafted and awaiting a signature. Timing is the tree owner's call.

A shortfall recorded is a finding; a shortfall smoothed over is the one outcome that would damage
this project. **This edition records sixteen**, and the last three were found against the Editor's own work by
the form the Editor was told to follow: rows claiming "none located" with no search behind them; the
inverted-dictionary defect written inside the section warning against it; and a CAS certificate that
faithfully measured a mis-transcribed formula, followed by a retraction that itself overshot. All
were caught with every warrant intact, and each left a lesson — which the accepting counterparty
recorded as part of the basis *for* acceptance rather than against it.
