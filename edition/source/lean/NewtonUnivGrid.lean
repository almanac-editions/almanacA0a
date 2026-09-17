import Sandbox.A1.CenterNewtonZ

set_option linter.style.header false
set_option linter.unusedSectionVars false

/-!
# `A1.GL1Newton.NewtonUnivGrid` — the `GL₁` even Newton lattice as a grid predicate

Binding statement of record: `sandboxv0a/informal/goalv0a.lock.json`
(tex `91a50173…5a7e`, `sandboxv0a/informal/goalv0a.tex`).
Binding informal proof: `sandboxv0a/informal/PROOFv0a.tex`.
Binding formal design: `sandboxv0a/M1_DESIGN.md`.
Binding naming concordance: `translate/v0aprep/v0a_newton_functions.jl` (namespace `GL1Newton`;
stems `Frame`, `nu`, `grid`, `nuGrid`, `Az`, `Newton`, `Laurent`).

## The frame (goalv0a §1, `goal_memory.md` traps)

`G = GL₁`: `Φ = ∅`, `W = {1}`, `Λ = ℤ`, `Q = q²`,
`A_z = ℤ[q^{±1}, z^{±1}]`, `K_z = ℚ(q)[z^{±1}]`.

* **`Λ = ℤ`, not `0`** — there IS a toral variable `Y̌`, so `Frame K = K[Y̌^{±1}]`.
* **No `q`-shift** — `2ρ = 0`, so `grid χ` sends `Y̌ ↦ Q^χ` with **no** `z` and no extra `Q^{±1}`.
  This is exactly A1's *unshifted* scalar layer (`nuNewton`, `nuNewton_zpow_grid_mem`); A1's shifted
  `evalGrid` (which carries `z₁⁻¹, z₂⁻¹`) is deliberately NOT used.
* **`W = {1}` proves nothing about Weyl invariance** — the `(−)^W` clause degenerates; see
  `GOALv0a.lean`.
* **`𝒩^ev ⊋ A_z[Y̌^±]`** — the predicate `Newton` (grid integrality) is strictly weaker than
  `Laurent` (coefficient integrality). Both are defined here so the gap is nameable; a "check"
  that finds them equal has a bug.

## Model (M1_DESIGN §(b))

`U` (the full family quantum `GL₁`) is the Laurent torus `K[(T⁺)^{±1}]` = `Torus K`; its even part
is `K[Y̌^{±1}]` = `Frame K`, embedded by `evenEmb : Y̌ ↦ (T⁺)²`. All Newton objects live on
`Frame K`; `evenEmb` records the inclusion `𝒩^ev ⊆ U` demanded by clause (i).

## Reuse

`nu` is the certified univariate Newton polynomial `CenterNewtonZ.newtonPolyK` at linear
coefficient `a = 1` (the *unshifted* case; A1 used `a = z₁/Q` or `a = z₂` to undo its shift).
`nuGrid` is `CenterNewton.nuNewton` on the unshifted multiplicative grid. Membership is A1's
`AzSubring` (`CenterLattice.lean:166`) — over the `GL₁` field the third generator is `z₂ = 1`, so
that subring is exactly `ℤ[q^±, z^±]` (see `FamilyField1.lean`).

## Status (M2)

Complete and `sorry`-free.  The bilateral grid membership `ν_r(Q^χ) ∈ A_z` (`Az_nuGrid`) is
**consumed, not reproved**: it is the certified `CenterNewtonZ.nuNewton_zpow_grid_mem`.
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

/-! ## 1. The ambient algebras (`goalv0a` Definition 1) -/

/-- **`U`** — the family quantum `GL₁`: the Laurent torus `K[(T⁺)^{±1}]`.
`goalv0a` Def 1: the monomials `(T⁺)^w`, `w ∈ ℤ`, form a `K_z`-basis, and `U` is commutative
(`Φ = ∅`, so there are no `e_i, F_i`). -/
abbrev Torus (K : Type u) [Field K] : Type u := LaurentPolynomial K

/-- **`GL1Newton.Frame`** — the even toral algebra `K[Y̌^{±1}]`, `Y̌ = (T⁺)²`
(`goalv0a` Def 2: "even toral element" = Laurent polynomial in `Y̌`). -/
abbrev Frame (K : Type u) [Field K] : Type u := LaurentPolynomial K

