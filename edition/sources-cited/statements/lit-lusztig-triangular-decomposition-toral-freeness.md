---
id: lit-lusztig-triangular-decomposition-toral-freeness
status: literature-theorem
provenance: cited
provenance_note: "G. Lusztig, *Introduction to Quantum Groups*, **Chapter 3, §3.2 `Triangular decomposition for 'U and U`** — Proposition 3.2.4 and Corollary 3.2.5, printed pp. 25–27 (= PDF 40–42). **Read by VISION from the held book**, because the shelf transcript covers §1.4.7, §3.1.9–3.1.13 and §23.2 but **not §3.2 itself**. Written 2026-08-12 on hypervisorv2 `LR-20260811T142024Z`, item `existing-cite:Lusztig`."
lens: the-exact-form-of-Lusztig-triangular-decomposition-and-what-U-zero-is-free-on
sources: ["corpus/literature/pdf/Lusztig Introduction to Quantum Groups.pdf — printed p.25 (Prop 3.2.4), p.26 (3.2 (a),(b) for 'U), p.27 (Corollary 3.2.5)", "corpus/literature/transcribed/lusztig-introduction-to-quantum-groups.md — §1.4.7, §3.1.13 and the section map (§3.2 not transcribed)"]
feeds: ["goalv2 `existing-cite:Lusztig` — the manuscript's Lusztig locus, repaired in the cycle to Ch.40 → 40.2.1(b)+Cor.40.2.2 with 3.2/3.1.13/1.4.7; THIS card is the 3.2 half", "lit-lusztig-adot-integral-form · lit-lusztig-pbw-integrality-provenance-chain — the integral-form siblings"]
created: 2026-08-12 (Librarian, on hypervisorv2 LR-20260811T142024Z)
conventions_gap: "Lusztig's root datum `(Y, X, ⟨,⟩, …)`; `v` is his quantum parameter (the programme writes `q` or `v` depending on the manuscript — fix it before transporting). `f` is the Drinfeld–Jimbo half-algebra, `x ↦ x^±` its two embeddings into `U^±`; `𝒜 = ℤ[v, v^{-1}]`. **`'U` (with the prime) is the FREE version and `U` its quotient by `J_+ + J_−`; they are different algebras and §3.2 treats both.** `Y` is the coweight lattice of the datum."
traps: ["**LUSZTIG STATES IT WITH `f`, NOT WITH `U^-` AND `U^+`.** `LR-20260811T142024Z` asks for `3.2 U^-⊗U^0⊗U^+ ≅ U`. What Corollary 3.2.5 actually says is: **(a)** the `ℚ(v)`-linear map **`f ⊗ U⁰ ⊗ f → U`**, `u ⊗ K_μ ⊗ w ↦ **u^- K_μ w^+**`, is an isomorphism; **(b)** the map `f ⊗ U⁰ ⊗ f → U`, `u ⊗ K_μ ⊗ w ↦ **u^+ K_μ w^-**`, is an isomorphism. The `U^∓` only appear through the maps `x ↦ x^∓`. Writing the source as `U^-⊗U⁰⊗U^+` is a paraphrase, and if a proof needs the tensor factors to *be* `U^±` as algebras it must invoke `f ≅ U^±` separately.", "**THERE ARE TWO ORDERINGS AND THEY ARE BOTH THEOREMS.** (a) is `u^-K_μw^+` (negative first); (b) is `u^+K_μw^-` (positive first). Lusztig notes (b) follows from (a) via the involution `ω`. A manuscript that needs one ordering must cite the right part — they are not interchangeable in a computation.", "**THE `'U` VERSION IS A DIFFERENT STATEMENT ON THE PRECEDING PAGE.** Printed p.26 gives (a),(b) for **`'U`** — `'f ⊗ 'U⁰ ⊗ 'f → 'U` — i.e. for the FREE algebra before quotienting. Corollary 3.2.5 is the `U` version, deduced from it. Citing `§3.2(a)` without saying whether `'U` or `U` is meant is ambiguous, and the section title *`Triangular decomposition for 'U and U`* is precisely a warning that both live there.", "**THE TORAL FREENESS IS A PRESENTATION STATEMENT, AND ITS CONTENT IS THE PARENTHESIS.** Proposition 3.2.4: `U⁰` is the associative `ℚ(v)`-algebra with 1 on generators `K_μ` (`μ ∈ Y`) with relations 3.1.1(a) — *`(This is the group algebra of Y over ℚ(v).)`* **The freeness on `{K_μ}_{μ∈Y}` is exactly that parenthetical identification**, not a separately numbered result. Anyone wanting `U⁰` free with basis `{K_μ}` should cite Prop 3.2.4 *and quote the parenthesis*, because the displayed statement alone is a presentation, not a basis.", "**THIS IS THE `ℚ(v)` STATEMENT, NOT AN INTEGRAL ONE — AND THE BOOK WARNS YOU OFF ITS OWN INTEGRAL FORM HERE.** Everything in §3.2 is over `ℚ(v)`. §3.1.13 defines `_𝒜U` and ends *`This algebra will not be used in the sequel`* — flagged in the shelf transcript as load-bearing for anyone citing `Lusztig's integral form` from this book. **So `3.2` + `3.1.13` do not compose into an integral triangular decomposition.** The `𝒜`-form statement the programme wants is §23.2/Ch.31 territory, and `lit-lusztig-adot-integral-form` is the card for it."]
---

