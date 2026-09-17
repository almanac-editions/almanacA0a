# Referee pass — the two Harman–Hopkins clause-(iii) cards (caveat C1)

**Run 2026-08-13 by the Librarian**, discharging item 1 of hypervisorA's batch
`20260813T133844Z-hypervisorA-48024-9ed5` (originally `20260812T201756Z-hypervisorA-77484-182d`
item 2), and the C1 caveat of `SandboxA/sandboxA0a/informal/CITATION_VERIFICATION_2026-08-09.md`.
The Editor is a live consumer (`20260813T105602Z-editor-55716-dac8`, finding F-A1): the pilot
almanac edition has been shipping these two cards labelled *single-pass, unrefereed*.

**Cards under referee**

| card | grade before | grade after |
|---|---|---|
| `lit-harman-q-polya-qbinomial-basis` | literature-theorem, **single-pass, not refereed** | literature-theorem, **REFEREED — CONFIRMED** |
| `lit-harman-z-variable-lusztig-cartan-form` | literature-remark, **single-pass, not refereed** | literature-remark, **REFEREED — CONFIRMED, and the remark's own weakness re-confirmed** |

## Method, and why this pass is independent of the first

The 2026-08-09 pass read **printed page images** of the scan and compared them against the shelf
transcript. This pass read the **arXiv LaTeX source**
(`corpus/literature/arxiv_src/1601.06110/main.tex`, with `main.bbl`) — a different artefact, reached
by a different route, and the one that settles wording and numbering questions no image can
(the 2026-08-10 lesson: *when a request turns on a section number, open the source*). The two CAS
probes were **re-derived from scratch**, not re-run from the stored expressions: different code,
different certificate hashes.

## 1. `lit-harman-q-polya-qbinomial-basis` — CONFIRMED, no correction

| card claim | source check | verdict |
|---|---|---|
| Prop 1.1 (Pólya 1919), `ℛ` free on `binom(x,k)` | `\begin{proposition}[P\'olya 1919~\cite{polya1915ganzwertige}]` — as quoted | ✅ |
| `[n]_q := (q^n−1)/(q−1) = 1+q+⋯+q^{n−1}`, `[0]_q = 0`, one-sided `qbinom(n,k)_q = [n]_q!/([n−k]_q![k]_q!)` | verbatim, `main.tex` §1 | ✅ |
| `ℛ_q^+ := {P ∈ ℚ(q)[x] : P([n]_q) ∈ ℤ[q] ∀ n ∈ ℕ}` | verbatim | ✅ |
| **Prop 1.2 denominator `q^{binom(k,2)}[k]_q!`** — the card's own named risk point | `\qbinom{x}{k} := \frac{x(x-[1]_q)\dots(x-[k-1]_q)}{q^{\binom{k}{2}}[k]_q!}` | ✅ **exact** |
| evaluation `qbinom([n]_q, k) = qbinom(n,k)_q` | stated in Prop 1.2 and in the abstract's uniqueness clause | ✅ |
| the interpolation proof `P_k = P_{k−1} + (P([k]_q) − P_{k−1}([k]_q))·qbinom(x,k)` | verbatim | ✅ |
| the p. 14 sentence quoted "exactly as printed" | `main.tex` line 411 — matches word for word | ✅ |
| **the card's claim that both `ℛ` in that sentence are a slip for `ℛ_q`** | the source writes `\mathcal{R}` twice where `\mathcal{R}_q` is meant; it is the authors' own typo, present in the LaTeX and therefore not an extraction artefact | ✅ **confirmed at source** |

**CAS probes, independently re-derived.**

1. *The load-bearing normalisation.* Built `qbinom(x,k)` over `Frac(ℚ[q])[x]` from the printed
   formula and compared `qbinom([n]_q, k)` with `qbinom(n,k)_q` for all `0 ≤ n,k ≤ 6`:
   **49/49 true**, certificate `expr sha256 17543033c2f1ac49ca147cb82790a687107d558df41054e1bedda4700fcb07fb`
   (the 2026-08-09 certificate was `bc27c685…`; different expression, same verdict).
2. *The grid transport.* `1 + (Q−1)[n]_Q = Q^n` with `Q = q²` on seeds `n = 0,1,2,5,7` **and the
   added seed `n = 12`**: **CONFIRMED on 6/6**, certificate
   `identity sha256 fe69d069dedb3942606587ca18b556ab086eed6fec362c325210d67538bc0800`.

**No correction to the card's mathematics, conventions, or traps.** The `[CC97, Ch II Ex 15]`
qualification added on 2026-08-13 (Editor `20260813T115302Z`) stands as written, including its
explicit split between what the Librarian verified (Gramain, at source) and what is carried on the
Editor's reading (Ex 15).

**What this pass did NOT do**, so the limit is on the record: the card's `cas_probe_sketch` names an
unrun probe — *freeness of the lattice*, i.e. expanding our toral basis in the `qbinom(x,k)` basis
and checking the transition matrix is triangular with unit diagonal. **It remains unrun.** Two-way
integrality does not establish equality of lattices, and this referee pass does not close that.

## 2. `lit-harman-z-variable-lusztig-cartan-form` — CONFIRMED, including its weakness

| card claim | source check | verdict |
|---|---|---|
| the whole remark, quoted verbatim | `main.tex` line 417 — **matches word for word**, including the source's misspelling *"Luztig"* | ✅ |
| it is **unnumbered running text**, not a proposition | it sits between the definition of `ℛ_q^-` and `\end{section}`; no environment, no label | ✅ |
| the substitution half is said with *"evidently"* | *"is evidently isomorphic to `ℛ_q^+` (`ℛ_q`)"* | ✅ |
| the Lusztig half has **no proof and no definition of "equivalent"** | one sentence, bare `\cite{lusztig1987modular}` | ✅ |
| `[Lus89]` = Contemp. Math. **82**, Beijing 1987, **pp. 59–77**, 1989 | `main.bbl`: booktitle *Classical groups and related topics (Beijing, 1987)*, volume 82, pages 59–77, year 1989 | ✅ |
| `[Gra90]` = LNM **1415**, 1990 | `main.bbl`: *Cinquante ans de polynômes (Paris, 1988)*, volume 1415, **pages 123–137**, year 1990 | ✅ — and the page range independently corroborates `lit-gramain-geometric-progression-integer-valued-basis` (Gramain is **an article inside a volume**, pp. 123–137) |
| the closing sentences (theory "can be done just as easily in the `z` or `K` variable", `x` chosen for combinatorics/specialization) | verbatim | ✅ |

**The grade `literature-remark` is correct and should not be promoted.** The card's central warning —
*the Lusztig sentence is not a theorem* — is exactly what the source shows. Nothing in this pass
converts the assertion into an established input, and any programme record citing it must keep
saying so.

**Unprobed and unprobeable as stated**, re-confirmed: *"equivalent to the Cartan part of Lusztig's
integral form"* is not a formula. Before any probe, someone must fix the intended map; the honest
probe is the triangular-transition-matrix comparison already specified on
`own-weight-newton-basis-equals-lusztig-toral-lattice`.

## Verdict

**Both cards CONFIRMED at source. Neither required a correction.** Caveat C1 of
`CITATION_VERIFICATION_2026-08-09.md` is **discharged**; the A0a edition may drop the *single-pass,
unrefereed* label on these two cards and cite this report. The two limits that survive — the unrun
lattice-freeness probe, and the fact that the Lusztig equivalence is an unproved remark — are
properties of the *source*, not defects of the cards, and both are already printed on the cards.