/-- The even toral variable `Y̌`. -/
noncomputable def Ycheck : Frame K := T 1

/-- The even embedding `K[Y̌^{±1}] ↪ U`, `Y̌ ↦ (T⁺)²` — this is what makes `𝒩^ev` a
subalgebra **of `U`** (clause (i)). -/
noncomputable def evenEmb : Frame K →+* Torus K :=
  LaurentPolynomial.eval₂ (LaurentPolynomial.C : K →+* Torus K) (isUnit_T (2 : ℤ)).unit

@[simp] theorem evenEmb_Ycheck : evenEmb (Ycheck (K := K)) = (T 2 : Torus K) := by
  simp [evenEmb, Ycheck, LaurentPolynomial.eval₂_T]

omit G in
/-- The value of the `n`-th power of the unit `T m` inside the torus: `(T m)^n = T (n·m)`.
(Mathlib's `Units.val_zpow_eq_zpow_val` needs `[DivisionMonoid α]`, which the Laurent ring is
not, so the two-sided `Int.induction_on` is done here.)

Used by `GOALv0a.evenEmb_T` and by `PresentedU` (where it identifies `(T⁺)^n` with `T n`).
Pure Laurent arithmetic: no `GL2Params` data is involved, hence the `omit`. -/
theorem val_unit_T_zpow (m n : ℤ) :
    ((((isUnit_T (m : ℤ)).unit : (Torus K)ˣ) ^ n : (Torus K)ˣ) : Torus K)
      = (T (n * m) : Torus K) := by
  have hu : ((isUnit_T (m : ℤ)).unit : (Torus K)ˣ) = unitOfInvertible (T m : Torus K) :=
    Units.ext (by rw [IsUnit.unit_spec]; rfl)
  have hval : ((unitOfInvertible (T m : Torus K) : (Torus K)ˣ) : Torus K) = T m := rfl
  have hinv : (((unitOfInvertible (T m : Torus K))⁻¹ : (Torus K)ˣ) : Torus K) = T (-m) := rfl
  rw [hu]
  induction n using Int.induction_on with
  | zero => simp
  | succ k ih =>
    rw [zpow_add_one, Units.val_mul, ih, hval, ← LaurentPolynomial.T_add]
    congr 1
    ring
  | pred k ih =>
    rw [zpow_sub_one, Units.val_mul, ih, hinv, ← LaurentPolynomial.T_add]
    congr 1
    ring

/-! ## 2. The unshifted grid `ev_χ` (`goalv0a` Def 2 / `PROOFv0a` §1 "Evaluations") -/

private theorem Qzpow_ne_zero (χ : ℤ) : ((G.q ^ 2 : K) ^ χ) ≠ 0 :=
  zpow_ne_zero _ (pow_ne_zero 2 G.q_ne_zero)

/-- **`GL1Newton.grid χ`** — the evaluation `ev_χ : K[Y̌^{±1}] → K`, the unique `K`-algebra
(hence `A_z`-linear) ring homomorphism with `ev_χ(Y̌) = Q^χ`, `Q = q²`.
**Unshifted and `z`-free** (`2ρ = 0`, trap 2). -/
noncomputable def grid (χ : ℤ) : Frame K →+* K :=
  LaurentPolynomial.eval₂ (RingHom.id K) (Units.mk0 ((G.q ^ 2 : K) ^ χ) (Qzpow_ne_zero χ))

@[simp] theorem grid_T (χ u : ℤ) :
    grid (G := G) χ (T u : Frame K) = ((G.q ^ 2 : K) ^ χ) ^ u := by
  unfold grid
  rw [LaurentPolynomial.eval₂_T, Units.val_zpow_eq_zpow_val, Units.val_mk0]

@[simp] theorem grid_C (χ : ℤ) (c : K) :
    grid (G := G) χ (LaurentPolynomial.C c : Frame K) = c := by
  unfold grid
  rw [LaurentPolynomial.eval₂_C, RingHom.id_apply]

@[simp] theorem grid_Ycheck (χ : ℤ) :
    grid (G := G) χ (Ycheck (K := K)) = (G.q ^ 2 : K) ^ χ := by
  rw [Ycheck, grid_T, zpow_one]

