import Sandbox.A1.Center
import Sandbox.A1.CenterNewton
import Sandbox.A1.LaurentZZ
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Algebra.Ring.Subring.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

set_option linter.style.header false

/-!
# A1 CENTER program, ASM-4 (Tier B, LATTICE wave) — the `A_z` subring and the Newton
grid criterion

Tier-B opener (`sandboxv0/docs/11_center_program_v1.md`; log `docs/13_center_log.md`).
Two layers:

1. **The coefficient subring** `AzSubring = ℤ[q^{±1}, z₁^{±1}, z₂^{±1}] ⊆ K`
   (`Subring.closure` of the six units) with its membership calculus: generators,
   ℤ-powers, `qInt_mem` (induction on the certified recurrence `[n+1] = q[n] + q^{−n}`,
   ℤ-indexed via `[−n] = −[n]`), the **`ℤ[q^±]`-integrality bridge** `mem_of_isIntegral`
   (any `A1/LaurentZZ.IsIntegral` element lies in `A_z` — `LaurentPolynomial.induction_on'`
   over `evalToField`), and `qBinom_mem` as its corollary from `qBinom_isIntegral`.

2. **The Newton grid criterion** (the v104 coefficient-recovery mechanism, one variable).
   `newtonSum d a Y = Σ_{r ≤ d} a_r ν_r(Y)` in the certified Newton basis of
   `A1/CenterNewton`. The interpolation triangle (`ν_r(Q^r) = 1`, `ν_r(Q^L) = 0` for
   `L < r`) gives the **unitriangular grid evaluation** `newtonSum_eval_grid`:
   `(newtonSum d a)(Q^L) = a_L + Σ_{r<L} a_r ν_r(Q^L)` for `L ≤ d`. The grid values are
   themselves in `A_z` by the **Gaussian value identity** `nuNewton_eval_eq_qBinom`
   (CAS-pinned, warm REPL 9917, all `0 ≤ r ≤ L ≤ 7`):
   `ν_r(Q^L) = q^{(L−r)r}·[L;r]_q`, so triangular subtraction recovers the coefficients:
   **`gridCriterion`**: `(∀ r ≤ d, a_r ∈ A_z) ↔ (∀ L ≤ d, (newtonSum d a)(Q^L) ∈ A_z)`.

**FRAME CONVENTION (docs/13, 2026-07-03 "V4 RESOLVED", two-frame finding).** Everything
here lives in the UNSHIFTED frame: the Newton variable is `Y̌ᵢ = (Tᵢ⁺)²` and the grid
points are the unshifted eigenvalue powers `Q^L = (q²)^L`. Lattice integrality is a
statement of THIS frame. The `s₁`-invariance layer lives in the shifted HC variables
`Y = (Qz₁⁻¹Y̌₁, z₂⁻¹Y̌₂)`; the bridge is unit-monomial but NOT Newton-basis-preserving —
do not mix the frames inside one statement.

**What ASM-5 (paired-wall divisibility) consumes from this file:** the membership
calculus (`q_zpow_mem`, `z1_zpow_mem`, `z2_zpow_mem`, `qInt_mem`, `qBinom_mem` — unit
monomials `q^a z₁^b z₂^c` are `mul_mem` chains), the bridge `mem_of_isIntegral` (any
CAS-pinned `ℤ[q^±]` numerator lands in `A_z` for free), and the packaged
`gridCriterion` + `nuNewton_eval_eq_qBinom` to convert row-value divisibility on the
grid into `A_z`-membership of Newton coefficients. λ-carrying scalars (`eCoeffZ` etc.)
are deliberately OUT of scope: integral rows have λ-free coefficients (docs/13 finding);
λ-free wall binomials, once CAS-pinned in ASM-5, get membership from the closure
calculus here in one line each.
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace Verma
namespace GL2

open QFieldParams

universe u

/-! ## Scalar layer: the Gaussian value of the Newton basis on the grid -/

section NewtonValue

