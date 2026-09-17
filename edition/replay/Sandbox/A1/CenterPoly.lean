import Sandbox.A1.QArith
import Mathlib.Algebra.MvPolynomial.Basic
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.Algebra.MvPolynomial.CommRing
import Mathlib.Algebra.MvPolynomial.NoZeroDivisors
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

set_option linter.style.header false

/-!
# A1 CENTER — the polynomial wall-division layer

Exact-division home for the DCK wall calculus of the v104 rank-one proof
(`research/hybrid_fu_blm_v104.tex`, `lem:v99-straightening` / `prop:v99-finite-support`),
which the function layer (`A1/CenterYFun.lean`, junk-valued field division) cannot provide.
CAS ground truth: `sandboxv0/scratch/gl2_center_c5_out.md`, `gl2_center_c5_v4_micro_out.md`.

We work in `R := MvPolynomial (Fin 2) K` with `X 0 = ` shifted `Y₁`, `X 1 = ` shifted `Y₂`,
and `Q = q²` (tex + CAS conventions):

* substitutions (as `K`-algebra endomorphisms via `aeval`):
  `s1p : (Y₁,Y₂) ↦ (Y₂,Y₁)`, `s0p : (Y₁,Y₂) ↦ (QY₂, Q⁻¹Y₁)`,
  `taup a : (Y₁,Y₂) ↦ (QᵃY₁, Q⁻ᵃY₂)`;
* walls `wall1p = Y₁ − Y₂` (finite), `wall0p = Y₁/Q − Y₂` (affine);
* **factor theorems** `wall1p_dvd_sub_s1p` / `wall0p_dvd_sub_s0p` (proved by the generic
  substitution-divisibility engine `dvd_sub_aeval`, an induction over `MvPolynomial`);
* exact residues `d1p` / `d0p` (choice from the divisibility) with spec + uniqueness;
* the degree-drop engine: walls have total degree 1, all three substitutions preserve
  `totalDegree` (two-sided `aeval` bound + involutivity/translation-inverse), and the
  residues strictly drop degree: `totalDegree_d1p_lt` / `totalDegree_d0p_lt` —
  stated with the single hypothesis `f - s·f ≠ 0` (the prompt's extra hypothesis
  `1 ≤ f.totalDegree` is implied, so the statement here is stronger).

Statement adjustments vs the brief are recorded in the section docstrings below.
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace Verma
namespace GL2

open MvPolynomial

universe u


/-! ## The generic substitution-divisibility engine

If `w` divides `X i - g i` for every generator, then `w` divides `f - aeval g f` for
every polynomial `f` (Mathlib has no MvPolynomial factor theorem; loogle-checked). -/

section SwapLayer

variable {K : Type u} [Field K]

/-- Wall-division engine: if `w ∣ X i - g i` for all `i`, then `w ∣ f - aeval g f`. -/
theorem dvd_sub_aeval (w : MvPolynomial (Fin 2) K) (g : Fin 2 → MvPolynomial (Fin 2) K)
    (hw : ∀ i, w ∣ X i - g i) (f : MvPolynomial (Fin 2) K) :
    w ∣ f - aeval g f := by
  induction f using MvPolynomial.induction_on with
  | C a => simp [algebraMap_eq]
  | add p q hp hq =>
    rw [map_add,
      show p + q - (aeval g p + aeval g q) = p - aeval g p + (q - aeval g q) by ring]
    exact dvd_add hp hq
  | mul_X p i hp =>
    rw [map_mul, aeval_X,
      show p * X i - aeval g p * g i
          = (p - aeval g p) * X i + aeval g p * (X i - g i) by ring]
    exact dvd_add (hp.mul_right _) ((hw i).mul_left _)

/-! ## The finite (Weyl) layer — `s₁` and `wall1p` (no quantum parameter needed) -/

/-- Finite Weyl swap `s₁ : (Y₁,Y₂) ↦ (Y₂,Y₁)` as a `K`-algebra endomorphism of `R`. -/
noncomputable def s1p : MvPolynomial (Fin 2) K →ₐ[K] MvPolynomial (Fin 2) K := aeval ![X 1, X 0]

