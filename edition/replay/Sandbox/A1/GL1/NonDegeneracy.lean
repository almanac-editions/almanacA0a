import Sandbox.A1.GL1.NewtonUnivSpan
import Sandbox.A1.GL1.FamilyField1

set_option linter.style.header false
set_option linter.unusedSectionVars false

/-!
# `A1.GL1Newton.NonDegeneracy` — clause (iii) is **not** vacuous (`goal_memory` trap 4)

Binding statement of record: `sandboxv0a/informal/goalv0a.lock.json`
(tex `91a50173…5a7e`, `sandboxv0a/informal/goalv0a.tex`).

## Why this file exists

`goalv0a` clause (iii) says

  `𝒩^ev = Σ_{u ∈ ℤ} Σ_{r ≥ 0} A_z · Y̌^u ν_r(Y̌)`,

and that equality is proved, `sorry`-free, as `Nev_eq_span` / `Newton_iff_mem_span`
(`NewtonUnivSpan.lean`).  **On its own that proof carries no mathematical content**, because an
equality of two sets says nothing until you know the sets are not one of the two trivial ones.
`𝒩^ev` sits between a floor and a ceiling,

  `A_z[Y̌^{±1}]  ⊆  𝒩^ev  ⊆  K₁[Y̌^{±1}] = Frame K₁`,

and clause (iii) is vacuous if **either** inclusion is an equality:

* **Degenerate from below.**  If `𝒩^ev = A_z[Y̌^{±1}]`, the divided classes `ν_r` are redundant —
  `ν_r ∈ A_z[Y̌^{±1}]` for every `r`, the right-hand side collapses to `A_z[Y̌^{±1}]`, and clause
  (iii) is a tautology about a ring nobody needed `ν` to describe.
* **Degenerate from above.**  If `𝒩^ev = Frame K₁`, clause (iii) reads "the `ν`-span is
  everything" — an equality between two names for the ambient algebra, true of any generating set
  whatever, and again no statement about a lattice.

In **both** degenerate worlds `Nev_eq_span` is still true, so every existing check in the sandbox
still goes green.  The whole sandbox would be worthless and nothing in the tree would say so.

This file supplies the missing guarantee, and it guards **both** directions.  It exhibits two
explicit witnesses and concludes that both inclusions are **strict**:

  `A_z[Y̌^{±1}]  ⊊  𝒩^ev = Σ_u Σ_r A_z Y̌^u ν_r(Y̌)  ⊊  Frame K₁`.

So the `ν`-generators of clause (iii) are genuinely required (floor), and what they generate is a
genuine integrality condition rather than the whole algebra (ceiling).

`NewtonUnivGrid.lean` already names both sides of the lower gap — `Laurent` (coefficientwise
integrality, i.e. membership in `A_z[Y̌^{±1}]`) and `Newton` (grid integrality, i.e. `𝒩^ev`) —
precisely so that this file can state the strictness.  Its docstring flags the trap:
"a *check* that finds them equal has a bug".

## One non-unit fact, used in two slots

Both guards are powered by the same arithmetic input: **`q² − 1` is not a unit of
`A_z = ℤ[q^{±1}, z^{±1}]`** (`FamilyField1.Qsub_one_inv_not_mem`, proved in §3 below).  It is
proved once, through the faithfulness witness `FamilyField1.ι_range_eq_azSubring` — membership in
`A_z ⊆ K₁` is membership in the image of the free Laurent model `𝓜₁ = ℤ[q^±, z^±]`, where the
specialisation `φ : 𝓜₁ → ℤ`, `q ↦ 1`, `z ↦ 1`, sends `q² − 1 ↦ 0`, so no inverse can exist.  The
same escaping scalar `(Q − 1)⁻¹ = (q² − 1)⁻¹` then does both jobs, once as a **coefficient** and
once as a **grid value**:

* **Lower separator (§4):** `ν_1(Y̌) = (Y̌ − 1)/(Q − 1)`, `Q = q²`.
  *In `𝒩^ev`* — its grid values are the geometric sums `(Q^χ − 1)/(Q − 1) = 1 + ⋯ + Q^{χ−1}`
  for `χ ≥ 0` and `−Q^χ(1 + ⋯ + Q^{−χ−1})` for `χ < 0`; both lie in `A_z`.  This is *not* reproved
  here: it is the certified bilateral grid membership `CenterNewtonZ.nuNewton_zpow_grid_mem`,
  consumed through `Newton_nuGen`.
  *Not in `A_z[Y̌^{±1}]`* — its `Y̌`-**coefficient** is `(Q − 1)⁻¹ ∉ A_z`.