variable {K : Type u} [Field K] [P : QFieldParams K]

/-- Per-factor symmetrization bridge (CAS-checked on the warm REPL for
`0 ≤ s < r ≤ L ≤ 7`): for `s < r ≤ L`, with `Q = q²`,
`(Q^L − Q^s)/(Q^r − Q^s) = q^{L−r}·([L−s]_q/[r−s]_q)`. -/
theorem hq_grid_factor [QGeneric K] {s r L : ℕ} (hsr : s < r) (hrL : r ≤ L) :
    ((P.q ^ 2) ^ L - (P.q ^ 2) ^ s) / ((P.q ^ 2) ^ r - (P.q ^ 2) ^ s)
      = P.q ^ (L - r) *
        (qInt (K := K) ((L : ℤ) - (s : ℤ)) / qInt (K := K) ((r : ℤ) - (s : ℤ))) := by
  obtain ⟨u, rfl⟩ : ∃ u, r = s + u + 1 := ⟨r - s - 1, by omega⟩
  obtain ⟨v, rfl⟩ : ∃ v, L = s + u + 1 + v := ⟨L - (s + u + 1), by omega⟩
  have hq : P.q ≠ 0 := P.q_ne_zero
  have hd : P.q - P.q⁻¹ ≠ 0 := q_sub_qinv_ne_zero (K := K)
  have hB : (P.q ^ 2) ^ (s + u + 1) - (P.q ^ 2) ^ s ≠ 0 :=
    hq_Q_pow_sub_ne_zero (by omega)
  have hY : qInt (K := K) ((u + 1 : ℕ) : ℤ) ≠ 0 := qInt_ne_zero (by omega)
  have hexp : s + u + 1 + v - (s + u + 1) = v := by omega
  have hargL : ((s + u + 1 + v : ℕ) : ℤ) - (s : ℤ) = ((u + 1 + v : ℕ) : ℤ) := by
    push_cast; ring
  have hargr : ((s + u + 1 : ℕ) : ℤ) - (s : ℤ) = ((u + 1 : ℕ) : ℤ) := by
    push_cast; ring
  rw [hexp, hargL, hargr, ← mul_div_assoc, div_eq_div_iff hB hY]
  simp only [qInt, zpow_neg, zpow_natCast]
  field_simp
  ring

/-- **The Gaussian value of the Newton basis on the grid** (CAS-pinned, warm REPL 9917,
all `0 ≤ r ≤ L ≤ 7`): for `r ≤ L`, `ν_r(Q^L) = q^{(L−r)·r} · [L;r]_q` — a `q`-power unit
times the symmetric Gaussian binomial. Route: per-factor bridge `hq_grid_factor`, split
the product, reflect the denominator product onto `∏_{j<r}[j+1]_q`, and match
`qBinom_eq_symValue`/`hq_symValue_eq_prod`. -/
theorem nuNewton_eval_eq_qBinom [QGeneric K] {r L : ℕ} (h : r ≤ L) :
    nuNewton (K := K) r ((P.q ^ 2) ^ L)
      = P.q ^ ((L - r) * r) * qBinom (K := K) L r := by
  have h1 : nuNewton (K := K) r ((P.q ^ 2) ^ L)
      = ∏ s ∈ Finset.range r, (P.q ^ (L - r) *
          (qInt (K := K) ((L : ℤ) - (s : ℤ)) / qInt (K := K) ((r : ℤ) - (s : ℤ)))) := by
    unfold nuNewton
    exact Finset.prod_congr rfl fun s hs => hq_grid_factor (Finset.mem_range.mp hs) h
  have hden : ∏ s ∈ Finset.range r, qInt (K := K) ((r : ℤ) - (s : ℤ))
      = ∏ j ∈ Finset.range r, qInt (K := K) ((j : ℤ) + 1) := by
    rw [← Finset.prod_range_reflect (fun j => qInt (K := K) ((j : ℤ) + 1)) r]
    refine Finset.prod_congr rfl fun s hs => ?_
    have hs' : s < r := Finset.mem_range.mp hs
    congr 1
    omega
  rw [h1, Finset.prod_mul_distrib, Finset.prod_const, Finset.card_range, ← pow_mul,
    Finset.prod_div_distrib, hden, qBinom_eq_symValue h, hq_symValue_eq_prod,
    Finset.prod_div_distrib]