/-- The finite wall `Y₁ − Y₂`. -/
noncomputable def wall1p : MvPolynomial (Fin 2) K := X 0 - X 1

@[simp] theorem s1p_X0 : s1p (K := K) (X 0) = X 1 := by simp [s1p]

@[simp] theorem s1p_X1 : s1p (K := K) (X 1) = X 0 := by simp [s1p]

/-- `s₁ ∘ s₁ = id` at the algebra-map level (via `MvPolynomial.algHom_ext`). -/
theorem s1p_comp_s1p : (s1p (K := K)).comp s1p = AlgHom.id K (MvPolynomial (Fin 2) K) := by
  refine algHom_ext fun i => ?_
  fin_cases i <;> simp

/-- `s₁` is an involution, pointwise. -/
theorem s1p_s1p (f : MvPolynomial (Fin 2) K) : s1p (K := K) (s1p f) = f :=
  DFunLike.congr_fun s1p_comp_s1p f

/-- `s₁` is an involution. -/
theorem s1p_involutive : Function.Involutive (s1p (K := K)) := s1p_s1p

/-- The finite wall is nonzero (evaluation at `(1,0)` gives `1`). -/
theorem wall1p_ne_zero : wall1p (K := K) ≠ 0 := by
  intro h
  have h1 := congrArg (eval ![(1 : K), 0]) h
  simp [wall1p] at h1

/-- FACTOR THEOREM, finite wall: `Y₁ − Y₂ ∣ f − s₁f`. -/
theorem wall1p_dvd_sub_s1p (f : MvPolynomial (Fin 2) K) : wall1p (K := K) ∣ f - s1p f := by
  refine dvd_sub_aeval _ _ (fun i => ?_) f
  fin_cases i
  · change wall1p (K := K) ∣ X 0 - X 1
    exact dvd_of_eq (by simp only [wall1p])
  · change wall1p (K := K) ∣ X 1 - X 0
    rw [show (X 1 - X 0 : MvPolynomial (Fin 2) K) = -wall1p (K := K) by
      simp only [wall1p]; ring]
    exact dvd_neg.mpr dvd_rfl

/-! ### Exact residue `d1p`

`d1p` is defined through `exists_eq_mul_right_of_dvd … |>.choose` (the brief's
`(wall1p_dvd_sub_s1p f).choose` spelled robustly); `d1p_spec`/`d1p_unique` as specified. -/

/-- The exact finite residue: the unique `g` with `wall1p * g = f - s1p f`. -/
noncomputable def d1p (f : MvPolynomial (Fin 2) K) : MvPolynomial (Fin 2) K :=
  (exists_eq_mul_right_of_dvd (wall1p_dvd_sub_s1p f)).choose

theorem d1p_spec (f : MvPolynomial (Fin 2) K) : wall1p (K := K) * d1p f = f - s1p f :=
  ((exists_eq_mul_right_of_dvd (wall1p_dvd_sub_s1p f)).choose_spec).symm

theorem d1p_unique {f g : MvPolynomial (Fin 2) K} (h : wall1p (K := K) * g = f - s1p f) :
    g = d1p f :=
  mul_left_cancel₀ wall1p_ne_zero (h.trans (d1p_spec f).symm)

/-- An `s₁`-invariant polynomial has vanishing finite residue. -/
theorem d1p_of_s1p_eq (f : MvPolynomial (Fin 2) K) (h : s1p (K := K) f = f) : d1p f = 0 :=
  (d1p_unique (by rw [mul_zero, h, sub_self])).symm

/-! ### Degree bookkeeping (finite side) -/

