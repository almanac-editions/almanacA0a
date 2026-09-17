import Sandbox.A1.CenterIntegralRows
import Mathlib.Algebra.Polynomial.EraseLead

set_option linter.style.header false
set_option linter.unusedSectionVars false

/-!
# A1 CENTER — the ℤ-indexed Newton grid value membership (W-R1b scalar layer)

Binding statement of record: `sandboxv1/rescue/GOALv1R.lock.json`
(`goal_id = gl2_center_closed_newton`).  Binding blueprint:
`sandboxv1/informal/GL2_CENTER_HUMAN_PROOF.tex` §"Newton interpolation criterion".
CAS pin: `sandboxv1/informal/gl2_newton_check.py` (54/54, run 2026-07-08), which screens
`ν_r(Q^m) ∈ A_z` and the reflection identity below on the window `r ∈ [0,4]`, `m ∈ [-4,5]`.

## What this file is

The `A1/CenterLattice` substrate proves the Newton-basis grid value membership
`ν_r(Q^L) ∈ A_z` only for a **natural** grid index `L : ℕ` (`nuNewton_grid_mem`, via the
Gaussian binomial `qBinom_isIntegral`).  The two-variable Newton-span faithfulness of
`A1/UQ/NewtonSpan` needs the same membership for **every integer** grid index `m : ℤ`
(the grid predicate `nuNewtonIntegral` quantifies over all `m,n : ℤ`, including the negative
grid).  This file lands exactly that gap, `nuNewton_zpow_grid_mem`.

**The reflection identity** (CAS-pinned; the negative grid is reduced to a nat top without
re-deriving the ℤ-Gaussian binomial integrality).  Writing `Q = q²` and
`ν_r(Q^a) = ∏_{s<r}(Q^a − Q^s)/(Q^r − Q^s)` for `a : ℤ`, the reflection `s ↦ r−1−s` gives,
factorwise, `Q^a − Q^s = −Q^{a+s+1−r}·(Q^{r−1−a} − Q^{r−1−s})`, hence

  `ν_r(Q^m) = (∏_{s<r} −Q^{m+s+1−r}) · ν_r(Q^{r−1−m})`.

The prefactor is a product of `A_z` units (integer powers of `Q`, negated), and for `m < 0`
the reflected top `r−1−m ≥ r ≥ 0` is a **natural** index, so the substrate `nuNewton_grid_mem`
applies.  For `m ≥ 0` the membership is the substrate lemma directly.

This is the "direct product-of-`Qgeom`-style argument" alternative from
`rescue/WR1_REPORT.md` §"Proposed plan for item 5", step 1: no ℤ-extension of
`qBinom_isIntegral` is needed.
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace Verma
namespace GL2

open QFieldParams

universe u

variable {K : Type u} [Field K] [G : GL2Params K]

/-! ## The numerator reflection identity (pure `zpow` core) -/

/-- **Numerator reflection.**  For `Q = q²` and any `m : ℤ`,
`∏_{s<r}(Q^m − Q^s) = (∏_{s<r} −Q^{m+s+1−r}) · ∏_{s<r}(Q^{r−1−m} − Q^s)`.
The reflection `s ↦ r−1−s` pairs the two products factorwise via
`Q^m − Q^s = −Q^{m+s+1−r}(Q^{r−1−m} − Q^{r−1−s})`. -/
theorem prod_zpow_sub_reflect [QGeneric K] (r : ℕ) (m : ℤ) :
    (∏ s ∈ Finset.range r,
        ((G.q ^ 2 : K) ^ m - (G.q ^ 2 : K) ^ (s : ℤ)))
      = (∏ s ∈ Finset.range r, -((G.q ^ 2 : K) ^ (m + (s : ℤ) + 1 - (r : ℤ))))
        * ∏ s ∈ Finset.range r,
            ((G.q ^ 2 : K) ^ ((r : ℤ) - 1 - m) - (G.q ^ 2 : K) ^ (s : ℤ)) := by
  have hQ : (G.q ^ 2 : K) ≠ 0 := pow_ne_zero 2 G.q_ne_zero
  rw [← Finset.prod_range_reflect
        (fun s => (G.q ^ 2 : K) ^ ((r : ℤ) - 1 - m) - (G.q ^ 2 : K) ^ (s : ℤ)) r,
      ← Finset.prod_mul_distrib]
  refine Finset.prod_congr rfl (fun s hs => ?_)
  have hsr : s < r := Finset.mem_range.mp hs
  have hcast : ((r - 1 - s : ℕ) : ℤ) = (r : ℤ) - 1 - (s : ℤ) := by omega
  rw [hcast]
  have h1 : -((G.q ^ 2 : K) ^ (m + (s : ℤ) + 1 - (r : ℤ)))
        * (G.q ^ 2 : K) ^ ((r : ℤ) - 1 - m)
      = -((G.q ^ 2 : K) ^ (s : ℤ)) := by
    rw [neg_mul, ← zpow_add₀ hQ,
      show m + (s : ℤ) + 1 - (r : ℤ) + ((r : ℤ) - 1 - m) = (s : ℤ) by ring]
  have h2 : (G.q ^ 2 : K) ^ (m + (s : ℤ) + 1 - (r : ℤ))
        * (G.q ^ 2 : K) ^ ((r : ℤ) - 1 - (s : ℤ))
      = (G.q ^ 2 : K) ^ m := by
    rw [← zpow_add₀ hQ,
      show m + (s : ℤ) + 1 - (r : ℤ) + ((r : ℤ) - 1 - (s : ℤ)) = m by ring]
  rw [mul_sub, h1, neg_mul, h2]
  ring

