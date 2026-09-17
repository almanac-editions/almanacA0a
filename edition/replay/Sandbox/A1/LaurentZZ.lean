import Sandbox.A1.QArith
import Mathlib.Algebra.Polynomial.Laurent

set_option linter.style.header false

/-!
# A1 Laurent ring layer `ℤ[q^±¹]` — Group E (q-binomial integrality)

This file implements the *mathematical* layer of
`notes/computable_laurent_ring_spec_for_lean_2026-06-16.md`: the ring `ℤ[q^±¹]`, its
evaluation into any `QFieldParams` field, the integrality predicate `IsIntegral`, and the
Group E capstone `qBinom_isIntegral` for the q-binomials of `A1/QArith.lean`.

**Design decisions.**

1. **Ring representation.** The ring is Mathlib's `LaurentPolynomial ℤ` (notation
   `ℤ[T;T⁻¹]`, an `AddMonoidAlgebra ℤ ℤ`, i.e. a `Finsupp`), *not* the spec's computable
   normal-form structure. The spec's §1–3 computable refinement is **DEFERRED**: once built,
   it can be transported here via a `RingEquiv` to `LaurentPolynomial ℤ` without changing any
   statement in this file.

2. **Univariate in `q`.** The spec's §4 ring is the bivariate `ℤ[q^±, z^±]`; we deliberately
   restrict to the univariate `ℤ[q^±]`. Embedding `z`-exponents would require `z` to be a
   *unit* of `K`, and `QFieldParams` (deliberately) does not assume `z ≠ 0` — that is a fact
   of the Julia realisation `K = ℚ(q)(z)`, not of the abstract class. Since the Gaussian
   q-binomials live in `ℤ[q^±]` anyway, the univariate ring is the correct home for Group E.
   The bivariate ring (needed for `eOneCoeffL`/row-0 ORACLE work) is future work.

3. **Trust (spec §7).** No `native_decide` anywhere; every proof goes through the kernel with
   only the standard axioms `[propext, Classical.choice, Quot.sound]`.
-/

namespace HybridQuantumLean
namespace A1
namespace Verma

open QFieldParams LaurentPolynomial

universe u
variable {K : Type u} [Field K] [P : QFieldParams K]

/-- `ℤ[q^±¹]` — integer Laurent polynomials, `LaurentPolynomial ℤ` from Mathlib.
    The formal variable `T` plays the role of `q`. -/
abbrev LaurentZZ : Type := LaurentPolynomial ℤ

/-- Evaluation `ℤ[q^±] →+* K` sending `T ↦ q` (a unit of `K` by `q_ne_zero`). -/
noncomputable def evalToField : LaurentZZ →+* K :=
  LaurentPolynomial.eval₂ (Int.castRingHom K) (Units.mk0 P.q P.q_ne_zero)

@[simp] lemma evalToField_T (n : ℤ) : evalToField (K := K) (T n) = P.q ^ n := by
  unfold evalToField
  rw [LaurentPolynomial.eval₂_T, Units.val_zpow_eq_zpow_val, Units.val_mk0]

/-- `x : K` is (Laurent-)integral if it is hit by `ℤ[q^±]` under `evalToField`. -/
def IsIntegral (x : K) : Prop := ∃ p : LaurentZZ, evalToField p = x

lemma isIntegral_zero : IsIntegral (0 : K) := ⟨0, map_zero _⟩

lemma isIntegral_one : IsIntegral (1 : K) := ⟨1, map_one _⟩

lemma isIntegral_add {x y : K} (hx : IsIntegral x) (hy : IsIntegral y) :
    IsIntegral (x + y) := by
  obtain ⟨p, hp⟩ := hx
  obtain ⟨r, hr⟩ := hy
  exact ⟨p + r, by rw [map_add, hp, hr]⟩

lemma isIntegral_mul {x y : K} (hx : IsIntegral x) (hy : IsIntegral y) :
    IsIntegral (x * y) := by
  obtain ⟨p, hp⟩ := hx
  obtain ⟨r, hr⟩ := hy
  exact ⟨p * r, by rw [map_mul, hp, hr]⟩

lemma isIntegral_neg {x : K} (hx : IsIntegral x) : IsIntegral (-x) := by
  obtain ⟨p, hp⟩ := hx
  exact ⟨-p, by rw [map_neg, hp]⟩

/-- Every q-power (arbitrary integer exponent) is integral —
    the "`q^a` is a unit of `ℤ[q^±]`" fact. -/
lemma isIntegral_q_zpow (a : ℤ) : IsIntegral (P.q ^ a) := ⟨T a, evalToField_T a⟩

/-- Sanity theorem (answers "how could `q² − 1 = 0` in `ℤ[q,q⁻¹]`?" — it can't):
    `T 2 - 1 ≠ 0` in `ℤ[q^±]`. Route: `T 2 = 1` would say
    `Finsupp.single 2 1 = Finsupp.single 0 1` (both by `rfl`), forcing `2 = 0` in `ℤ`. -/
lemma T_two_sub_one_ne_zero : (T 2 - 1 : LaurentZZ) ≠ 0 := by
  intro h
  have h1 : (Finsupp.single (2 : ℤ) (1 : ℤ) : ℤ →₀ ℤ) = Finsupp.single (0 : ℤ) (1 : ℤ) :=
    sub_eq_zero.mp h
  exact absurd ((Finsupp.single_left_inj one_ne_zero).mp h1) (by omega)

/-- **Group E capstone:** Gaussian q-binomials are Laurent polynomials — `[n;k]_q ∈ ℤ[q^±]`.
    Induction on `n` via the q-Pascal rule `qPascalI`; each coefficient `q^a` (arbitrary
    `a : ℤ`) is a unit of `ℤ[q^±]`, so integrality is preserved. -/
theorem qBinom_isIntegral [QGeneric K] (n k : ℕ) : IsIntegral (qBinom (K := K) n k) := by
  induction n generalizing k with
  | zero =>
    rcases k with _ | k
    · rw [qBinom_zero]; exact isIntegral_one
    · rw [qBinom_eq_zero_of_lt (by omega)]; exact isIntegral_zero
  | succ n ih =>
    rcases k with _ | k
    · rw [qBinom_zero]; exact isIntegral_one
    · by_cases hk : k + 1 ≤ n + 1
      · rw [qPascalI (by omega) hk]
        simp only [Nat.add_sub_cancel]
        exact isIntegral_add
          (isIntegral_mul (isIntegral_q_zpow _) (ih k))
          (isIntegral_mul (isIntegral_q_zpow _) (ih (k + 1)))
      · rw [qBinom_eq_zero_of_lt (by omega)]; exact isIntegral_zero

end Verma
end A1
end HybridQuantumLean