* **Upper separator (§5):** the constant `sepAbove = (Q − 1)⁻¹ ∈ K₁ ⊆ Frame K₁`.
  *Not in `𝒩^ev`* — `ev_χ` fixes constants, so its **grid value** at every `χ` (already at
  `χ = 0`) is `(Q − 1)⁻¹ ∉ A_z`.
  Constants are exactly the right place to look for a non-`Newton` element: for a constant the
  Laurent coefficient and the grid value coincide, so the two integrality predicates that the
  lower guard separates agree there, and failure of `Laurent` *is* failure of `Newton`.

## Where this must live

In the build cone.  A separator proved in a scratch tree is worthless for exactly the reason the
separator itself is needed: nothing then forces it to keep tracking the definitions it separates.
(An earlier scratch version of this argument silently broke under the `Ring → Frame` rename.)

## Status

Complete and `sorry`-free, in **both** directions: `Laurent_ssubset_Newton` /
`Laurent_ssubset_span` (floor, wave 3b) and `Newton_ssubset_univ` / `span_ssubset_univ` /
`nuGenSpan_ne_top` (ceiling, wave 4).  `clause_iii_nondegenerate` and
`clause_iii_nondegenerate_span` state the two-sided sandwich in one place.
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace GL1Newton

open HybridQuantumLean.A1.Verma
open HybridQuantumLean.A1.Verma.GL2
open LaurentPolynomial

universe u

variable {K : Type u} [Field K] [G : GL2Params K]

/-! ## 1. The easy inclusion `A_z[Y̌^{±1}] ⊆ 𝒩^ev`

Coefficient integrality implies grid integrality: `ev_χ` sends `Y̌^u ↦ Q^{uχ} ∈ A_z`, so an
`A_z`-coefficient Laurent polynomial has `A_z` grid values. -/

/-- **`Laurent ⊆ Newton`** — every element of `A_z[Y̌^{±1}]` lies in `𝒩^ev`. -/
theorem Newton_of_Laurent {f : Frame K} (hf : Laurent (G := G) f) : Newton (G := G) f := by
  intro χ
  have hsum : f = ∑ u ∈ f.support, (LaurentPolynomial.C (f u) * T u : Frame K) := by
    conv_lhs => rw [← Finsupp.sum_single f]
    rw [Finsupp.sum]
    exact Finset.sum_congr rfl fun u _ => LaurentPolynomial.single_eq_C_mul_T (f u) u
  rw [Az, hsum, map_sum]
  refine Subring.sum_mem _ fun u _ => ?_
  rw [map_mul, grid_C, grid_T]
  exact mul_mem (hf u) (Az_Qzpow_zpow (G := G) χ u)

/-! ## 2. The coefficient of the separator

`ν_1 = (Y̌ − 1)/(Q − 1)`; its `Y̌`-coefficient is `(Q − 1)⁻¹`. -/

/-- `ν_1(X) = C((Q−1)⁻¹)·X − C((Q−1)⁻¹)` — the linear normal form of the first divided class. -/
theorem nu_one_eq :
    nu (G := G) 1
      = Polynomial.C (((G.q ^ 2 - 1 : K))⁻¹) * Polynomial.X
        - Polynomial.C (((G.q ^ 2 - 1 : K))⁻¹) := by
  show newtonPolyK (G := G) (1 : K) 1 = _
  rw [newtonPolyK]
  simp
  ring

/-- The `Y̌`-coefficient of the separator `ν_1(Y̌) = nuGen 0 1` is `(Q − 1)⁻¹`. -/
theorem coeff_one_nuGen_zero_one :
    (nuGen (G := G) 0 1 : Frame K) 1 = ((G.q ^ 2 - 1 : K))⁻¹ := by
  have hcoef : (Polynomial.toLaurent (nu (G := G) 1) : Frame K) ((1 : ℕ) : ℤ)
      = (nu (G := G) 1).coeff 1 := by
    rw [Polynomial.toLaurent_apply]
    exact Finsupp.mapDomain_apply (fun a b hab => by exact_mod_cast hab) _ 1
  show ((T 0 * Polynomial.toLaurent (nu (G := G) 1) : Frame K)) 1 = _
  rw [T_zero, one_mul, show ((1 : ℤ)) = ((1 : ℕ) : ℤ) by norm_num, hcoef, nu_one_eq]
  simp