/-! ## The ℤ-indexed grid value reflection and its `A_z` membership -/

/-- **The Newton-basis reflection at an integer grid index.**  For `Q = q²` and `m : ℤ`,
`ν_r(Q^m) = (∏_{s<r} −Q^{m+s+1−r}) · ν_r(Q^{r−1−m})`.  Follows from the numerator
reflection `prod_zpow_sub_reflect` after splitting the common denominator product. -/
theorem nuNewton_zpow_reflect [QGeneric K] (r : ℕ) (m : ℤ) :
    nuNewton (K := K) r ((G.q ^ 2 : K) ^ m)
      = (∏ s ∈ Finset.range r, -((G.q ^ 2 : K) ^ (m + (s : ℤ) + 1 - (r : ℤ))))
        * nuNewton (K := K) r ((G.q ^ 2 : K) ^ ((r : ℤ) - 1 - m)) := by
  unfold nuNewton
  rw [Finset.prod_div_distrib, Finset.prod_div_distrib]
  -- normalise the `(q²)^s`, `(q²)^r` nat powers appearing in the numerator products to `zpow`
  have hnum : ∀ (a : ℤ), (∏ s ∈ Finset.range r, ((G.q ^ 2 : K) ^ a - (G.q ^ 2) ^ s))
      = ∏ s ∈ Finset.range r, ((G.q ^ 2 : K) ^ a - (G.q ^ 2 : K) ^ (s : ℤ)) := by
    intro a
    exact Finset.prod_congr rfl (fun s _ => by rw [zpow_natCast])
  rw [hnum m, hnum ((r : ℤ) - 1 - m), prod_zpow_sub_reflect r m, mul_div_assoc]

/-- **The ℤ-indexed Newton grid value membership** (W-R1b step 1): `ν_r(Q^m) ∈ A_z` for
`Q = q²` and **every** integer `m`.  For `m ≥ 0` this is the substrate `nuNewton_grid_mem`;
for `m < 0` the reflection `nuNewton_zpow_reflect` reduces the top to the natural index
`r − 1 − m ≥ 0` and multiplies by the `A_z`-unit prefactor. -/
theorem nuNewton_zpow_grid_mem [QGeneric K] (r : ℕ) (m : ℤ) :
    nuNewton (K := K) r ((G.q ^ 2 : K) ^ m) ∈ AzSubring (K := K) := by
  rcases le_or_gt 0 m with hm | hm
  · obtain ⟨L, rfl⟩ : ∃ L : ℕ, m = (L : ℤ) := ⟨m.toNat, (Int.toNat_of_nonneg hm).symm⟩
    rw [zpow_natCast]
    exact nuNewton_grid_mem r L
  · rw [nuNewton_zpow_reflect]
    refine mul_mem (Subring.prod_mem _ fun s _ => neg_mem (Q_zpow_mem (K := K) _)) ?_
    obtain ⟨N, hN⟩ : ∃ N : ℕ, (r : ℤ) - 1 - m = (N : ℤ) :=
      ⟨((r : ℤ) - 1 - m).toNat, (Int.toNat_of_nonneg (by omega)).symm⟩
    rw [hN, zpow_natCast]
    exact nuNewton_grid_mem r N

/-! ## The univariate `Polynomial K` Newton generator and its triangular basis

