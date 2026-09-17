---
id: lit-cahen-chabert-vandermonde-coefficient-descent
status: literature-theorem
provenance: cited
provenance_note: "P.-J. Cahen and J.-L. Chabert, *Integer-Valued Polynomials*, AMS Mathematical Surveys and Monographs **48** (1997) — **Proposition I.3.1** with **Remarks I.3.2(i)–(ii)**, printed p. 9, in §I.3 *Trivial cases* (Vandermonde). Book held at `corpus/literature/pdf/Cahen Chabert Integer-valued polynomials.pdf`. **Read at source and verified by the Librarian 2026-08-13**; located on the Editor's `20260813T115302Z`. **Grade: refereed.**"
lens: when-coefficients-in-a-larger-field-descend-and-the-explicit-Vandermonde-denominator-that-makes-the-descent-quantitative
sources: ["corpus/literature/pdf/Cahen Chabert Integer-valued polynomials.pdf — Prop I.3.1, Remarks I.3.2(i)–(ii), Cor I.3.3, printed p.9–10", "Editor 20260813T115302Z — the locus, the §I.3-not-§I.2 correction, and the sharper-than-the-remark point"]
feeds: ["the A0a edition row A0a-09 (coefficient-field rigidity) — per the Editor this was the edition's last `NONE LOCATED`", "lit-gramain-geometric-progression-integer-valued-basis — C–C's Ch II Ex 15 is a SIGNPOST to Gramain, not a rival home", "lit-harman-q-polya-qbinomial-basis — the card carrying the Ex 15 qualification", "**lit-cahen-chabert-ex15-erratum-two-misprints — the Ex 15 statement itself, carded 2026-08-13 with its TWO printed misprints; anything citing `[CC97, Ch II Ex 15]` must go through that card**"]
created: 2026-08-13 (Librarian, on Editor 20260813T115302Z)
conventions_gap: "`D` a domain contained in a field `L`; `K` the fraction field of `D`; `E` an evaluation subset; `Int(E,D)` the integer-valued polynomials, defined **as a subset of `K[X]`**. Classical commutative algebra — **no `q`, no quantum parameter, no lattice in the programme's sense.** The programme's application reads the nodes as powers of `q` and the ambient as `F_t = ℚ(v)[t^{±}]`; that transport is the Editor's, not Cahen–Chabert's."
traps: ["**IT IS IN §I.3 `TRIVIAL CASES` (VANDERMONDE), NOT §I.2 `LOCALIZATION`.** The Editor records having already searched §I.2, which is *adjacent only*. **A search that stops at the localization section misses this**, and §I.2 does contain nearby-looking results (e.g. Theorem I.2.10 on `S^{-1}(f(R))`) that are not this statement.", "**THE PROPOSITION IS SHARPER THAN THE REMARK, AND THE SHARPNESS IS THE POINT.** Remark I.3.2(i) gives the qualitative descent: for `E` an **infinite** subset of `K`, a polynomial with coefficients in a larger field mapping `E` into `D` already has coefficients in `K`. **Proposition I.3.1 is quantitative:** with `n+1` nodes `a_0,…,a_n ∈ D`, `f(a_i) ∈ D`, and `d = ∏_{0≤i<j≤n}(a_j − a_i)` the **Vandermonde determinant**, one gets `df ∈ D[X]` — by Cramer's rule on the interpolation system, so `dλ_i ∈ D` for each coefficient. **The explicit `d` is what the programme needs; the remark alone would not give it.**", "**THE REMARK'S NOVELTY CLAUSE CUTS OUR WAY, AND SHOULD BE QUOTED WITH IT.** Remark I.3.2(ii) says the enlarged ring `Int(E,D,L)` would be worth considering **only when `E` is FINITE** (or `D` finite, hence a field), and records that the book **always assumes `D` infinite**. **Our evaluation set is infinite**, so we are inside the regime where the descent already holds and the enlarged object adds nothing.", "**THE DENOMINATOR IS A PRODUCT OF NODE DIFFERENCES, SO WHAT IT CONTAINS DEPENDS ENTIRELY ON THE NODES.** `d = ∏_{i<j}(a_j − a_i)`. **With nodes taken as powers of `q`, `d` carries no `t`** — which is why nothing lands in a `t`-denominator and the descent lands in `F_t` rather than in a larger field. **That inference is about our nodes, not a claim of Cahen–Chabert's**, and any change of node set changes what `d` can contain.", "**C–C IS A SIGNPOST TO GRAMAIN ON THE MULTIPLICATIVE GRID, NOT A BETTER HOME.** Per the Editor's independent check: the book treats the geometric progression in **exactly one place, Ch II Ex 15**, states it **without proof**, and attributes it to Gramain's Prop 2.2 (bibliography entry [143], p. 315) — and **Gramain is cited once in the entire book**. So for `def:nev` the source of record is Gramain; C–C points there."]
---

# Cahen–Chabert Prop I.3.1 — Vandermonde descent of coefficients

Located by the Editor (`20260813T115302Z`) and verified at source. Per their report this resolves the
A0a edition's **last "NONE LOCATED"** row (coefficient-field rigidity).

## The statement

> **Proposition I.3.1** (p. 9). Let `D` be a domain contained in a field `L`, and let `f` be a
> polynomial of degree `n` with coefficients in `L`. If `a_0, …, a_n` are `n+1` elements of `D` with
> `f(a_i) ∈ D` for `0 ≤ i ≤ n`, and if `d = ∏_{0≤i<j≤n}(a_j − a_i)`, then **`df ∈ D[X]`.**
>
> *Proof:* the interpolation conditions form a linear system over `L` whose determinant is the
> **Vandermonde** `d`; Cramer's rule gives `dλ_i ∈ D` for each coefficient `λ_i`.

> **Remark I.3.2(i).** Consequently, if `E` is an **infinite** subset of `K`, a polynomial with
> coefficients in a larger field which maps `E` into `D` is in fact a polynomial with coefficients
> in `K` — so there is no loss of generality in defining `Int(E,D)` inside `K[X]`.
>
> **Remark I.3.2(ii).** If `E` were **finite** it would make sense to consider polynomials with
> coefficients in a larger field `L` mapping `E` into `D`, and one would write `Int(E,D,L)`. **The
> book always assumes `D` infinite.**

## Why the proposition and not the remark

The remark gives descent; **the proposition gives the denominator.** Coefficients land in
`(1/d)·D` with `d` an explicit product of node differences — and with nodes taken as powers of `q`,
`d` carries no `t`, so nothing lands in a `t`-denominator. **That is the non-field landing the
remark alone would not supply.**

## And on the multiplicative grid, C–C defers

The book treats the geometric progression in exactly one place — **Ch II Ex 15** — **without proof**,
attributing it to Gramain's Prop 2.2. Gramain is cited **once in the whole book**. See
`lit-gramain-geometric-progression-integer-valued-basis`.

## Search keywords

Cahen–Chabert · AMS Surveys 48 · Proposition I.3.1 p.9 · §I.3 Trivial cases Vandermonde ·
`d = ∏_{i<j}(a_j − a_i)` · Cramer's rule coefficient descent · Remarks I.3.2(i)–(ii) ·
`Int(E,D,L)` only for finite `E` · `D` infinite throughout · Ch II Ex 15 signposts Gramain
