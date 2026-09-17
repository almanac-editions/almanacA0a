---
id: even-gaussian-span-not-newton-lattice-refuted
aliases: ["the Gaussian span is not the Newton lattice", "Q^{ev}-generated even span versus the Verma-saturated Newton lattice", "is the even span the whole Newton lattice"]
aliases_note: "The words a seat would TYPE for this result -- not a summary, and not a replacement for the verbatim statement, which is unchanged. A title names the OBJECT; an alias is how the result gets ASKED FOR. Written 2026-08-20 by the librarian from THIS CARD'S OWN statement, read before typed and never inferred from the filename. Overseer-commissioned via architect 20260820T203013Z-architect-46844-ff88."
status: refuted
provenance: ours
provenance_note: "The refuted claim is the frozen 2026-07-02 note's own sentence (`equivalently ...`, lines 279-281, and the GL_2 substitution at lines 288-316). The witness was authored by residentA in LR-20260809T162350Z and re-run independently on the warm CAS oracle by this Library on 2026-08-10 before registration."
project: center
lens: what-was-tried-and-is-closed-the-Gaussian-span-is-strictly-smaller
first_stated: 2026-07-02 (corpus/sources/center/even_hybrid_center_definition_conjecture_2026-07-02.tex, lines 279-281)
refuted_on: 2026-08-10
sources: ["corpus/sources/center/even_hybrid_center_definition_conjecture_2026-07-02.tex@309b397297146d — the claim", "corpus/requests/LR-20260809T162350Z-residentA-even-newton-gaussian-source-correction.md — the witness", "erratum-2026-07-02-even-toral-three-objects — the full erratum, passage by passage"]
feeds: ["LR-20260725T151043Z-residentroot-newton-gaussian — that request's Q^ev-span-versus-Newton half is answered NEGATIVELY by this card; its degree-zero-Lusztig-versus-Newton half is untouched and still open.", "center-conjecture-rank-ge-2 — its `explicit open equivalence lemma` is decided in one reading.", "Anyone about to prove `Z(U^{Λ,ev}_hyb) ≅ (T^ev_Λ)^W` from the Gaussian generators: the target ring is the wrong one unless you mean the saturated lattice."]
cas_evidence: "Warrant (re-runnable). Kernel: warm cas_server 127.0.0.1:9917, Julia 1.12.6, HybridQuantum 0.1.0-DEV, Sandbox @091da5b6, 2026-08-10T12:52-12:56Z. EXACT symbolic arithmetic in the fraction field of Z[q] / Z[q,X] / Z[q,K] — no sampling, no specialization of q, so the separations below are identities and not screened failures. Expression sha256: aaf5a91ef7bdcc19f8d1516eadf0cd01895aa101d28ff2efa73ef6f4ac8c7800 · f0596f5ca6481032743a830a7d89b94b80967ce5d81efc567afcf1fd9380ae13 · 3af45e5c9c7376dc47ef5b24873cad137f34955c7d63a1ebe470da32a8124341 · 56053dc57ba09252284080becf02165e747595bf589e162bf2298d827fdc5a04. Bounds screened: generator index n, r in 0..6, grid index m, k in -8..8, Lusztig degree t in 0..4 with eps in a ±4 window. Hostile directions: negative grid indices on BOTH grids (where one-sided Gaussian binomials usually break), both q-grid parities, and the degenerate n = 0 / t = 0 rows, which separate nothing and are named as such."
conventions_gap: "A_z = Z[q^{±1}][Lambda], Q = q^2, X_lambda = K_{lambda,+}^2, ev_chi(X_lambda) = Q^{<lambda,chi>}. Q_i^ev(n) = K_{i,+}^{2 floor(n/2)} (q_i^{floor((n-1)/2)} K_{i,+}^2 ; q_i)_n / (q_i;q_i)_n, exactly as displayed at source lines 267-278 — NOT the inverse-convention Q^ev written in own-sl3-habiro-le-even-center-conjecture, which carries K^{-2 floor(n/2)} and a negated q-shift. Check which of the two you have before transporting anything from this card."
traps: ["REFUTED IN ONE READING ONLY. What is dead is `Q^ev-generated span = Verma-saturated Newton lattice`. The comparison of the DEGREE-ZERO LUSZTIG lattice with the Newton lattice is a different question and this card does not touch it — in rank one it is an equality; in rank ≥ 2 nobody here has checked it.", "THE WITNESS IS INSIDE THE SOURCE. nu_{a,1} = Phi_1 is the source's own displayed Newton generator. A reader looking for an external counterexample will look past it.", "DO NOT READ THIS AS `THE GAUSSIAN GENERATORS ARE WRONG`. They generate a perfectly good lattice; it is a strictly smaller one, characterised by integrality on the FINER full q-grid. Whether that smaller lattice is the right target for the centre theorem is a separate question nobody has settled.", "THE DISPLAYED DIRECT SUM IS NOT DIRECT. X - 1 - (q-1) Q^ev(1) = 0 exactly, so the generators are already A_z-dependent at degree one. A proof that counts ranks off that display is counting wrong."]
---