/-! ## 3. The Newton divided classes (`goalv0a` Def 5) -/

/-- **`GL1Newton.nu r`** — the Newton divided class `ν_r(X) = ∏_{t<r} (X − Q^t)/(Q^r − Q^t)`
as a polynomial, `ν_0 = 1`.  This is the certified `CenterNewtonZ.newtonPolyK` at linear
coefficient `a = 1` (unshifted). -/
noncomputable def nu (r : ℕ) : Polynomial K := newtonPolyK (G := G) (1 : K) r

/-- **`GL1Newton.nuGrid r χ`** — the grid value `ν_r(Q^χ)` (`PROOFv0a` `B_r(χ)`), `χ : ℤ`
(the grid is **bilateral**). -/
noncomputable def nuGrid (r : ℕ) (χ : ℤ) : K := nuNewton (K := K) r ((G.q ^ 2 : K) ^ χ)

/-- Bridge: on the image of `Polynomial.toLaurent` the grid map is ordinary polynomial
evaluation at `Q^χ`.  (Mathlib idiom: `LaurentPolynomial.eval₂_toLaurent`.) -/
theorem grid_toLaurent (χ : ℤ) (p : Polynomial K) :
    grid (G := G) χ (Polynomial.toLaurent p) = Polynomial.eval ((G.q ^ 2 : K) ^ χ) p := by
  unfold grid
  rw [LaurentPolynomial.eval₂_toLaurent, Units.val_mk0, Polynomial.eval₂_id]

/-- `ν_r` as a polynomial evaluates to the scalar Newton class `nuNewton r`. -/
theorem eval_nu (r : ℕ) (Y : K) :
    Polynomial.eval Y (nu (G := G) r) = nuNewton (K := K) r Y := by
  unfold nu newtonPolyK nuNewton
  rw [Polynomial.eval_prod]
  refine Finset.prod_congr rfl fun t _ => ?_
  simp [div_eq_mul_inv]

/-- `ν_r` evaluated on the grid is `nuGrid r χ`: the polynomial `nu r` and the scalar
`nuGrid r χ` agree under `grid χ` after `Polynomial.toLaurent`. -/
theorem grid_toLaurent_nu (r : ℕ) (χ : ℤ) :
    grid (G := G) χ (Polynomial.toLaurent (nu (G := G) r)) = nuGrid (G := G) r χ := by
  rw [grid_toLaurent, eval_nu]
  rfl

/-! ## 4. The coefficient predicates (`goalv0a` Def 2; trap 4) -/

/-- **`GL1Newton.Az c`** — `c ∈ A_z = ℤ[q^{±1}, z^{±1}]`. -/
def Az (c : K) : Prop := c ∈ AzSubring (K := K)

/-- **`GL1Newton.Newton f`** — membership in the even Newton lattice `𝒩^ev`:
`ev_χ(f) ∈ A_z` for **every** `χ ∈ ℤ` (`goalv0a` Def 2, verbatim). -/
def Newton (f : Frame K) : Prop := ∀ χ : ℤ, Az (G := G) (grid (G := G) χ f)

/-- **`GL1Newton.Laurent f`** — `f ∈ A_z[Y̌^{±1}]`, i.e. every Laurent coefficient is in `A_z`.
Recorded to name trap 4: `Laurent ⊊ Newton`, and that gap is exactly what `ν_r` supplies.
This is NOT the definition of `𝒩^ev`. -/
def Laurent (f : Frame K) : Prop := ∀ u : ℤ, Az (G := G) (f u)

/-! ## 5. The Newton generators `Y̌^u ν_r(Y̌)` (`goalv0a` clause (iii)) -/

/-- **`GL1Newton.nuGen u r`** — the shifted divided class `Y̌^u · ν_r(Y̌)`, `u : ℤ`, `r : ℕ`. -/
noncomputable def nuGen (u : ℤ) (r : ℕ) : Frame K :=
  T u * Polynomial.toLaurent (nu (G := G) r)

/-- The generating set `{ Y̌^u ν_r(Y̌) : u ∈ ℤ, r ≥ 0 }` of clause (iii). -/
def nuGenSet : Set (Frame K) := {p | ∃ (u : ℤ) (r : ℕ), p = nuGen (G := G) u r}

