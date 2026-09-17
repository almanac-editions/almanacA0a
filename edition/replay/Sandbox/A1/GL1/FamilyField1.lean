import Sandbox.A1.CenterLattice
import Mathlib.Algebra.Polynomial.Laurent
import Mathlib.Algebra.CharP.Algebra
import Mathlib.RingTheory.Localization.FractionRing

set_option linter.style.header false
set_option linter.unusedSectionVars false

/-!
# `A1.GL1Newton.FamilyField1` — the concrete `GL₁` family field `K₁ = Frac(ℤ[q^±, z^±])`

Binding statement of record: `sandboxv0a/informal/goalv0a.lock.json` (tex `91a50173…5a7e`).
Binding formal design: `sandboxv0a/M1_DESIGN.md` §(a), §(e) row 3.

## Why a concrete field (M1_DESIGN §(a).1)

`goalv0a` fixes `A_z = ℤ[q^{±1}, z^{±1}]` with **one** `z`, and `K_z = ℚ(q)[z^{±1}]`.  An abstract
`GL2Params K` would make the Lean `A_z` a different (possibly degenerate) ring, so the statement is
pinned over the concrete field

  `K₁ := Frac(𝓜₁)`,  `𝓜₁ := ℤ[q^±][z^±] = LaurentPolynomial (LaurentPolynomial ℤ)`.

Note `Frac(𝓜₁) = ℚ(q)(z) = Frac(A_z)`, which is exactly the base ring of the goal's
`U ⊗_{K_z} Frac(A_z)`; this is what makes the centre clause (ii) statable without modelling the
base change separately.

## The `z₂ := 1` reuse bridge (M1_DESIGN §(a).2, RECORDED)

A1's certified membership calculus (`AzSubring`, `nuNewton_zpow_grid_mem`, `gridCriterion`,
`X_pow_mem_span_newtonPolyK`, …) is stated over `[GL2Params K]`.  We install `GL2Params K₁` with
`z₁ := z`, `z₂ := 1`, so that

  `AzSubring K₁ = Subring.closure {q, q⁻¹, z, z⁻¹, 1, 1⁻¹} = ℤ[q^±, z^±]`

— the *exact* `GL₁` `A_z`.  `z₂ = 1` is an **internal reuse bridge, not a claim about a second
torus**: `Φ = ∅` at `GL₁`, so there are no Newton walls and the W-R2 degeneracy warning (which
barred `z₁ = z₂` for the two-variable wall arithmetic) does not apply.  Every reused lemma is
`z`-independent (it touches only `q`, `Q = q²` and `ℤ[q^±]`).

## Faithfulness

`az1_model_equiv : AzSubring K₁ ≃+* 𝓜₁` is the encoding-faithfulness witness: the subring named
`A_z` in the Lean statement really IS the free Laurent ring `ℤ[q^±, z^±]`.

## Status

Transcription of `A1/UQ/FamilyField.lean` with **one fewer Laurent layer**.  Complete and
`sorry`-free.
-/

open LaurentPolynomial

namespace HybridQuantumLean
namespace A1
namespace GL1Newton
namespace FamilyField1

open HybridQuantumLean.A1.Verma
open HybridQuantumLean.A1.Verma.GL2

/-! ## 0. Generic Laurent facts -/

/-- `C : R →+* R[T;T⁻¹]` is injective. -/
lemma C_inj {R : Type*} [CommRing R] : Function.Injective (C : R → LaurentPolynomial R) := by
  intro a b h
  rw [← single_eq_C, ← single_eq_C] at h
  exact Finsupp.single_injective 0 h

/-- The Laurent monomial `T k` is `≠ 1` for `k ≠ 0`. -/
lemma T_ne_one {R : Type*} [CommRing R] [Nontrivial R] (k : ℤ) (hk : k ≠ 0) :
    (T k : LaurentPolynomial R) ≠ 1 := by
  intro h
  have h2 : (T k : LaurentPolynomial R) k = (T (0 : ℤ) : LaurentPolynomial R) k := by
    rw [h, T_zero]
  rw [T_apply, T_apply, if_pos rfl, if_neg (Ne.symm hk)] at h2
  exact one_ne_zero h2

/-! ## 1. The model ring `𝓜₁` and the family field `K₁` -/