These feed the `⟹` direction of `A1/UQ/NewtonSpan`: the `MvPolynomial` Newton generators
`nuPoly1`, `nuPoly2` are the images of `newtonPolyK` under `aeval (X 0)` / `aeval (X 1)`, and the
triangular basis `X_pow_mem_span_newtonPolyK` transports to `X0^i ∈ span_K{nuPoly1 r : r ≤ i}`.
-/

section TriangularBasis

open Polynomial

/-- Univariate (`Polynomial K`) Newton generator with linear coefficient `a`:
`∏_{t<r} (C a · X − C (Q^t)) · C ((Q^r − Q^t)⁻¹)`, `Q = q²`. -/
noncomputable def newtonPolyK (a : K) (r : ℕ) : Polynomial K :=
  ∏ t ∈ Finset.range r,
    (Polynomial.C a * Polynomial.X - Polynomial.C ((G.q ^ 2) ^ t))
      * Polynomial.C (((G.q ^ 2) ^ r - (G.q ^ 2) ^ t)⁻¹)

/-- A single Newton factor `(C a·X − C b)·C c` in linear normal form. -/
private theorem factor_linear (a b c : K) :
    (C a * X - C b) * C c = C (a * c) * X + C (-(b * c)) := by
  simp only [C_mul, C_neg]; ring

/-- Each Newton factor `(C a·X − C b)·C c` has `natDegree = 1` when `a·c ≠ 0`. -/
private theorem factor_natDegree (a b c : K) (hac : a * c ≠ 0) :
    ((C a * X - C b) * C c).natDegree = 1 := by
  rw [factor_linear]; exact natDegree_linear hac

/-- Each Newton factor `(C a·X − C b)·C c` has `leadingCoeff = a·c` when `a·c ≠ 0`. -/
private theorem factor_leadingCoeff (a b c : K) (hac : a * c ≠ 0) :
    ((C a * X - C b) * C c).leadingCoeff = a * c := by
  rw [factor_linear]; exact leadingCoeff_linear hac

/-- Each Newton factor `(C a·X − C b)·C c` is nonzero when `a·c ≠ 0`. -/
private theorem factor_ne_zero (a b c : K) (hac : a * c ≠ 0) :
    (C a * X - C b) * C c ≠ 0 := by
  rw [← leadingCoeff_ne_zero, factor_leadingCoeff a b c hac]; exact hac

/-- `newtonPolyK a r` has `natDegree = r`: it is a product of `r` linear factors. -/
private theorem newtonPolyK_natDegree [QGeneric K] (a : K) (ha : a ≠ 0) (r : ℕ) :
    (newtonPolyK (G := G) a r).natDegree = r := by
  have hfac : ∀ t ∈ Finset.range r,
      (C a * X - C ((G.q ^ 2) ^ t)) * C (((G.q ^ 2) ^ r - (G.q ^ 2) ^ t)⁻¹) ≠ 0 := fun t ht =>
    factor_ne_zero a _ _
      (mul_ne_zero ha (inv_ne_zero (hq_Q_pow_sub_ne_zero (Finset.mem_range.mp ht))))
  have hsum : ∑ t ∈ Finset.range r,
      ((C a * X - C ((G.q ^ 2) ^ t)) * C (((G.q ^ 2) ^ r - (G.q ^ 2) ^ t)⁻¹)).natDegree
      = ∑ _t ∈ Finset.range r, 1 := by
    refine Finset.sum_congr rfl fun t ht => ?_
    exact factor_natDegree a _ _
      (mul_ne_zero ha (inv_ne_zero (hq_Q_pow_sub_ne_zero (Finset.mem_range.mp ht))))
  rw [newtonPolyK, natDegree_prod _ _ hfac, hsum]
  simp

/-- The leading coefficient of `newtonPolyK a r` is nonzero (product of nonzero leadings). -/
private theorem newtonPolyK_leadingCoeff_ne_zero [QGeneric K] (a : K) (ha : a ≠ 0) (r : ℕ) :
    (newtonPolyK (G := G) a r).leadingCoeff ≠ 0 := by
  rw [newtonPolyK, leadingCoeff_prod, Finset.prod_ne_zero_iff]
  intro t ht
  rw [factor_leadingCoeff a _ _
    (mul_ne_zero ha (inv_ne_zero (hq_Q_pow_sub_ne_zero (Finset.mem_range.mp ht))))]
  exact mul_ne_zero ha (inv_ne_zero (hq_Q_pow_sub_ne_zero (Finset.mem_range.mp ht)))

