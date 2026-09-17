# GL1Newton — the even Newton objects of GL₁ (almanacA0a pilot edition)

The computational layer of the **almanacA0a** pilot: the object set of the signed goal
`center-GL1` (goalv0a, signed 2026-07-19; notation-migrated edition 2026-08-10) as a
standalone Julia package. One toral coordinate, one family parameter, no Weyl action.

**Notation (current, Sandbox-wide):** quantum parameter `q = v²`, family parameter
`t = z²`; base field at this layer `K = ℚ(q, t)`, ring `K[x]`, grid `ev_χ(x) = q^χ`
over all of `ℤ`, target ring `A_t` (at this layer `ℤ[q^{±1}, t^{±1}]` — the declared
stronger-condition divergence of BQ-13 DESIGN §1.2, translated). The former symbols
`Q, q, z` of the legacy layers read `q, v, t` here.

## API (ten stems, the whole surface)

| function | object |
|---|---|
| `GL1Newton.Frame` / `frame()` | the base-ring data `K = ℚ(q,t)`, `Rx = K[x]` (cached) |
| `nu(R, r)` | the divided class `ν_r(x) = ∏_{s<r} (x−q^s)/(q^r−q^s)` |
| `grid(R, χ)` | the node `ev_χ(x) = q^χ` (two-sided, unshifted, t-free) |
| `nu_grid(R, r, χ)` | the value `ν_r(q^χ)` (always integral; Gaussian binomial for `χ ≥ r`) |
| `expand(R, f; D)` | Newton coordinates of `f` (triangular sweep) |
| `az(c)` | membership in `A_t` (stem named for the legacy ring symbol `A_z`) |
| `newton(R, f; window)` | the evaluation-integrality predicate for `N^ev` — **bounded verdict** `(Bool, Symbol, Int)`, never an unbounded proof |
| `mem_span(R, f)` | membership in `Σ_r A_t ν_r` (the RHS of clause (iii) — deciding it equals `newton` IS the theorem, not a definition) |
| `laurent(R, f)` | membership in `A_t[x]` (strictly smaller than `N^ev`; witness `ν_1`) |

## The three-world same-name contract

Every stem carries the same name in the human notes (`goalv0a.tex` / `proofv0a.tex`),
this Julia layer, and the Lean layer (`Sandbox/A1/GL1/`, kernel-certified 2026-07-21,
axioms exactly `[propext, Classical.choice, Quot.sound]`, no `sorryAx`). Stems are
identifiers, not notation — the 2026-08-10 migration changes mathematical symbols, not
stems, so the contract survives it intact. The legacy layers (HybridQuantum substrate,
certified Lean) still write `Q, q, z`; the dictionary is in the source header. This
contract is what makes the package a reference target for CAS→Lean shallow embedding:
the Lean column already exists and is certified, so an embedding's output can be diffed
against certified ground truth. (Embedding order of record: the QFunctions symmetric
family — the v-side — goes first; this package second. The §6.1 bridge identity
`ν_r(q^m) = v^{r(m−r)} · [m,r]_sym` is the seam joining the two, and the natural
cross-acceptance test.)

## Provenance

Extracted verbatim from the development substrate `HybridQuantum/src/A1/gl1_newton.jl`
(BQ-13 build, 2026-07-20) at Sandbox commit `7ddb2e8f`, source sha256
`2a2fe469…ff2c72`; extraction 2026-08-10, followed the same day by the Overseer-ordered
Sandbox-wide notation migration (former `Q,q,z` → `q,v,t`; Frame fields renamed; product
index `t` → `s`; no mathematical change). HybridQuantum remains the single development
substrate (AD-3), in its legacy symbols; this package is a pinned snapshot and is not
independently developed. The test battery is the BQ-13 acceptance battery with four
recorded adaptations (see `test/runtests.jl` header); the two HQ-internal
cross-instrument ties remain in HybridQuantum's own suite.

## The v-side layer: `qFunctions.jl`

`GL1Newton.QFunctions` (src/qFunctions.jl) is the A0a edition of the substrate's
symmetric quantum arithmetic (`HybridQuantum/src/QFunctions.jl`, sha-pinned in its
header), rewritten in current notation and decoupled from the HQ parent objects: a
cached `frame()` gives `K = ℚ(v)` with generator `v`, and the four functions
`q_int_sym`, `q_fact_sym`, `q_binom_sym`, `sym_q_binom_value` keep their substrate
stems (identifiers, not notation) while every formula and docstring is in `v` — the
substrate's `q` is the current `v`. This family is the intern's FIRST CAS→Lean
embedding target; the §6.1 bridge identity `ν_r(q^m) = v^{r(m−r)}·sym_q_binom_value(F,m,r)`
(tested in A3 through this very module) is the seam to the GL1Newton layer, which
embeds second.

## Running the tests

```sh
julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
```

(Requires Oscar; inside the estate run it through `engine/job_gate.py medium`.)