/-- `ℤ[q^±]` — the inner Laurent layer (variable `q`). -/
abbrev Rq : Type := LaurentPolynomial ℤ

/-- **The model ring** `𝓜₁ = ℤ[q^±][z^±]` (variable `z` outermost). -/
def Mdl1 : Type := LaurentPolynomial Rq

noncomputable instance : CommRing Mdl1 := inferInstanceAs (CommRing (LaurentPolynomial Rq))
instance : IsDomain Mdl1 := inferInstanceAs (IsDomain (LaurentPolynomial Rq))
instance : CharZero Mdl1 where
  cast_injective := by
    intro m n h
    change (C (C (m : ℤ)) : Mdl1) = C (C (n : ℤ)) at h
    have hZ : (m : ℤ) = (n : ℤ) := C_inj (C_inj h)
    exact_mod_cast hZ

/-- **The `GL₁` family field** `K₁ = Frac(ℤ[q^±, z^±]) = Frac(A_z)`. -/
noncomputable abbrev K1 : Type := FractionRing Mdl1

noncomputable instance : CharZero K1 := IsFractionRing.charZero_of_isFractionRing Mdl1

/-- The structural embedding `ι = algebraMap 𝓜₁ K₁`. -/
noncomputable def ι : Mdl1 →+* K1 := algebraMap Mdl1 K1

lemma ι_inj : Function.Injective ι := IsFractionRing.injective Mdl1 K1

/-! ## 2. The two Laurent variables -/

/-- `q ∈ 𝓜₁` — the inner Laurent variable, `C (T 1)`. -/
noncomputable def qMdl : Mdl1 := (C (T 1) : LaurentPolynomial Rq)
/-- `z ∈ 𝓜₁` — the outer Laurent variable, `T 1`. -/
noncomputable def zMdl : Mdl1 := (T 1 : LaurentPolynomial Rq)
/-- `q⁻¹ ∈ 𝓜₁`. -/
noncomputable def qInvMdl : Mdl1 := (C (T (-1)) : LaurentPolynomial Rq)
/-- `z⁻¹ ∈ 𝓜₁`. -/
noncomputable def zInvMdl : Mdl1 := (T (-1) : LaurentPolynomial Rq)

/-- `q ∈ K₁`. -/
noncomputable def qK : K1 := ι qMdl
/-- `z ∈ K₁`. -/
noncomputable def zK : K1 := ι zMdl

lemma qMdl_ne_zero : qMdl ≠ 0 := by
  have : IsUnit qMdl := ((isUnit_T (1 : ℤ)).map (C : Rq →+* Mdl1))
  exact this.ne_zero

lemma zMdl_ne_zero : zMdl ≠ 0 := (isUnit_T (1 : ℤ)).ne_zero

lemma qK_ne_zero : qK ≠ 0 := (map_ne_zero_iff ι ι_inj).mpr qMdl_ne_zero
lemma zK_ne_zero : zK ≠ 0 := (map_ne_zero_iff ι ι_inj).mpr zMdl_ne_zero

/-! ### `q`-power distinctness (the genericity engine) -/

lemma qK_natpow (j : ℕ) : qK ^ (j : ℤ) = ι (C (T (j : ℤ)) : Mdl1) := by
  have hpow : qMdl ^ j = (C (T (j : ℤ)) : Mdl1) := by
    change (C (T (1 : ℤ)) : Mdl1) ^ j = C (T (j : ℤ))
    rw [← map_pow (C : Rq →+* Mdl1), T_pow, mul_one]
  rw [zpow_natCast, qK, ← map_pow, hpow]

lemma qK_natpow_ne_one (j : ℕ) (hj : j ≠ 0) : qK ^ (j : ℤ) ≠ 1 := by
  rw [qK_natpow]
  intro h
  have hM : (C (T (j : ℤ)) : Mdl1) = 1 := ι_inj (h.trans (map_one ι).symm)
  have hM' : (C (T (j : ℤ)) : Mdl1) = C (T (0 : ℤ)) := by
    rw [hM, T_zero, map_one]
  have hjz : (T (j : ℤ) : Rq) = T (0 : ℤ) := C_inj hM'
  rw [T_zero] at hjz
  exact T_ne_one (j : ℤ) (by exact_mod_cast hj) hjz