/-- Substitutions with degree-`≤ 1` generator images do not raise `totalDegree`. -/
theorem totalDegree_aeval_le (g : Fin 2 → MvPolynomial (Fin 2) K)
    (hg : ∀ i, (g i).totalDegree ≤ 1) (f : MvPolynomial (Fin 2) K) :
    (aeval g f).totalDegree ≤ f.totalDegree := by
  conv_lhs => rw [f.as_sum]
  rw [map_sum]
  refine (totalDegree_finsetSum _ _).trans (Finset.sup_le fun m hm => ?_)
  rw [aeval_monomial]
  refine (totalDegree_mul _ _).trans ?_
  rw [algebraMap_eq, totalDegree_C, zero_add]
  refine le_trans ?_ (le_totalDegree hm)
  rw [Finsupp.prod]
  refine (totalDegree_finsetProd _ _).trans ?_
  rw [Finsupp.sum]
  refine Finset.sum_le_sum fun i _ => ?_
  refine (totalDegree_pow _ _).trans ?_
  calc m i * (g i).totalDegree ≤ m i * 1 := Nat.mul_le_mul_left _ (hg i)
    _ = m i := Nat.mul_one _

/-- `C c * X i` has total degree at most 1. -/
theorem totalDegree_C_mul_X_le (c : K) (i : Fin 2) :
    (C c * X i : MvPolynomial (Fin 2) K).totalDegree ≤ 1 :=
  (totalDegree_mul _ _).trans (by simp [totalDegree_C, totalDegree_X])

/-- The finite wall has total degree exactly 1. -/
theorem totalDegree_wall1p : (wall1p (K := K)).totalDegree = 1 := by
  have hle : (wall1p (K := K)).totalDegree ≤ 1 := by
    simp only [wall1p]
    exact (totalDegree_sub _ _).trans
      (max_le (le_of_eq (totalDegree_X 0)) (le_of_eq (totalDegree_X 1)))
  refine le_antisymm hle ?_
  by_contra hlt
  rw [not_le, Nat.lt_one_iff, totalDegree_eq_zero_iff_eq_C] at hlt
  have h1 := congrArg (eval ![(1 : K), 0]) hlt
  have h0 := congrArg (eval ![(0 : K), 0]) hlt
  simp only [wall1p, map_sub, eval_X, Matrix.cons_val_zero, Matrix.cons_val_one,
    eval_C, sub_zero] at h1 h0
  exact one_ne_zero (h1.trans h0.symm)

/-- `s₁` preserves total degree (two-sided `aeval` bound + involutivity). -/
theorem totalDegree_s1p (f : MvPolynomial (Fin 2) K) :
    (s1p (K := K) f).totalDegree = f.totalDegree := by
  have key : ∀ h : MvPolynomial (Fin 2) K, (s1p (K := K) h).totalDegree ≤ h.totalDegree := by
    intro h
    refine totalDegree_aeval_le _ (fun i => ?_) h
    fin_cases i <;>
      simp [totalDegree_X]
  refine le_antisymm (key f) ?_
  conv_lhs => rw [← s1p_s1p (K := K) f]
  exact key (s1p f)

theorem totalDegree_sub_s1p_le (f : MvPolynomial (Fin 2) K) :
    (f - s1p (K := K) f).totalDegree ≤ f.totalDegree := by
  refine (totalDegree_sub _ _).trans ?_
  rw [totalDegree_s1p]
  exact max_le le_rfl le_rfl

/-- DEGREE DROP, finite side: on non-`s₁`-invariant input the residue strictly
drops total degree. (The hypothesis `1 ≤ f.totalDegree` of the brief is implied.) -/
theorem totalDegree_d1p_lt {f : MvPolynomial (Fin 2) K} (h : f - s1p (K := K) f ≠ 0) :
    (d1p f).totalDegree < f.totalDegree := by
  have hd : d1p f ≠ 0 := by
    intro h0
    rw [← d1p_spec f, h0, mul_zero] at h
    exact h rfl
  have hmul := totalDegree_mul_of_isDomain wall1p_ne_zero hd
  rw [d1p_spec f, totalDegree_wall1p] at hmul
  have hle := totalDegree_sub_s1p_le f
  omega

end SwapLayer

/-! ## The affine layer — `s₀`, `τ`, `wall0p` (needs `Q = q²`) -/

section AffineLayer

variable {K : Type u} [Field K] [P : QFieldParams K]

