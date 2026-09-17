import Sandbox.A1.QArith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

set_option linter.style.header false

/-!
# A1 CENTER program, stage C3 openers — the toral Newton basis polynomials

Scalar-level substrate (generic `q`, no module content) for the GL₂ even toral lattice
`N^ev = Σ A_z ν_r(Y₁)ν_s(Y₂)` of `notes/even_hybrid_center_definition_conjecture_2026-07-02.tex`
(thm:gl2, v104). GL₂ consumes this layer with `Q = q²` in the shifted HC variables
`Y₁ˢ, Y₂ˢ` of `A1/Center.lean`.

Contents (all identities CAS-verified on the warm Julia REPL before formalization:
`ν_r(Q^k) = ∏_{s<r}(Q^{k−s}−1)/(Q^{r−s}−1)` for `r ≤ k ≤ 8`; `ν_r(Q^k) = 0` for `k < r`;
`ν_r(Q^r) = 1`):

  * `hq_Q_pow_sub_ne_zero` — the genericity bridge `Q^r − Q^s ≠ 0` for `s < r`, via the
    factorization `q^{2r} − q^{2s} = q^{r+s}·(q − q⁻¹)·[r−s]_q` and `qInt_ne_zero`.
  * `nuNewton` — the Newton basis polynomial `ν_r(Y) = ∏_{s<r} (Y − Q^s)/(Q^r − Q^s)`.
  * `nuNewton_zero`, `nuNewton_eval_self`, `nuNewton_eval_zero_of_lt` — the interpolation
    triangle: `ν_0 = 1`, `ν_r(Q^r) = 1`, `ν_r(Q^k) = 0` for `k < r`.
  * `nuNewton_eval_gaussian` — the Gaussian product form of `ν_r(Q^k)` for `r ≤ k`.
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace Verma
namespace GL2

open QFieldParams

universe u
variable {K : Type u} [Field K] [P : QFieldParams K]

/-! ## The genericity bridge: separation of the `Q`-powers, `Q = q²` -/

/-- `Q^r − Q^s ≠ 0` for `s < r` (with `Q = q²`), from genericity: the factorization
`q^{2r} − q^{2s} = q^{r+s}·(q − q⁻¹)·[r−s]_q` has all three factors nonzero. -/
theorem hq_Q_pow_sub_ne_zero [QGeneric K] {r s : ℕ} (h : s < r) :
    (P.q ^ 2) ^ r - (P.q ^ 2) ^ s ≠ 0 := by
  obtain ⟨t, rfl⟩ : ∃ t, r = s + t + 1 := ⟨r - s - 1, by omega⟩
  have hq : P.q ≠ 0 := P.q_ne_zero
  have hd : P.q - P.q⁻¹ ≠ 0 := q_sub_qinv_ne_zero (K := K)
  have hq2 : P.q ^ 2 - 1 ≠ 0 :=
    fun hcon => P.q_sq_ne_one (by rw [← sq]; exact sub_eq_zero.mp hcon)
  have hqi : qInt (K := K) (((s + t + 1 : ℕ) : ℤ) - (s : ℤ)) ≠ 0 :=
    qInt_ne_zero (by omega)
  have key : (P.q ^ 2) ^ (s + t + 1) - (P.q ^ 2) ^ s
      = P.q ^ (s + t + 1 + s)
        * ((P.q - P.q⁻¹) * qInt (K := K) (((s + t + 1 : ℕ) : ℤ) - (s : ℤ))) := by
    have harg : ((s + t + 1 : ℕ) : ℤ) - (s : ℤ) = ((t + 1 : ℕ) : ℤ) := by push_cast; ring
    rw [harg]
    simp only [qInt, zpow_neg, zpow_natCast]
    field_simp
    ring
  rw [key]
  exact mul_ne_zero (pow_ne_zero _ hq) (mul_ne_zero hd hqi)

/-! ## The Newton basis polynomials -/

/-- The Newton basis polynomial `ν_r(Y) = ∏_{s<r} (Y − Q^s)/(Q^r − Q^s)`, `Q = q²`
(canonical GL₂ Newton form of the even toral lattice). -/
noncomputable def nuNewton (r : ℕ) (Y : K) : K :=
  ∏ s ∈ Finset.range r, (Y - (P.q ^ 2) ^ s) / ((P.q ^ 2) ^ r - (P.q ^ 2) ^ s)

/-- `ν_0 = 1` (empty product). -/
theorem nuNewton_zero (Y : K) : nuNewton (K := K) 0 Y = 1 := by
  simp [nuNewton]

/-- `ν_r(Q^r) = 1`: every factor is `x/x` with `x ≠ 0` by genericity. -/
theorem nuNewton_eval_self [QGeneric K] (r : ℕ) :
    nuNewton (K := K) r ((P.q ^ 2) ^ r) = 1 := by
  unfold nuNewton
  refine Finset.prod_eq_one fun s hs => ?_
  exact div_self (hq_Q_pow_sub_ne_zero (Finset.mem_range.mp hs))

/-- `ν_r(Q^k) = 0` for `k < r`: the factor at `s = k` has numerator `0`
(no genericity needed). -/
theorem nuNewton_eval_zero_of_lt (r k : ℕ) (h : k < r) :
    nuNewton (K := K) r ((P.q ^ 2) ^ k) = 0 := by
  unfold nuNewton
  refine Finset.prod_eq_zero (Finset.mem_range.mpr h) ?_
  rw [sub_self, zero_div]

/-- Gaussian product form: for `r ≤ k`,
`ν_r(Q^k) = ∏_{s<r} (Q^{k−s} − 1)/(Q^{r−s} − 1)` — per factor,
`Q^k − Q^s = Q^s(Q^{k−s} − 1)` and the common `Q^s` cancels. -/
theorem nuNewton_eval_gaussian [QGeneric K] {r k : ℕ} (h : r ≤ k) :
    nuNewton (K := K) r ((P.q ^ 2) ^ k)
      = ∏ s ∈ Finset.range r, (((P.q ^ 2) ^ (k - s) - 1) / ((P.q ^ 2) ^ (r - s) - 1)) := by
  unfold nuNewton
  refine Finset.prod_congr rfl fun s hs => ?_
  have hs' : s < r := Finset.mem_range.mp hs
  obtain ⟨a, hk⟩ : ∃ a, k = s + (a + 1) := ⟨k - s - 1, by omega⟩
  obtain ⟨b, hr⟩ : ∃ b, r = s + (b + 1) := ⟨r - s - 1, by omega⟩
  subst hk
  subst hr
  have h1 : s + (a + 1) - s = a + 1 := by omega
  have h2 : s + (b + 1) - s = b + 1 := by omega
  rw [h1, h2]
  have hd1 : (P.q ^ 2) ^ (s + (b + 1)) - (P.q ^ 2) ^ s ≠ 0 :=
    hq_Q_pow_sub_ne_zero (by omega)
  have hd2 : (P.q ^ 2) ^ (b + 1) - 1 ≠ 0 := by
    have h0 := hq_Q_pow_sub_ne_zero (K := K) (r := b + 1) (s := 0) (by omega)
    rwa [pow_zero] at h0
  rw [div_eq_div_iff hd1 hd2, pow_add, pow_add]
  ring

end GL2
end Verma
end A1
end HybridQuantumLean