lemma qK_zpow_ne_one (k : ℤ) (hk : k ≠ 0) : qK ^ k ≠ 1 := by
  rcases lt_or_gt_of_ne hk with hneg | hpos
  · obtain ⟨j, hj⟩ : ∃ j : ℕ, -k = (j : ℤ) := ⟨(-k).toNat, by omega⟩
    intro h
    refine qK_natpow_ne_one j (by omega) ?_
    rw [← hj, zpow_neg, h, inv_one]
  · obtain ⟨j, hj⟩ : ∃ j : ℕ, k = (j : ℤ) := ⟨k.toNat, by omega⟩
    rw [hj]; exact qK_natpow_ne_one j (by omega)

lemma qK_sq_ne_one : qK * qK ≠ 1 := by
  have h := qK_natpow_ne_one 2 (by norm_num)
  rwa [zpow_natCast, pow_two] at h

lemma qK_num_ne_zero {n : ℤ} (hn : n ≠ 0) : qK ^ n - qK ^ (-n) ≠ 0 := by
  intro hz
  have heq : qK ^ n = qK ^ (-n) := sub_eq_zero.mp hz
  have e1 : qK ^ n * qK ^ n = qK ^ (-n) * qK ^ n := by rw [heq]
  rw [← zpow_add₀ qK_ne_zero, ← zpow_add₀ qK_ne_zero, neg_add_cancel, zpow_zero,
    show n + n = 2 * n by ring] at e1
  exact qK_zpow_ne_one (2 * n) (by omega) e1

/-! ## 3. The `GL2Params` / `QGeneric` instances on `K₁` (the `z₂ := 1` reuse bridge) -/

/-- `K₁` carries `GL2Params` with `q, z₁ = z` the Laurent-variable images and **`z₂ := 1`**.
See the module docstring: `z₂ = 1` is an internal reuse bridge, not a second torus. -/
noncomputable instance instGL2ParamsK1 : GL2Params K1 where
  q := qK
  z := zK
  q_ne_zero := qK_ne_zero
  q_sq_ne_one := qK_sq_ne_one
  z1 := zK
  z2 := 1
  z1_ne_zero := zK_ne_zero
  z2_ne_zero := one_ne_zero
  z_eq := (mul_one _).symm

/-- `K₁` is `QGeneric` (`q^{2n} ≠ 1` for `n ≠ 0`). -/
noncomputable instance instQGenericK1 : QGeneric K1 where
  qInt_ne_zero n hn := by
    change (qK ^ n - qK ^ (-n)) / (qK - qK⁻¹) ≠ 0
    exact div_ne_zero (qK_num_ne_zero hn) (QFieldParams.q_sub_qinv_ne_zero)

/-! ## 4. Faithfulness: `A_z ≅ ℤ[q^±, z^±]` -/

/-- A Laurent ring is generated over its constants by `T (±1)`. -/
lemma laurentMem {S : Type*} [CommRing S] (f : LaurentPolynomial S →+* K1)
    (A : Subring K1) (hC : ∀ s : S, f (C s) ∈ A)
    (hT : f (T 1) ∈ A) (hTinv : f (T (-1)) ∈ A) : ∀ p, f p ∈ A := by
  intro p
  induction p using LaurentPolynomial.induction_on with
  | h_C a => exact hC a
  | h_add hp hq => rw [map_add]; exact A.add_mem hp hq
  | h_C_mul_T n a ih =>
      rw [T_add, ← mul_assoc, map_mul]; exact A.mul_mem ih hT
  | h_C_mul_T_Z n a ih =>
      rw [show (-(n : ℤ) - 1) = -(n : ℤ) + (-1) by ring, T_add, ← mul_assoc, map_mul]
      exact A.mul_mem ih hTinv

lemma ι_inv {a b : Mdl1} (h : a * b = 1) : ι b = (ι a)⁻¹ := by
  have hab : ι a * ι b = 1 := by rw [← map_mul, h, map_one]
  exact (inv_eq_of_mul_eq_one_right hab).symm