/-- Affine swap `s₀ : (Y₁,Y₂) ↦ (QY₂, Q⁻¹Y₁)`, `Q = q²`. -/
noncomputable def s0p : MvPolynomial (Fin 2) K →ₐ[K] MvPolynomial (Fin 2) K :=
  aeval ![C (P.q ^ 2) * X 1, C ((P.q ^ 2)⁻¹) * X 0]

/-- Lattice translation `τᵃ : (Y₁,Y₂) ↦ (QᵃY₁, Q⁻ᵃY₂)`. -/
noncomputable def taup (a : ℤ) : MvPolynomial (Fin 2) K →ₐ[K] MvPolynomial (Fin 2) K :=
  aeval ![C ((P.q ^ 2) ^ a) * X 0, C ((P.q ^ 2) ^ (-a)) * X 1]

/-- The affine wall `Y₁/Q − Y₂`. -/
noncomputable def wall0p : MvPolynomial (Fin 2) K := C ((P.q ^ 2)⁻¹) * X 0 - X 1

@[simp] theorem s0p_X0 : s0p (K := K) (X 0) = C (P.q ^ 2) * X 1 := by simp [s0p]

@[simp] theorem s0p_X1 : s0p (K := K) (X 1) = C ((P.q ^ 2)⁻¹) * X 0 := by simp [s0p]

@[simp] theorem taup_X0 (a : ℤ) :
    taup (K := K) a (X 0) = C ((P.q ^ 2) ^ a) * X 0 := by simp [taup]

@[simp] theorem taup_X1 (a : ℤ) :
    taup (K := K) a (X 1) = C ((P.q ^ 2) ^ (-a)) * X 1 := by simp [taup]

@[simp] theorem s0p_C (c : K) : s0p (K := K) (C c) = C c := by
  simp [s0p, algebraMap_eq]

@[simp] theorem taup_C (a : ℤ) (c : K) : taup (K := K) a (C c) = C c := by
  simp [taup, algebraMap_eq]

