import Sandbox.A1.CenterPoly

set_option linter.style.header false

/-!
# A1 CENTER — finite support of the polynomial DCK rows (`prop:v99-finite-support`)

The polynomial mirror of the Y-function DCK word (`A1/CenterYFun.lean`): `dckWordP`
alternates the exact residues of `A1/CenterPoly.lean` (`d0p` at even step index, `d1p`
at odd; rightmost acts first), and `dckRowP r = C ((-q)^⌊r/2⌋) * τ^{-⌊r/2⌋} (dckWordP r ·)`
(C-scalar spelling of the row).

Main results:

* zero propagation: `d1p_zero`, `d0p_zero`, `dckWordP_zero_of`;
* THE DEGREE BOUND `totalDegree_dckWordP_le`: each surviving residue step strictly eats
  one unit of total degree, `(dckWordP r f).totalDegree + r ≤ f.totalDegree`;
* **`dckWordP_eq_zero_of_degree_lt` / `dckRowP_eq_zero_of_degree_lt`**
  (`prop:v99-finite-support`, polynomial form): rows vanish beyond the total degree;
* sanity anchor `support_e1`: the degree-1 seed `Y₁ + Y₂` dies from row 2 on —
  matching the CAS valid-seed probe (`sandboxv0/scratch/gl2_center_c5_out.md` V2:
  all seeds truncate at their degree).
-/

namespace HybridQuantumLean
namespace A1
namespace Verma
namespace GL2

open MvPolynomial

universe u

/-! ## Zero propagation for the residues (finite side needs no quantum parameter) -/

section ZeroResidueSwap

variable {K : Type u} [Field K]

/-- The finite residue kills `0`. -/
@[simp] theorem d1p_zero : d1p (0 : MvPolynomial (Fin 2) K) = 0 :=
  d1p_of_s1p_eq 0 (map_zero _)

end ZeroResidueSwap

section Support

variable {K : Type u} [Field K] [P : QFieldParams K]

/-- The affine residue kills `0`. -/
@[simp] theorem d0p_zero : d0p (0 : MvPolynomial (Fin 2) K) = 0 :=
  d0p_of_s0p_eq 0 (map_zero _)

/-! ## The polynomial DCK word and rows -/

/-- The polynomial DCK word: alternating exact residues, `d0p` applied at even step
index `r`, `d1p` at odd (rightmost acts first) — mirror of `CenterYFun.dckWord`. -/
noncomputable def dckWordP : ℕ → MvPolynomial (Fin 2) K → MvPolynomial (Fin 2) K
  | 0, f => f
  | (r + 1), f => if r % 2 = 0 then d0p (dckWordP r f) else d1p (dckWordP r f)

@[simp] theorem dckWordP_zero (f : MvPolynomial (Fin 2) K) : dckWordP 0 f = f := rfl

theorem dckWordP_succ (r : ℕ) (f : MvPolynomial (Fin 2) K) :
    dckWordP (r + 1) f
      = if r % 2 = 0 then d0p (dckWordP r f) else d1p (dckWordP r f) := rfl

theorem dckWordP_succ_even (r : ℕ) (f : MvPolynomial (Fin 2) K) (h : r % 2 = 0) :
    dckWordP (r + 1) f = d0p (dckWordP r f) := by
  rw [dckWordP_succ, if_pos h]

theorem dckWordP_succ_odd (r : ℕ) (f : MvPolynomial (Fin 2) K) (h : r % 2 = 1) :
    dckWordP (r + 1) f = d1p (dckWordP r f) := by
  rw [dckWordP_succ, if_neg (by omega)]

/-- The polynomial DCK row `Θ_r`-normalization:
`(-q)^⌊r/2⌋ · τ^{-⌊r/2⌋} (dckWordP r f)` (C-scalar spelling). -/
noncomputable def dckRowP (r : ℕ) (f : MvPolynomial (Fin 2) K) : MvPolynomial (Fin 2) K :=
  C ((-(P.q)) ^ (r / 2)) * taup (-(r / 2 : ℕ) : ℤ) (dckWordP r f)