# Lusztig §3.2 — triangular decomposition, and what `U⁰` is free on

Written for goalv2's `existing-cite:Lusztig`. **The shelf transcript does not cover §3.2**, so this
was read by vision from the held book (printed pp. 25–27 = PDF 40–42).

## The toral factor

> **Proposition 3.2.4.** Let `U⁰` be the associative `ℚ(v)`-algebra with 1 defined by the generators
> `K_μ` (`μ ∈ Y`) and the relations 3.1.1(a). ***(This is the group algebra of `Y` over `ℚ(v)`.)***

The parenthesis is the freeness: `U⁰ = ℚ(v)[Y]`, free with basis `{K_μ}_{μ∈Y}`.

## The decomposition

> **Corollary 3.2.5.**
> **(a)** The `ℚ(v)`-linear map `f ⊗ U⁰ ⊗ f → U`, `u ⊗ K_μ ⊗ w ↦ u^- K_μ w^+`, is an isomorphism.
> **(b)** The `ℚ(v)`-linear map `f ⊗ U⁰ ⊗ f → U`, `u ⊗ K_μ ⊗ w ↦ u^+ K_μ w^-`, is an isomorphism.

(b) follows from (a) by the involution `ω`. The proof passes through `U` as the quotient of `'U` by
`J_+ + J_-`, using 3.1.7's containments `('U^+)ℐ^- ⊂ ℐ^-U⁰('U^+)` and `ℐ^+('U^-) ⊂ ('U^-)U⁰ℐ^+`.

**The corresponding `'U` statement** (printed p.26) is `'f ⊗ 'U⁰ ⊗ 'f → 'U` with the same two
orderings — a *different* algebra; see trap 3.

## The companions the request pairs with this

- **§3.1.13** — `_𝒜U`, with the sentence *"This algebra will not be used in the sequel."*
- **§1.4.7** — `_𝒜f`, the `𝒜`-subalgebra generated by the `θ_i^{(s)}`, graded by `ℕ[I]`.

Both are already in the shelf transcript. **They do not upgrade §3.2 to an integral statement**
(trap 5).

## Search keywords

Lusztig Introduction to Quantum Groups · §3.2 triangular decomposition · Proposition 3.2.4 `U⁰`
group algebra of `Y` · Corollary 3.2.5 `f ⊗ U⁰ ⊗ f ≅ U` · `u^-K_μw^+` versus `u^+K_μw^-` ·
`'U` versus `U` · involution `ω` · `_𝒜U` not used in the sequel · toral freeness `K_μ`