/-! ## The finite Newton expansion and its unitriangular grid evaluation -/

/-- Finite Newton expansion with coefficient stream `a` and degree bound `d`:
`newtonSum d a Y = Σ_{r ≤ d} a_r · ν_r(Y)` (scalar-valued, matching
`CenterNewton.nuNewton : ℕ → K → K`). -/
noncomputable def newtonSum (d : ℕ) (a : ℕ → K) (Y : K) : K :=
  ∑ r ∈ Finset.range (d + 1), a r * nuNewton (K := K) r Y

/-- **Unitriangular grid evaluation**: for `L ≤ d`,
`(newtonSum d a)(Q^L) = a_L + Σ_{r<L} a_r · ν_r(Q^L)` — the terms `r > L` die by the
interpolation triangle and the diagonal term is `1`. -/
theorem newtonSum_eval_grid [QGeneric K] (d : ℕ) (a : ℕ → K) {L : ℕ} (hL : L ≤ d) :
    newtonSum (K := K) d a ((P.q ^ 2) ^ L)
      = a L + ∑ r ∈ Finset.range L, a r * nuNewton (K := K) r ((P.q ^ 2) ^ L) := by
  unfold newtonSum
  have hsub : Finset.range (L + 1) ⊆ Finset.range (d + 1) :=
    Finset.range_subset_range.mpr (by omega)
  have hvanish : ∀ x ∈ Finset.range (d + 1), x ∉ Finset.range (L + 1) →
      a x * nuNewton (K := K) x ((P.q ^ 2) ^ L) = 0 := by
    intro x _ hx
    simp only [Finset.mem_range, not_lt] at hx
    rw [nuNewton_eval_zero_of_lt x L (by omega), mul_zero]
  rw [← Finset.sum_subset hsub hvanish, Finset.sum_range_succ, nuNewton_eval_self,
    mul_one]
  exact add_comm _ _

end NewtonValue

/-! ## The GL₂ coefficient lattice `A_z` and its membership calculus -/

section Lattice

variable {K : Type u} [Field K]

/-- ℤ-power closure helper: a subring containing `x` and `x⁻¹` contains every `x^n`,
`n : ℤ`. -/
theorem zpow_mem_of_inv_mem {S : Subring K} {x : K} (hx : x ∈ S) (hxi : x⁻¹ ∈ S)
    (n : ℤ) : x ^ n ∈ S := by
  rcases n with m | m
  · simpa using pow_mem hx m
  · rw [zpow_negSucc, ← inv_pow]
    exact pow_mem hxi (m + 1)

variable [G : GL2Params K]

/-- The coefficient subring `A_z = ℤ[q^{±1}, z₁^{±1}, z₂^{±1}] ⊆ K` of the even-hybrid
center statement (v104 thm:gl2): the subring generated by the six units. UNSHIFTED-frame
object — see the module docstring. -/
def AzSubring : Subring K :=
  Subring.closure {G.q, G.q⁻¹, G.z1, G.z1⁻¹, G.z2, G.z2⁻¹}

/-- `q ∈ A_z`. -/
theorem q_mem : G.q ∈ AzSubring (K := K) := Subring.subset_closure (by simp)

/-- `q⁻¹ ∈ A_z`. -/
theorem q_inv_mem : G.q⁻¹ ∈ AzSubring (K := K) := Subring.subset_closure (by simp)

/-- `z₁ ∈ A_z`. -/
theorem z1_mem : G.z1 ∈ AzSubring (K := K) := Subring.subset_closure (by simp)