/-! ## 3. `(Q − 1)⁻¹ ∉ A_z` over the concrete family field `K₁`

The negative half.  `Az`-membership is transported to the free Laurent model `𝓜₁` by
`FamilyField1.ι_range_eq_azSubring`, and there the specialisation `q ↦ 1, z ↦ 1` kills `q² − 1`. -/

namespace FamilyField1

/-- Inner specialisation `ℤ[q^{±1}] → ℤ`, `q ↦ 1`. -/
noncomputable def spec1 : LaurentPolynomial ℤ →+* ℤ :=
  LaurentPolynomial.eval₂ (RingHom.id ℤ) 1

/-- **The specialisation `φ : 𝓜₁ → ℤ`**, `q ↦ 1`, `z ↦ 1`.  Its only job is to witness that
`q² − 1` is not a unit of `ℤ[q^±, z^±]`: it sends `q² − 1` to `0`. -/
noncomputable def spec : Mdl1 →+* ℤ :=
  (LaurentPolynomial.eval₂ spec1 1 : LaurentPolynomial (LaurentPolynomial ℤ) →+* ℤ)

@[simp] theorem spec_qMdl : spec qMdl = 1 := by
  show (LaurentPolynomial.eval₂ spec1 1 : LaurentPolynomial (LaurentPolynomial ℤ) →+* ℤ)
      (C (T 1)) = 1
  rw [LaurentPolynomial.eval₂_C]
  show (LaurentPolynomial.eval₂ (RingHom.id ℤ) 1 : LaurentPolynomial ℤ →+* ℤ) (T 1) = 1
  rw [LaurentPolynomial.eval₂_T]
  simp

/-- `q² − 1` is not a unit of the model ring `𝓜₁ = ℤ[q^±, z^±]`: specialise `q ↦ 1`. -/
theorem qsq_sub_one_not_unit : ¬ ∃ x : Mdl1, (qMdl ^ 2 - 1) * x = 1 := by
  rintro ⟨x, hx⟩
  have h := congrArg spec hx
  rw [map_mul, map_sub, map_one, map_pow, spec_qMdl] at h
  simp at h

/-- **`(Q − 1)⁻¹ = (q² − 1)⁻¹ ∉ A_z`.**  The negative half of the separator: `A_z` really is
`ℤ[q^{±1}, z^{±1}]` (faithfulness witness `ι_range_eq_azSubring`), and `q² − 1` is not invertible
there. -/
theorem Qsub_one_inv_not_mem :
    ((instGL2ParamsK1.q ^ 2 - 1 : K1))⁻¹ ∉ AzSubring (K := K1) := by
  intro h
  rw [← ι_range_eq_azSubring] at h
  obtain ⟨x, hx⟩ := RingHom.mem_range.mp h
  have hq2 : (instGL2ParamsK1.q ^ 2 : K1) = ι (qMdl ^ 2) := by
    show (qK : K1) ^ 2 = _
    rw [qK, ← map_pow]
  have hne : (instGL2ParamsK1.q ^ 2 - 1 : K1) ≠ 0 := by
    have h2 := qK_natpow_ne_one 2 (by norm_num)
    rw [zpow_natCast] at h2
    exact sub_ne_zero.mpr (by show (qK : K1) ^ 2 ≠ 1; exact h2)
  have hmul : ι ((qMdl ^ 2 - 1) * x) = 1 := by
    rw [map_mul, map_sub, map_one, ← hq2, hx]
    field_simp
  exact qsq_sub_one_not_unit ⟨x, ι_inj (hmul.trans (map_one ι).symm)⟩

end FamilyField1

/-! ## 4. The **lower** guard: the separator and `A_z[Y̌^{±1}] ⊊ 𝒩^ev` (trap 4) -/

open FamilyField1