@[simp] theorem dckRowP_zero (f : MvPolynomial (Fin 2) K) : dckRowP 0 f = f := by
  simp only [dckRowP, dckWordP_zero, Nat.zero_div, pow_zero, map_one, one_mul,
    Nat.cast_zero, neg_zero, taup_zero]

/-- Zero propagation: once the DCK word dies it stays dead. -/
theorem dckWordP_zero_of {f : MvPolynomial (Fin 2) K} {r : ℕ} (h : dckWordP r f = 0) :
    ∀ s, r ≤ s → dckWordP s f = 0 := by
  intro s hs
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hs
  clear hs
  induction k with
  | zero => exact h
  | succ n ih =>
    rw [show r + (n + 1) = (r + n) + 1 from rfl, dckWordP_succ, ih]
    split
    · exact d0p_zero
    · exact d1p_zero

/-! ## The degree bound (the induction) -/

/-- THE DEGREE BOUND: every surviving DCK step strictly eats one unit of total degree.
Each residue step either kills the word or drops `totalDegree` by at least one
(`totalDegree_d0p_lt` / `totalDegree_d1p_lt`). -/
theorem totalDegree_dckWordP_le (r : ℕ) (f : MvPolynomial (Fin 2) K)
    (h : dckWordP r f ≠ 0) :
    (dckWordP r f).totalDegree + r ≤ f.totalDegree := by
  induction r with
  | zero => rw [dckWordP_zero]; omega
  | succ n ih =>
    have hn : dckWordP n f ≠ 0 := by
      intro h0
      exact h (dckWordP_zero_of h0 (n + 1) (Nat.le_succ n))
    have hih := ih hn
    rw [dckWordP_succ] at h ⊢
    by_cases hp : n % 2 = 0
    · rw [if_pos hp] at h ⊢
      have hsub : dckWordP n f - s0p (dckWordP n f) ≠ 0 := by
        intro h0
        exact h (d0p_of_s0p_eq _ ((sub_eq_zero.mp h0).symm))
      have hlt := totalDegree_d0p_lt hsub
      omega
    · rw [if_neg hp] at h ⊢
      have hsub : dckWordP n f - s1p (dckWordP n f) ≠ 0 := by
        intro h0
        exact h (d1p_of_s1p_eq _ ((sub_eq_zero.mp h0).symm))
      have hlt := totalDegree_d1p_lt hsub
      omega

/-! ## THE FINITE-SUPPORT THEOREM (`prop:v99-finite-support`, polynomial form) -/

/-- FINITE SUPPORT, word form: the DCK word vanishes past the total degree. -/
theorem dckWordP_eq_zero_of_degree_lt (f : MvPolynomial (Fin 2) K) {r : ℕ}
    (h : f.totalDegree < r) : dckWordP r f = 0 := by
  by_contra h0
  have hle := totalDegree_dckWordP_le r f h0
  omega

/-- FINITE SUPPORT, row form (`prop:v99-finite-support`): the DCK rows vanish past
the total degree of the seed. -/
theorem dckRowP_eq_zero_of_degree_lt (f : MvPolynomial (Fin 2) K) {r : ℕ}
    (h : f.totalDegree < r) : dckRowP r f = 0 := by
  simp only [dckRowP, dckWordP_eq_zero_of_degree_lt f h, map_zero, mul_zero]

/-! ## Concrete instance (CAS-pinned by the valid-seed probe) -/

/-- The degree-1 seed `Y₁ + Y₂` supports only rows 0 and 1. -/
theorem support_e1 : ∀ r, 2 ≤ r → dckRowP (K := K) r (X 0 + X 1) = 0 := by
  intro r hr
  have hd : (X 0 + X 1 : MvPolynomial (Fin 2) K).totalDegree ≤ 1 :=
    (totalDegree_add _ _).trans
      (max_le (le_of_eq (totalDegree_X 0)) (le_of_eq (totalDegree_X 1)))
  exact dckRowP_eq_zero_of_degree_lt _ (by omega)

end Support

end GL2
end Verma
end A1
end HybridQuantumLean