# REFUTED — the `Q^{ev}`-generated even span is *not* the Verma-saturated Newton lattice

## The claim that is dead

> `T^ev_{Q,Λ} = N^ev_Λ` (type `A` / `GL_n`)

i.e. the frozen note's "equivalently the part of `T^{Lus}_Λ` of `Λ/2Λ`-degree zero" at lines 279–281
read together with the `GL₂` substitution at lines 288–316, which silently replaces the
`Q^{ev}`-generated span by the Newton lattice `N^{ev}_{A_z}`.

## The witness

One toral coordinate. `Φ₁(X) = (X − 1)/(Q − 1)`, `Q = q²`.

| | value | in `Z[q^{±1}]`? |
|---|---|---|
| `Φ₁` on the Q-grid, `X = Q^m`, every `m ∈ Z` | `(Q^m − 1)/(Q − 1)` | **yes** → `Φ₁ ∈ N^ev_Λ` |
| every `Q^{ev}(n)` on the **full** q-grid, `X = q^m` | Gaussian binomials | **yes**, `n ≤ 6`, `|m| ≤ 6`, no exceptions |
| `Φ₁` on the full q-grid at `X = q` | `1/(q + 1)` | **no** |

`A_z` acts through `z`-monomials, which `ev` does not touch, so full-q-grid integrality passes from
the generators to the whole span. `Φ₁` is therefore in `N^ev_Λ` and not in `T^ev_{Q,Λ}`.

$$\mathcal T^{ev}_{Q,\Lambda}\subsetneq\mathcal N^{ev}_\Lambda .$$

**And the witness is the source's own generator:** `ν_{a,1}(Y_a) = (Y_a − 1)/(Q − 1) = Φ₁`, from the
`GL₂` Newton form the same document displays at lines 305–309.

## Why — the mechanism, stated so it is reusable

The two families are integral on **different grids**. The Gaussian generators `Q^{ev}(n)` are
integral on the finer full `q`-grid; the Newton generators `ν_r` are integral only on the coarser
`Q`-grid — the oracle confirms `ν_1(q³) = (q² + q + 1)/(q + 1)` and `ν_2(q)` non-Laurent. Integrality
on a finer grid is a strictly stronger condition, so the Gaussian span is strictly smaller. **No
renormalization of generators can repair this**, which is what makes it a refutation and not a
convention mismatch. The degree-one transition, exactly:

`Q^{ev}(1) = (q + 1)·Φ₁`, and `K_+[K_+;0/1] = q·Φ₁`, so `Q^{ev}(1) = ((q+1)/q)·K_+[K_+;0/1]`.

`q` is a unit, `q + 1` is not.

## What survives

- `T^ev_{Q,Λ} ⊊ (T^{Lus}_Λ)_0 ⊆ N^ev_Λ` — the safe chain. The **last inclusion is verified in rank
  one only** (see `erratum-2026-07-02-even-toral-three-objects`).
- Rank one: `(T^{Lus})_0 = span_{A_z}{X^m ν_t}`, from the exact identity
  `K^ε[K;0/t] = q^{t²}X^{(ε−t)/2}ν_t(X)` for `ε ≡ t (mod 2)`. **This does not transfer to rank ≥ 2.**
- `even-newton-gaussian-grid-values` is **unaffected**: it states forward grid-integrality, which is
  true and is not the equality refuted here.

## Search aliases

`N^ev = T^ev` · `N-even-equals-T-even` · `N even equals T even` · Newton Gaussian equivalence ·
Newton/Gaussian equivalence · even toral lattice equivalence · Gaussian span equals Newton lattice ·
`Q^ev` span versus Newton lattice · even_hybrid_center_definition_conjecture_2026-07-02 ·
July even-toral source · `309b397297146d1773d5c6bce346ccb89dec0447199218cc8e9e325f4932bad5` ·
saturation enlargement · degree-zero Lusztig lattice versus Newton lattice (**that one is NOT
refuted — see the traps**).