/-- The separator lies in `𝒩^ev`: certified grid integrality of `ν_r`, consumed via
`Newton_nuGen` (which routes to `CenterNewtonZ.nuNewton_zpow_grid_mem`). -/
theorem Newton_nu_one : Newton (G := instGL2ParamsK1) (nuGen (G := instGL2ParamsK1) 0 1) :=
  Newton_nuGen 0 1

/-- The separator is **not** in `A_z[Y̌^{±1}]`: its `Y̌`-coefficient is `(Q − 1)⁻¹ ∉ A_z`. -/
theorem not_Laurent_nu_one : ¬ Laurent (G := instGL2ParamsK1) (nuGen (G := instGL2ParamsK1) 0 1) := by
  intro h
  have h1 := h 1
  rw [Az, coeff_one_nuGen_zero_one] at h1
  exact Qsub_one_inv_not_mem h1

/-- **Trap 4, the separator.**  `ν_1(Y̌) = (Y̌ − 1)/(Q − 1)` is in `𝒩^ev` but not in
`A_z[Y̌^{±1}]`. -/
theorem trap4_separator :
    Newton (G := instGL2ParamsK1) (nuGen (G := instGL2ParamsK1) 0 1)
      ∧ ¬ Laurent (G := instGL2ParamsK1) (nuGen (G := instGL2ParamsK1) 0 1) :=
  ⟨Newton_nu_one, not_Laurent_nu_one⟩

/-- **The theorem that matters: `𝒩^ev ⊋ A_z[Y̌^{±1}]`.**

`A_z[Y̌^{±1}] ⊆ 𝒩^ev` (`Newton_of_Laurent`) and the inclusion is **strict**, `ν_1` being the
witness.  Hence `goalv0a` clause (iii) is not vacuous: the divided classes `ν_r` are genuinely
needed to describe `𝒩^ev`, and the Newton lattice is a strictly larger object than the plain
monomial ring. -/
theorem Laurent_ssubset_Newton :
    {f : Frame K1 | Laurent (G := instGL2ParamsK1) f}
      ⊂ {f : Frame K1 | Newton (G := instGL2ParamsK1) f} := by
  refine ⟨fun f hf => Newton_of_Laurent hf, ?_⟩
  intro hsub
  exact not_Laurent_nu_one (hsub Newton_nu_one)

/-- Corollary in the shape of clause (iii): the `A_z`-span of `{Y̌^u ν_r(Y̌)}` **strictly**
contains `A_z[Y̌^{±1}]`.  Equivalently, the `ν`-generators are not redundant. -/
theorem Laurent_ssubset_span :
    {f : Frame K1 | Laurent (G := instGL2ParamsK1) f}
      ⊂ (Submodule.span (AzSubring (K := K1)) (nuGenSet (G := instGL2ParamsK1)) : Set (Frame K1)) :=
  Nev_eq_span (K := K1) ▸ Laurent_ssubset_Newton

/-! ## 5. The **upper** guard: `𝒩^ev ⊊ Frame K₁`

The lower guard alone still permits the second degenerate reading: nothing so far rules out
`𝒩^ev = K₁[Y̌^{±1}]`, in which case clause (iii) would assert only that the `ν`-generators span
the ambient algebra — true of any generating set, and not a statement about a lattice.  The
witness is a **constant**, where `Newton` and `Laurent` coincide, so the same non-unit fact
`(Q − 1)⁻¹ ∉ A_z` that powers §4 closes this direction too. -/

/-- **The upper separator** — the constant Laurent polynomial `(Q − 1)⁻¹ = (q² − 1)⁻¹`, an
element of `Frame K₁ = K₁[Y̌^{±1}]` that is *not* grid-integral.  Its whole point is that `ev_χ`
fixes constants (`grid_C`), so its grid value is the escaping scalar itself, at **every** `χ`. -/
noncomputable def sepAbove : Frame K1 :=
  LaurentPolynomial.C (((instGL2ParamsK1.q ^ 2 - 1 : K1))⁻¹)

/-- Every grid value of the upper separator is `(Q − 1)⁻¹`: `ev_χ` fixes constants. -/
@[simp] theorem grid_sepAbove (χ : ℤ) :
    grid (G := instGL2ParamsK1) χ sepAbove = ((instGL2ParamsK1.q ^ 2 - 1 : K1))⁻¹ :=
  grid_C χ _

