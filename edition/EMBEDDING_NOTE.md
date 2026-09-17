<a href="https://github.com/almanac-editions">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="almanac-mark-dark.svg">
  <img src="almanac-mark.svg" align="right" width="110"
       alt="almanac — the word's three a's carry the three kinds of warrant: informal, computational, kernel-certified">
</picture>
</a>

# The embedding note — what relates the code to the formal definitions

*almanacA0a. Form fixed by the edition manifest §10.*

**Read this before reading `CONCORDANCE.json`.** Every warrant in that file is calibrated by this
note. The edition has three layers — an informal manuscript, a Julia package, and a Lean
development — and a reader is entitled to know exactly what joins them, because *the join is
weaker than any of the three layers taken alone.*

---

## 1. What the embedding IS

**Shallow, and by name-and-convention rather than by a checked morphism.**

The package `almanac/GL1Newton/` and the Lean development `Sandbox/A1/GL1/` are **two independent
implementations of the same mathematical intent**. What connects them is a naming discipline the
project calls the *three-world same-name contract*: each mathematical stem carries the same
identifier in the human manuscript (`informal/goalv0a.tex`), in the Julia layer, and in the Lean
layer.

| stem | Julia (`GL1Newton`) | informal (`goalv0a.tex`) | Lean (`Sandbox/A1/GL1/`) |
|---|---|---|---|
| the divided class | `nu(R, r)` | `ν_r(X)` (Def. `nu`) | the `nu` family, `NewtonUnivGrid.lean` |
| the evaluation node | `grid(R, χ)` | `ev_χ(Y̌) = q^χ` (Def. `nev`) | the grid map, `NewtonUnivGrid.lean` |
| value on the grid | `nu_grid(R, r, χ)` | `ν_r(q^χ)` | `grid_nuGen` etc., `NewtonUnivGrid.lean` |
| Newton coordinates | `expand(R, f; D)` | the triangular sweep | `expand`, `NewtonUnivSpan.lean` |
| the target ring | `az(c)` | `A_t = ℤ[v^{±1}, t^{±1}]` | `Az`, `FamilyField1.lean` |
| the Newton lattice | `newton(R, f; window)` | `N^ev` (Def. `nev`) | `Newton`, `NewtonUnivGrid.lean` |
| the span side | `mem_span(R, f)` | `Σ_{u,r} A_t Y̌^u ν_r(Y̌)` | `nuGenSet` / span, `NewtonUnivSpan.lean` |

**This table is a dictionary, not a theorem.** No artifact in this edition proves that
`GL1Newton.nu` computes the `ν_r` that `NewtonUnivGrid.lean` reasons about. The identification is
made by a human reading both, and maintained by the shared identifier. **Stems are identifiers, not
notation** — the Sandbox-wide notation migration of 2026-08-10 (`Q→q`, `q→v`, `z→t`) changed the
mathematical symbols on every layer and deliberately left the stems alone, precisely so this
dictionary would survive it. A reader comparing the layers must therefore hold two things at once:
the stems agree across layers, and the *symbols* may not — the legacy substrate `HybridQuantum`
still writes `Q, q, z` where this package writes `q, v, t`.

There is no verified compilation, no extraction, no reflection, and no checked homomorphism in
either direction. **Neither layer is generated from the other.**

## 2. What was tested

Three distinct exercises, none of which is a proof of the correspondence:

**(a) The package's own acceptance battery** (`test/runtests.jl`, 12 test sets). It tests the
Julia layer against *the mathematics*, not against the Lean layer — that `ν_r` is triangular on
the grid, that its grid values are integral, that `newton`, `mem_span` and `laurent` separate as
the theory says they must, plus a mutate-and-recompute negative control that corrupts `nu` and
confirms the battery then fails. **The measured result is recorded in `MEASUREMENT_LOG.md` (not distributed; figures in `MANIFEST.json`),
including a discrepancy between the count recorded in the record and the count in the file.**

**(b) The bridge identity, which is the one real cross-layer tie** (test set A3):
`ν_r(q^m) = v^{r(m−r)} · sym_q_binom_value(F, m, r)`, checked over `0 ≤ r ≤ m ≤ 8` (45 pairs) plus
two named spot checks. This ties the package's `ν`-side to its own `v`-side symmetric-quantum
module — the seam the project designates as the first CAS→Lean embedding target. It is a tie
*within* the Julia layer, between two families that were built independently; it is evidence the
package is self-consistent, **not** evidence that it agrees with Lean.

**(c) The N1 clause-(iii) referee pin** (`n1_clause3_referee_pin.jl/.out`, 2026-07-21). This
exists because of a real defect found and fixed: the substrate's original `newton()` was defined
by ν-span, so it could not referee clause (iii) — the claim that the evaluation-defined lattice
*equals* the span — without circularity. The pin re-measures the two predicates independently at
window 8 over 60 random positive samples, 5 adversarial seeds, and one separator (`ν_1`, which
must lie in the lattice and the span but **not** in the Laurent ring), and reports
`PROVED_BOUNDED … disagreements=0`. **This is the strongest computational evidence in the
edition**, and it is still a bounded verdict about a Julia program.