/-- The grid value of a generator: `ev_χ(Y̌^u ν_r(Y̌)) = Q^{uχ}·ν_r(Q^χ)`
(`PROOFv0a` Lemma 2). -/
theorem grid_nuGen (u : ℤ) (r : ℕ) (χ : ℤ) :
    grid (G := G) χ (nuGen (G := G) u r) = ((G.q ^ 2 : K) ^ χ) ^ u * nuGrid (G := G) r χ := by
  rw [nuGen, map_mul, grid_T, grid_toLaurent_nu]

/-! ## 6. Closure algebra of the grid predicate (pullback of a subring along a ring hom) -/

theorem Newton_zero : Newton (G := G) (0 : Frame K) := fun χ => by
  simp only [Az, map_zero]; exact zero_mem _

theorem Newton_one : Newton (G := G) (1 : Frame K) := fun χ => by
  simp only [Az, map_one]; exact one_mem _

theorem Newton_add {f g : Frame K} (hf : Newton (G := G) f) (hg : Newton (G := G) g) :
    Newton (G := G) (f + g) := fun χ => by
  simp only [Az, map_add]; exact add_mem (hf χ) (hg χ)

theorem Newton_neg {f : Frame K} (hf : Newton (G := G) f) : Newton (G := G) (-f) := fun χ => by
  simp only [Az, map_neg]; exact neg_mem (hf χ)

theorem Newton_mul {f g : Frame K} (hf : Newton (G := G) f) (hg : Newton (G := G) g) :
    Newton (G := G) (f * g) := fun χ => by
  simp only [Az, map_mul]; exact mul_mem (hf χ) (hg χ)

theorem Newton_sum {ι : Type*} (s : Finset ι) (f : ι → Frame K)
    (h : ∀ i ∈ s, Newton (G := G) (f i)) : Newton (G := G) (∑ i ∈ s, f i) := fun χ => by
  simp only [Az, map_sum]; exact Subring.sum_mem _ fun i hi => h i hi χ

/-- `A_z`-scalar closure. -/
theorem Newton_C_mul {c : K} (hc : c ∈ AzSubring (K := K)) {f : Frame K}
    (hf : Newton (G := G) f) : Newton (G := G) (LaurentPolynomial.C c * f) := fun χ => by
  simp only [Az, map_mul, grid_C]; exact mul_mem hc (hf χ)

/-- `A_z`-scalar closure, `•`-form (the shape consumed by `Submodule.span_induction`). -/
theorem Newton_smul {c : K} (hc : c ∈ AzSubring (K := K)) {f : Frame K}
    (hf : Newton (G := G) f) : Newton (G := G) (c • f) := by
  rw [LaurentPolynomial.smul_eq_C_mul]
  exact Newton_C_mul hc hf

/-! ## 7. The `⟸` leg of clause (iii): every generator is in `𝒩^ev` -/

/-- Generator integrality (`PROOFv0a` Lemma 1 + Lemma 2): `ν_r(Q^χ) ∈ A_z` for every
`χ : ℤ` — the certified bilateral grid membership `CenterNewtonZ.nuNewton_zpow_grid_mem`
(NOT reproved here). -/
theorem Az_nuGrid [QGeneric K] (r : ℕ) (χ : ℤ) : Az (G := G) (nuGrid (G := G) r χ) :=
  nuNewton_zpow_grid_mem r χ

/-- The grid unit `Q^{uχ} = (Q^χ)^u ∈ A_z`. -/
theorem Az_Qzpow_zpow (χ u : ℤ) : Az (G := G) (((G.q ^ 2 : K) ^ χ) ^ u) :=
  zpow_mem_of_inv_mem (Q_zpow_mem χ) (by rw [← zpow_neg]; exact Q_zpow_mem (-χ)) u

/-- Each generator `Y̌^u ν_r(Y̌)` lies in `𝒩^ev` (`PROOFv0a` Lemma 2). -/
theorem Newton_nuGen [QGeneric K] (u : ℤ) (r : ℕ) : Newton (G := G) (nuGen (G := G) u r) := by
  intro χ
  rw [Az, grid_nuGen]
  exact mul_mem (Az_Qzpow_zpow χ u) (Az_nuGrid r χ)

end GL1Newton
end A1
end HybridQuantumLean