/-- `s₀ ∘ s₀ = id` at the algebra-map level (`s₀` is also an involution). -/
theorem s0p_comp_s0p : (s0p (K := K)).comp s0p = AlgHom.id K (MvPolynomial (Fin 2) K) := by
  have hQ : (P.q ^ 2 : K) ≠ 0 := pow_ne_zero 2 P.q_ne_zero
  have hCQ : (C (P.q ^ 2) : MvPolynomial (Fin 2) K) * C ((P.q ^ 2)⁻¹) = 1 := by
    rw [← C_mul, mul_inv_cancel₀ hQ, C_1]
  have hCQ' : (C ((P.q ^ 2)⁻¹) : MvPolynomial (Fin 2) K) * C (P.q ^ 2) = 1 := by
    rw [← C_mul, inv_mul_cancel₀ hQ, C_1]
  refine algHom_ext fun i => ?_
  fin_cases i
  · change s0p (K := K) (s0p (X 0)) = X 0
    rw [s0p_X0, map_mul, s0p_C, s0p_X1, ← mul_assoc, hCQ, one_mul]
  · change s0p (K := K) (s0p (X 1)) = X 1
    rw [s0p_X1, map_mul, s0p_C, s0p_X0, ← mul_assoc, hCQ', one_mul]

/-- `s₀` is an involution, pointwise. -/
theorem s0p_s0p (f : MvPolynomial (Fin 2) K) : s0p (K := K) (s0p f) = f :=
  DFunLike.congr_fun s0p_comp_s0p f

/-- Translations compose additively at the algebra-map level. -/
theorem taup_comp_taup (a b : ℤ) :
    (taup (K := K) a).comp (taup b) = taup (a + b) := by
  have hQ : (P.q ^ 2 : K) ≠ 0 := pow_ne_zero 2 P.q_ne_zero
  refine algHom_ext fun i => ?_
  fin_cases i
  · change taup (K := K) a (taup b (X 0)) = taup (a + b) (X 0)
    rw [taup_X0 b, taup_X0 (a + b), map_mul, taup_C, taup_X0 a, ← mul_assoc, ← C_mul,
      ← zpow_add₀ hQ, add_comm b a]
  · change taup (K := K) a (taup b (X 1)) = taup (a + b) (X 1)
    rw [taup_X1 b, taup_X1 (a + b), map_mul, taup_C, taup_X1 a, ← mul_assoc, ← C_mul,
      ← zpow_add₀ hQ, neg_add_rev]

/-- `τᵃ ∘ τᵇ = τᵃ⁺ᵇ`, pointwise. -/
theorem taup_add (a b : ℤ) (f : MvPolynomial (Fin 2) K) :
    taup (K := K) a (taup b f) = taup (a + b) f :=
  DFunLike.congr_fun (taup_comp_taup a b) f

/-- `τ⁰ = id` at the algebra-map level. -/
theorem taup_zero_eq_id : taup (K := K) 0 = AlgHom.id K (MvPolynomial (Fin 2) K) := by
  refine algHom_ext fun i => ?_
  fin_cases i <;> simp [taup]

theorem taup_zero (f : MvPolynomial (Fin 2) K) : taup (K := K) 0 f = f :=
  DFunLike.congr_fun taup_zero_eq_id f

/-- Inverse translations cancel: `τ⁻ᵃ ∘ τᵃ = id`, pointwise. -/
theorem taup_neg_taup (a : ℤ) (f : MvPolynomial (Fin 2) K) :
    taup (K := K) (-a) (taup a f) = f := by
  rw [taup_add, neg_add_cancel, taup_zero]

/-- The affine wall is nonzero (evaluation at `(0,1)` gives `-1`). -/
theorem wall0p_ne_zero : wall0p (K := K) ≠ 0 := by
  intro h
  have h1 := congrArg (eval ![(0 : K), 1]) h
  simp [wall0p] at h1

/-- FACTOR THEOREM, affine wall: `Y₁/Q − Y₂ ∣ f − s₀f`. The generator witness on
`X 0` is the unit `C (q²)` — divisibility is insensitive to the wall's unit leading
coefficient. -/
theorem wall0p_dvd_sub_s0p (f : MvPolynomial (Fin 2) K) : wall0p (K := K) ∣ f - s0p f := by
  have hQ : (P.q ^ 2 : K) ≠ 0 := pow_ne_zero 2 P.q_ne_zero
  refine dvd_sub_aeval _ _ (fun i => ?_) f
  fin_cases i
  · change wall0p (K := K) ∣ X 0 - C (P.q ^ 2) * X 1
    refine ⟨C (P.q ^ 2), ?_⟩
    have hC : (C ((P.q ^ 2)⁻¹) : MvPolynomial (Fin 2) K) * C (P.q ^ 2) = 1 := by
      rw [← C_mul, inv_mul_cancel₀ hQ, C_1]
    calc (X 0 : MvPolynomial (Fin 2) K) - C (P.q ^ 2) * X 1
        = C ((P.q ^ 2)⁻¹) * C (P.q ^ 2) * X 0 - C (P.q ^ 2) * X 1 := by
          rw [hC, one_mul]
      _ = wall0p (K := K) * C (P.q ^ 2) := by simp only [wall0p]; ring
  · change wall0p (K := K) ∣ X 1 - C ((P.q ^ 2)⁻¹) * X 0
    refine ⟨-1, ?_⟩
    simp only [wall0p]; ring

/-! ### Exact residue `d0p` -/

/-- The exact affine residue: the unique `g` with `wall0p * g = f - s0p f`. -/
noncomputable def d0p (f : MvPolynomial (Fin 2) K) : MvPolynomial (Fin 2) K :=
  (exists_eq_mul_right_of_dvd (wall0p_dvd_sub_s0p f)).choose

theorem d0p_spec (f : MvPolynomial (Fin 2) K) : wall0p (K := K) * d0p f = f - s0p f :=
  ((exists_eq_mul_right_of_dvd (wall0p_dvd_sub_s0p f)).choose_spec).symm

theorem d0p_unique {f g : MvPolynomial (Fin 2) K} (h : wall0p (K := K) * g = f - s0p f) :
    g = d0p f :=
  mul_left_cancel₀ wall0p_ne_zero (h.trans (d0p_spec f).symm)

/-- An `s₀`-invariant polynomial has vanishing affine residue. -/
theorem d0p_of_s0p_eq (f : MvPolynomial (Fin 2) K) (h : s0p (K := K) f = f) : d0p f = 0 :=
  (d0p_unique (by rw [mul_zero, h, sub_self])).symm

/-! ### Degree bookkeeping (affine side) -/

/-- The affine wall has total degree exactly 1 (its coefficients are units). -/
theorem totalDegree_wall0p : (wall0p (K := K)).totalDegree = 1 := by
  have hle : (wall0p (K := K)).totalDegree ≤ 1 := by
    simp only [wall0p]
    exact (totalDegree_sub _ _).trans
      (max_le (totalDegree_C_mul_X_le _ _) (le_of_eq (totalDegree_X 1)))
  refine le_antisymm hle ?_
  by_contra hlt
  rw [not_le, Nat.lt_one_iff, totalDegree_eq_zero_iff_eq_C] at hlt
  have h1 := congrArg (eval ![(0 : K), 1]) hlt
  have h0 := congrArg (eval ![(0 : K), 0]) hlt
  simp only [wall0p, map_sub, map_mul, eval_C, eval_X, Matrix.cons_val_zero,
    Matrix.cons_val_one, mul_zero, zero_sub, sub_zero] at h1 h0
  have hneg : (-1 : K) = 0 := h1.trans h0.symm
  simp at hneg

/-- `s₀` preserves total degree. -/
theorem totalDegree_s0p (f : MvPolynomial (Fin 2) K) :
    (s0p (K := K) f).totalDegree = f.totalDegree := by
  have key : ∀ h : MvPolynomial (Fin 2) K, (s0p (K := K) h).totalDegree ≤ h.totalDegree := by
    intro h
    refine totalDegree_aeval_le _ (fun i => ?_) h
    fin_cases i <;> exact totalDegree_C_mul_X_le _ _
  refine le_antisymm (key f) ?_
  conv_lhs => rw [← s0p_s0p (K := K) f]
  exact key (s0p f)

/-- `τᵃ` preserves total degree. -/
theorem totalDegree_taup (a : ℤ) (f : MvPolynomial (Fin 2) K) :
    (taup (K := K) a f).totalDegree = f.totalDegree := by
  have key : ∀ (b : ℤ) (h : MvPolynomial (Fin 2) K),
      (taup (K := K) b h).totalDegree ≤ h.totalDegree := by
    intro b h
    refine totalDegree_aeval_le _ (fun i => ?_) h
    fin_cases i <;> exact totalDegree_C_mul_X_le _ _
  refine le_antisymm (key a f) ?_
  conv_lhs => rw [← taup_neg_taup (K := K) a f]
  exact key (-a) (taup a f)

theorem totalDegree_sub_s0p_le (f : MvPolynomial (Fin 2) K) :
    (f - s0p (K := K) f).totalDegree ≤ f.totalDegree := by
  refine (totalDegree_sub _ _).trans ?_
  rw [totalDegree_s0p]
  exact max_le le_rfl le_rfl

/-- DEGREE DROP, affine side: on non-`s₀`-invariant input the residue strictly
drops total degree. (The hypothesis `1 ≤ f.totalDegree` of the brief is implied.) -/
theorem totalDegree_d0p_lt {f : MvPolynomial (Fin 2) K} (h : f - s0p (K := K) f ≠ 0) :
    (d0p f).totalDegree < f.totalDegree := by
  have hd : d0p f ≠ 0 := by
    intro h0
    rw [← d0p_spec f, h0, mul_zero] at h
    exact h rfl
  have hmul := totalDegree_mul_of_isDomain wall0p_ne_zero hd
  rw [d0p_spec f, totalDegree_wall0p] at hmul
  have hle := totalDegree_sub_s0p_le f
  omega

end AffineLayer

end GL2
end Verma
end A1
end HybridQuantumLean