/-- **The upper separator is not in `𝒩^ev`.**  Already at `χ = 0` its grid value is
`(Q − 1)⁻¹ ∉ A_z` (`FamilyField1.Qsub_one_inv_not_mem`).  Hence `𝒩^ev` is a **proper** condition
on `Frame K₁`: grid integrality genuinely constrains. -/
theorem not_Newton_sepAbove : ¬ Newton (G := instGL2ParamsK1) sepAbove := by
  intro h
  have h0 := h 0
  rw [Az, grid_sepAbove] at h0
  exact Qsub_one_inv_not_mem h0

/-- **The theorem that matters on the other side: `𝒩^ev ⊊ Frame K₁`.**

`𝒩^ev` is not all of `K₁[Y̌^{±1}]`, `sepAbove = (Q − 1)⁻¹` being the witness.  Hence `goalv0a`
clause (iii) is not vacuous *from above*: its right-hand side is a proper `A_z`-lattice inside the
ambient algebra, not a restatement of "these elements generate everything". -/
theorem Newton_ssubset_univ :
    {f : Frame K1 | Newton (G := instGL2ParamsK1) f} ⊂ (Set.univ : Set (Frame K1)) := by
  refine ⟨Set.subset_univ _, fun h => ?_⟩
  exact not_Newton_sepAbove (h (Set.mem_univ _))

/-- Submodule form of the upper guard: the `A_z`-span of `{Y̌^u ν_r(Y̌)}` is **not** the whole
module.  (Via the `⟸` leg `Newton_of_mem_span`: everything in the span is grid-integral, and
`sepAbove` is not.) -/
theorem nuGenSpan_ne_top :
    Submodule.span (AzSubring (K := K1)) (nuGenSet (G := instGL2ParamsK1)) ≠ ⊤ := by
  intro h
  refine not_Newton_sepAbove (Newton_of_mem_span ?_)
  rw [h]
  exact Submodule.mem_top

/-- Corollary in the shape of clause (iii), mirroring `Laurent_ssubset_span`: the `A_z`-span of
`{Y̌^u ν_r(Y̌)}` is **strictly** inside `Frame K₁`. -/
theorem span_ssubset_univ :
    (Submodule.span (AzSubring (K := K1)) (nuGenSet (G := instGL2ParamsK1)) : Set (Frame K1))
      ⊂ (Set.univ : Set (Frame K1)) :=
  Nev_eq_span (K := K1) ▸ Newton_ssubset_univ

/-! ## 6. The two guards together -/

/-- **Clause (iii) is pinned strictly between two bounds.**

  `A_z[Y̌^{±1}]  ⊊  𝒩^ev  ⊊  K₁[Y̌^{±1}]`.

Neither degenerate reading of `goalv0a` clause (iii) survives: the Newton lattice is strictly
larger than the naive monomial ring (so the divided classes `ν_r` are needed) and strictly smaller
than the ambient algebra (so grid integrality is a real condition). -/
theorem clause_iii_nondegenerate :
    {f : Frame K1 | Laurent (G := instGL2ParamsK1) f}
        ⊂ {f : Frame K1 | Newton (G := instGL2ParamsK1) f} ∧
      {f : Frame K1 | Newton (G := instGL2ParamsK1) f} ⊂ (Set.univ : Set (Frame K1)) :=
  ⟨Laurent_ssubset_Newton, Newton_ssubset_univ⟩

/-- The same sandwich written on the right-hand side of clause (iii):

  `A_z[Y̌^{±1}]  ⊊  Σ_{u ∈ ℤ} Σ_{r ≥ 0} A_z · Y̌^u ν_r(Y̌)  ⊊  K₁[Y̌^{±1}]`. -/
theorem clause_iii_nondegenerate_span :
    {f : Frame K1 | Laurent (G := instGL2ParamsK1) f}
        ⊂ (Submodule.span (AzSubring (K := K1)) (nuGenSet (G := instGL2ParamsK1)) :
            Set (Frame K1)) ∧
      (Submodule.span (AzSubring (K := K1)) (nuGenSet (G := instGL2ParamsK1)) : Set (Frame K1))
        ⊂ (Set.univ : Set (Frame K1)) :=
  ⟨Laurent_ssubset_span, span_ssubset_univ⟩

end GL1Newton
end A1
end HybridQuantumLean