/-- `z₁⁻¹ ∈ A_z`. -/
theorem z1_inv_mem : G.z1⁻¹ ∈ AzSubring (K := K) := Subring.subset_closure (by simp)

/-- `z₂ ∈ A_z`. -/
theorem z2_mem : G.z2 ∈ AzSubring (K := K) := Subring.subset_closure (by simp)

/-- `z₂⁻¹ ∈ A_z`. -/
theorem z2_inv_mem : G.z2⁻¹ ∈ AzSubring (K := K) := Subring.subset_closure (by simp)

/-- `q^n ∈ A_z` for every `n : ℤ`. -/
theorem q_zpow_mem (n : ℤ) : G.q ^ n ∈ AzSubring (K := K) :=
  zpow_mem_of_inv_mem q_mem q_inv_mem n

/-- `z₁^n ∈ A_z` for every `n : ℤ`. -/
theorem z1_zpow_mem (n : ℤ) : G.z1 ^ n ∈ AzSubring (K := K) :=
  zpow_mem_of_inv_mem z1_mem z1_inv_mem n

/-- `z₂^n ∈ A_z` for every `n : ℤ`. -/
theorem z2_zpow_mem (n : ℤ) : G.z2 ^ n ∈ AzSubring (K := K) :=
  zpow_mem_of_inv_mem z2_mem z2_inv_mem n

/-- `[n]_q ∈ A_z` for `n : ℕ` — despite the division in the definition of `qInt`, by
induction on the certified recurrence `[n+1]_q = q·[n]_q + q^{−n}` (`qInt_succ`). -/
theorem qInt_natCast_mem (n : ℕ) : qInt (K := K) (n : ℤ) ∈ AzSubring (K := K) := by
  induction n with
  | zero =>
    rw [Nat.cast_zero, qInt_zero]
    exact zero_mem _
  | succ n ih =>
    rw [show ((n + 1 : ℕ) : ℤ) = (n : ℤ) + 1 by push_cast; ring, qInt_succ]
    exact add_mem (mul_mem (q_mem (K := K)) ih) (q_zpow_mem (K := K) _)

/-- `[n]_q ∈ A_z` for every `n : ℤ` (antisymmetry `[−n]_q = −[n]_q`). -/
theorem qInt_mem (n : ℤ) : qInt (K := K) n ∈ AzSubring (K := K) := by
  rcases le_or_gt 0 n with hn | hn
  · obtain ⟨m, rfl⟩ : ∃ m : ℕ, n = (m : ℤ) := ⟨n.toNat, by omega⟩
    exact qInt_natCast_mem m
  · obtain ⟨m, rfl⟩ : ∃ m : ℕ, n = -(m : ℤ) := ⟨n.natAbs, by omega⟩
    rw [qInt_neg]
    exact neg_mem (qInt_natCast_mem m)

/-- **The `ℤ[q^{±1}]`-integrality bridge**: anything Laurent-integral in the sense of
`A1/LaurentZZ` (`IsIntegral x = ∃ p : ℤ[T;T⁻¹], evalToField p = x`) lies in `A_z`.
This hands every certified `isIntegral_*` fact to the lattice layer for free. -/
theorem mem_of_isIntegral {x : K} (hx : IsIntegral (K := K) x) :
    x ∈ AzSubring (K := K) := by
  obtain ⟨p, rfl⟩ := hx
  induction p using LaurentPolynomial.induction_on' with
  | add p q hp hq =>
    rw [map_add]
    exact add_mem hp hq
  | C_mul_T n a =>
    rw [map_mul, evalToField_T]
    refine mul_mem ?_ (q_zpow_mem (K := K) n)
    have hC : evalToField (K := K) (LaurentPolynomial.C a) = ((a : ℤ) : K) := by
      unfold evalToField
      rw [LaurentPolynomial.eval₂_C]
      exact eq_intCast (Int.castRingHom K) a
    rw [hC]
    exact intCast_mem _ a