**At what commit.** The package was extracted from the development substrate
`HybridQuantum/src/A1/gl1_newton.jl` (BQ-13 build, 2026-07-20) at estate commit `7ddb2e8f`, source
sha256 `2a2fe469…ff2c72`, on 2026-08-10, with four recorded test adaptations; the notation
migration was applied the same day and the battery re-run after it. The package is a **pinned
snapshot** — `HybridQuantum` remains the single development substrate.

## 3. Over what range

Bounds are part of the claim, and these are the actual ones, read from the test source:

| what | declared range |
|---|---|
| grid-value integrality of `ν_r` | `r ∈ 0..8`, `χ ∈ −9..9` — **171 cases**, all integral |
| triangularity (`ν_r(q^m)=0` for `m<r`; `ν_r(q^r)=1`) | `r ∈ 0..8` |
| the bridge identity (§2b) | `0 ≤ r ≤ m ≤ 8` — 45 pairs, plus spot checks `(1,2)`, `(2,6)` |
| the trap-4 witness separation | `k ∈ 0..6` — 7 values |
| frame controls (grid unshifted; `t` a spectator) | `χ ∈ −4..4`, `r ∈ 0..4` |
| negative control (corrupted `nu` must fail) | `r ∈ 0..8 × χ ∈ −9..9` (171); `r ∈ 1..6 × m ∈ −6..6` (**78**, all must fail) |
| `newton()` default verdict window | `χ ∈ −12..12`; overridable, and **`window = 0` is legal and still reported as bounded** |
| the N1 referee pin | window 8; 60 positives, 5 hostiles, 1 separator; seed `20260721` |

**`newton()` never returns an unbounded verdict.** Its return is `(Bool, Symbol, Int)` where the
integer *is* the window, and the success symbol is literally `:PROVED_BOUNDED`. A caller cannot
accidentally read a bounded check as a proof, because the bound is in the value. This is a design
property worth naming: the instrument refuses to overclaim at the type level.

## 4. What this does NOT establish

Stated plainly, because everything above is easy to over-read:

- **Agreement on a bounded range does not establish agreement in general.** That `ν_r(q^χ)` is
  integral for all 171 pairs with `r ≤ 8` and `|χ| ≤ 9` is not the statement that it is integral
  for all `r` and all `χ`. The unbounded statement is a *theorem*, and where the edition has one it
  is a Lean declaration, not a test.
- **A proof about the Lean definition is not a proof about the Julia code.** The Lean development
  proves things about objects defined in Lean. If `GL1Newton.nu` disagreed with the Lean `nu` —
  through a transcription slip, a convention drift, an off-by-one in the product index — **every
  Lean theorem would remain true and every test would remain green.** Nothing in this edition
  would detect it except a human reading both. That is the honest size of the risk, and the
  project has already been bitten once in this exact family: the N1 circularity in §2(c) was a
  definitional drift between layers, found by reading, not by a gate.
- **The code is evidence and instrument, never certificate.** Its role is to make a statement
  worth proving (the oracle gate) and to referee a claim independently of the proof (the N1 pin).
  It certifies nothing.
- **The dictionary in §1 is unproved.** It is the most load-bearing unproved thing in the edition.

## 5. The consequence for reading the concordance

Three rules follow, and `CONCORDANCE.json` is built to them:

1. **A row may not carry `warrant: blue` on the strength of a Lean proof if the claim
   the row makes is about the code.** The Lean declaration certifies the Lean statement. Nothing
   else.
2. **Rows whose subject is the package carry `orange`** with the range from
   §3 — never `blue`, however green the sandbox is. (This is also the accepting
   counterparty's explicit instruction on adopting the package: adoption makes it a row, not a
   certificate.)
3. **`blue` requires the actual axiom result**, the clean triple `propext`,
   `Classical.choice`, `Quot.sound` with no `sorryAx`. A row whose Lean declaration is absent is
   not kernel-certified, and a row whose Lean declaration exists but whose *evidence of
   certification* is not in the record is recorded as what it is. **This edition has
   exactly that case:** its closure signature records thirteen certified declarations while the
   log it cites carries five, and does not contain the endpoint the signature names — which is why
   this rule is not merely theoretical here.

## 6. Cannot fill

Per the manifest, an unexamined correspondence is a finding rather than a confident paragraph.
Recorded per object:

- **No object in this edition has a *checked* correspondence between its Julia and Lean
  realisations.** The correspondence is by name and convention throughout (§1). That is the
  actual, deliberately recorded state of the art here, and the project's
  own roadmap treats a machine-checked CAS→Lean embedding as future work — with the `QFunctions`
  symmetric family designated to go first and this package second, joined at the §2(b) bridge
  identity.
- **`expand`'s degree parameter `D`** has no Lean counterpart characterised in the record; the
  Lean `expand` is a coordinate map introduced to close a faithfulness finding, and whether the
  two agree on truncation behaviour has not been examined. Recorded as unexamined.