/-- **Triangular basis**: for `a ≠ 0`, `X^i` lies in the `K`-span of `{newtonPolyK a r : r ≤ i}`.
Each `newtonPolyK a r` has `natDegree = r` and a nonzero leading coefficient, so the family is
unitriangular against the monomial basis; strong induction on `i` peels the top monomial with
`eraseLead`. -/
theorem X_pow_mem_span_newtonPolyK [QGeneric K] (a : K) (ha : a ≠ 0) (i : ℕ) :
    (Polynomial.X : Polynomial K) ^ i
      ∈ Submodule.span K ((fun r => newtonPolyK (G := G) a r) '' ↑(Finset.range (i + 1))) := by
  induction i using Nat.strong_induction_on with
  | _ i IH =>
    rcases Nat.eq_zero_or_pos i with hi | hi
    · subst hi
      have h0 : newtonPolyK (G := G) a 0 = 1 := by simp [newtonPolyK]
      have hmem : (1 : Polynomial K) ∈
          (fun r => newtonPolyK (G := G) a r) '' ↑(Finset.range (0 + 1)) :=
        ⟨0, by simp, by simpa using h0⟩
      simpa using Submodule.subset_span hmem
    · set p := newtonPolyK (G := G) a i with hp
      have hp_deg : p.natDegree = i := by rw [hp]; exact newtonPolyK_natDegree a ha i
      have hc : p.leadingCoeff ≠ 0 := by rw [hp]; exact newtonPolyK_leadingCoeff_ne_zero a ha i
      have hp_mem : p ∈ (fun r => newtonPolyK (G := G) a r) '' ↑(Finset.range (i + 1)) :=
        ⟨i, by simp, hp.symm⟩
      have key : p.eraseLead + C p.leadingCoeff * X ^ i = p := by
        have h := eraseLead_add_C_mul_X_pow p
        rw [hp_deg] at h; exact h
      have hcc : C p.leadingCoeff⁻¹ * C p.leadingCoeff = 1 := by
        rw [← C_mul, inv_mul_cancel₀ hc, C_1]
      have hstep : C p.leadingCoeff * X ^ i = p - p.eraseLead := eq_sub_of_add_eq' key
      have hXi : (X : Polynomial K) ^ i
          = C p.leadingCoeff⁻¹ * p - C p.leadingCoeff⁻¹ * p.eraseLead := by
        calc (X : Polynomial K) ^ i
            = (C p.leadingCoeff⁻¹ * C p.leadingCoeff) * X ^ i := by rw [hcc, one_mul]
          _ = C p.leadingCoeff⁻¹ * (C p.leadingCoeff * X ^ i) := by ring
          _ = C p.leadingCoeff⁻¹ * (p - p.eraseLead) := by rw [hstep]
          _ = C p.leadingCoeff⁻¹ * p - C p.leadingCoeff⁻¹ * p.eraseLead := by ring
      rw [hXi]
      refine Submodule.sub_mem _ ?_ ?_
      · rw [← smul_eq_C_mul]
        exact Submodule.smul_mem _ _ (Submodule.subset_span hp_mem)
      · have herase_deg : p.eraseLead.natDegree < i := by
          have hle := eraseLead_natDegree_le p
          rw [hp_deg] at hle; omega
        have herase : p.eraseLead
            = ∑ j ∈ Finset.range i, C (p.eraseLead.coeff j) * X ^ j :=
          as_sum_range_C_mul_X_pow' p.eraseLead herase_deg
        rw [herase, Finset.mul_sum]
        apply Submodule.sum_mem
        intro j hj
        have hji : j < i := Finset.mem_range.mp hj
        have hXj : (X : Polynomial K) ^ j ∈
            Submodule.span K
              ((fun r => newtonPolyK (G := G) a r) '' ↑(Finset.range (i + 1))) := by
          have hsub : ((fun r => newtonPolyK (G := G) a r) '' ↑(Finset.range (j + 1)))
              ⊆ ((fun r => newtonPolyK (G := G) a r) '' ↑(Finset.range (i + 1))) := by
            apply Set.image_mono
            intro x hx
            simp only [Finset.coe_range, Set.mem_Iio] at hx ⊢
            omega
          exact Submodule.span_mono hsub (IH j hji)
        have hrw : C p.leadingCoeff⁻¹ * (C (p.eraseLead.coeff j) * X ^ j)
            = (p.leadingCoeff⁻¹ * p.eraseLead.coeff j) • X ^ j := by
          rw [smul_eq_C_mul, C_mul, mul_assoc]
        rw [hrw]
        exact Submodule.smul_mem _ _ hXj

end TriangularBasis

end GL2
end Verma
end A1
end HybridQuantumLean