/-- `[n;k]_q ∈ A_z` — from the Group E capstone `qBinom_isIntegral` via the bridge. -/
theorem qBinom_mem [QGeneric K] (n k : ℕ) :
    qBinom (K := K) n k ∈ AzSubring (K := K) :=
  mem_of_isIntegral (qBinom_isIntegral n k)

/-- Every grid value of the Newton basis is in `A_z`:
`ν_r(Q^L) = q^{(L−r)r}·[L;r]_q` for `r ≤ L`, and `0` for `L < r`. -/
theorem nuNewton_grid_mem [QGeneric K] (r L : ℕ) :
    nuNewton (K := K) r ((G.q ^ 2) ^ L) ∈ AzSubring (K := K) := by
  rcases le_or_gt r L with h | h
  · rw [nuNewton_eval_eq_qBinom h]
    exact mul_mem (pow_mem (q_mem (K := K)) _) (qBinom_mem L r)
  · rw [nuNewton_eval_zero_of_lt r L h]
    exact zero_mem _

/-! ## The grid criterion -/

/-- Easy direction: if all Newton coefficients up to the degree bound are in `A_z`, then
every grid value (any `L : ℕ`, not only `L ≤ d`) is in `A_z`. -/
theorem newtonSum_grid_mem [QGeneric K] (d : ℕ) (a : ℕ → K)
    (ha : ∀ r ≤ d, a r ∈ AzSubring (K := K)) (L : ℕ) :
    newtonSum (K := K) d a ((G.q ^ 2) ^ L) ∈ AzSubring (K := K) := by
  unfold newtonSum
  exact Subring.sum_mem _ fun r hr =>
    mul_mem (ha r (Nat.lt_succ_iff.mp (Finset.mem_range.mp hr))) (nuNewton_grid_mem r L)

/-- **Triangular coefficient recovery**: if all grid values `(newtonSum d a)(Q^L)`,
`L ≤ d`, are in `A_z`, then all coefficients `a_r`, `r ≤ d`, are in `A_z` — strong
induction on `r`, subtracting `Σ_{s<r} a_s·ν_s(Q^r) ∈ A_z` from the unitriangular
evaluation at `Q^r`. -/
theorem coeff_mem_of_grid_mem [QGeneric K] {d : ℕ} {a : ℕ → K}
    (hgrid : ∀ L ≤ d, newtonSum (K := K) d a ((G.q ^ 2) ^ L) ∈ AzSubring (K := K)) :
    ∀ r ≤ d, a r ∈ AzSubring (K := K) := by
  intro r
  induction r using Nat.strong_induction_on with
  | _ r ih =>
    intro hrd
    have hval := hgrid r hrd
    rw [newtonSum_eval_grid d a hrd] at hval
    have hsum : (∑ s ∈ Finset.range r,
        a s * nuNewton (K := K) s ((G.q ^ 2) ^ r)) ∈ AzSubring (K := K) :=
      Subring.sum_mem _ fun s hs =>
        mul_mem
          (ih s (Finset.mem_range.mp hs) ((Finset.mem_range.mp hs).le.trans hrd))
          (nuNewton_grid_mem s r)
    simpa using sub_mem hval hsum

/-- **THE GRID CRITERION** (v104 Newton criterion, one variable, unshifted frame):
the Newton coefficients of `newtonSum d a` lie in `A_z` iff all grid values on
`Q^0, …, Q^d` do. -/
theorem gridCriterion [QGeneric K] (d : ℕ) (a : ℕ → K) :
    (∀ r ≤ d, a r ∈ AzSubring (K := K)) ↔
      ∀ L ≤ d, newtonSum (K := K) d a ((G.q ^ 2) ^ L) ∈ AzSubring (K := K) :=
  ⟨fun ha L _ => newtonSum_grid_mem d a ha L, fun hgrid => coeff_mem_of_grid_mem hgrid⟩

end Lattice

end GL2
end Verma
end A1
end HybridQuantumLean