lemma qMdl_mul_inv : qMdl * qInvMdl = 1 := by
  have h : (C (T (1 : ℤ)) : LaurentPolynomial Rq) * C (T (-1)) = 1 := by
    rw [← map_mul (C : Rq →+* LaurentPolynomial Rq), ← T_add (R := ℤ),
      show (1 : ℤ) + -1 = 0 by ring, T_zero, map_one]
  exact h

lemma zMdl_mul_inv : zMdl * zInvMdl = 1 := by
  have h : (T (1 : ℤ) : LaurentPolynomial Rq) * T (-1) = 1 := by
    rw [← T_add (R := Rq), show (1 : ℤ) + -1 = 0 by ring, T_zero]
  exact h

lemma qK_mem : qK ∈ AzSubring (K := K1) := q_mem
lemma zK_mem : zK ∈ AzSubring (K := K1) := z1_mem

lemma qK_inv_mem : ι qInvMdl ∈ AzSubring (K := K1) := by
  rw [ι_inv qMdl_mul_inv]; exact q_inv_mem
lemma zK_inv_mem : ι zInvMdl ∈ AzSubring (K := K1) := by
  rw [ι_inv zMdl_mul_inv]; exact z1_inv_mem

/-- Inner layer: `ι (C a) ∈ A_z` for all `a : ℤ[q^±]`. -/
lemma mem_Ca (a : Rq) : ι (C a : Mdl1) ∈ AzSubring (K := K1) := by
  refine laurentMem (S := ℤ) (ι.comp (C : Rq →+* Mdl1)) (AzSubring (K := K1)) ?_ ?_ ?_ a
  · intro s
    rw [show (ι.comp (C : Rq →+* Mdl1)) (C s) = (s : K1) by
      rw [← RingHom.comp_apply, eq_intCast]]
    exact intCast_mem _ s
  · change ι qMdl ∈ _; exact qK_mem
  · change ι qInvMdl ∈ _; exact qK_inv_mem

/-- Full generation: `ι x ∈ A_z` for every `x : 𝓜₁`. -/
lemma ι_mem_azSubring (x : Mdl1) : ι x ∈ AzSubring (K := K1) := by
  refine laurentMem (S := Rq) ι (AzSubring (K := K1)) ?_ ?_ ?_ x
  · intro s; exact mem_Ca s
  · change ι zMdl ∈ _; exact zK_mem
  · change ι zInvMdl ∈ _; exact zK_inv_mem

/-- `ι.range = A_z`.  Note the `z₂ = 1` and `z₂⁻¹ = 1` generators are `ι 1`. -/
lemma ι_range_eq_azSubring : ι.range = AzSubring (K := K1) := by
  apply le_antisymm
  · rintro y hy
    obtain ⟨x, rfl⟩ := RingHom.mem_range.mp hy
    exact ι_mem_azSubring x
  · refine Subring.closure_le.mpr ?_
    intro y hy
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy
    rcases hy with rfl | rfl | rfl | rfl | rfl | rfl
    · exact RingHom.mem_range.mpr ⟨qMdl, rfl⟩
    · exact RingHom.mem_range.mpr ⟨qInvMdl, ι_inv qMdl_mul_inv⟩
    · exact RingHom.mem_range.mpr ⟨zMdl, rfl⟩
    · exact RingHom.mem_range.mpr ⟨zInvMdl, ι_inv zMdl_mul_inv⟩
    · exact RingHom.mem_range.mpr ⟨1, map_one ι⟩
    · exact RingHom.mem_range.mpr
        ⟨1, by rw [map_one, show (GL2Params.z2 : K1) = 1 from rfl, inv_one]⟩

/-- **`az1_model_equiv`** — the encoding-faithfulness witness: the coefficient subring `A_z ⊆ K₁`
named in the `goalv0a` statement is ring-isomorphic to the free bivariate Laurent model
`𝓜₁ = ℤ[q^±, z^±]`. -/
noncomputable def az1_model_equiv : AzSubring (K := K1) ≃+* Mdl1 :=
  ((RingEquiv.ofBijective ι.rangeRestrict
      ⟨fun _ _ h => ι_inj (Subtype.ext_iff.mp h), ι.rangeRestrict_surjective⟩).trans
    (RingEquiv.subringCongr ι_range_eq_azSubring)).symm

end FamilyField1
end GL1Newton
end A1
end HybridQuantumLean
