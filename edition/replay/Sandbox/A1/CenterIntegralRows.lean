import Sandbox.A1.CenterLattice
import Sandbox.A1.CenterSupport
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.BigOperators.Finsupp.Basic
import Mathlib.Algebra.Ring.GeomSum

set_option linter.style.header false

/-!
# A1 CENTER — ASM-5: INTEGRAL ROWS (the residues preserve the `A_z` coefficient lattice)

The v104 "paired-wall Newton divisibility" ingredient in polynomial form: the DCK
residues `d1p`/`d0p` (`A1/CenterPoly`), the translations `taup`, and hence ALL DCK rows
`dckRowP` (`A1/CenterSupport`) preserve the coefficient lattice
`coeffsInAz t = ∀ m, t.coeff m ∈ A_z` (`A_z = ℤ[q^{±1}, z₁^{±1}, z₂^{±1}]`,
`A1/CenterLattice`). In the shifted polynomial frame the wall divisibility is
LATTICE-TRIVIAL: no cyclotomic localization is needed — v104's cyclotomic subtlety
belongs entirely to the ASM-6 frame bridge (see the end of this docstring).

**Route.**
1. `coeffsInAz` + closure calculus (`add`/`neg`/`mul`/`pow`/`sum`/`C`/`X`/`monomial`/
   `smul`), all by direct coefficient formulas (`coeff_mul` + `Subring.sum_mem` etc.).
2. `d1p` is additive and `C`-linear (via `d1p_unique`), and on a monomial the quotient
   telescopes with ℤ-coefficients (`geom_sum₂_mul`):
   `d1p (Y₁^{b+n} Y₂^b) = Y₁^b Y₂^b · Σ_{i<n} Y₁^i Y₂^{n-1-i}` (`d1p_X_pow`), the
   `a < b` case by the involution `d1p (s1p f) = −d1p f`. Hence `coeffsInAz_d1p`
   — over ANY subring-coefficient lattice.
3. **THE DERIVED d0p–d1p RELATION** (CAS-pinned): with the single-variable scaling
   `sigp u : (Y₁,Y₂) ↦ (uY₁, Y₂)`,
   `d0p = sigp Q⁻¹ ∘ d1p ∘ sigp Q` (`d0p_eq_sigp_d1p_sigp`), because
   `sigp Q⁻¹ (wall1p) = wall0p` and `s0p = sigp Q⁻¹ ∘ s1p ∘ sigp Q`. The briefed
   τ-candidate `d0p t = taup (−1) (d1p (taup 1 t))` is **CAS-FALSE** and not fixable by
   any unit prefactor (coefficient ratios `1, q⁻², q⁻⁴` on the seed `Y₁³`): `taup`
   scales BOTH variables, so conjugating `wall1p` to `wall0p` would need the
   half-integer `τ^{1/2}`. `sigp` preserves the lattice for `u ∈ A_z`
   (unit-monomial coefficients), hence `coeffsInAz_d0p`.
4. `coeffsInAz_dckWordP` (induction over the alternating word) and the flagship
   **`coeffsInAz_dckRowP`**: the polynomial data of every DCK row of a lattice-integral
   seed is lattice-integral — the v104 "integral rows" ingredient. The row prefactor
   `C ((−q)^{⌊r/2⌋}) · τ^{−⌊r/2⌋}` is a lattice unit times a lattice-preserving
   substitution.

**CAS pin (warm REPL 127.0.0.1:9917, GL2 parent, scratch `asm5_pin.jl`, 2026-07-03):**
`p1/p1b` `d1p` monomial quotient (`b ≤ 3, n ≤ 5`) true; `p2/p2b` `d0p` monomial quotient
with `Q`-power coefficients true; `p3` σ-relation true; `p4` σ-swap-conjugation true;
`p5` τ-candidate false, `p5c` unit-fix false; `p6` involution negations true; `p7`
explicit coefficient inspection (seeds, `d1p`, `d0p`, `τ^{±1,±2}`, rows `r ≤ 5`) all
Laurent-integral in `q, z₁, z₂`; `p8` row-prefactor convention matches `dckRowP`.

**What ASM-6 (frame bridge) must add:** the equivalence between `coeffsInAz` of the
shifted-frame seed/rows here and the UNSHIFTED-frame Newton-grid integrality of the HC
image (`gridCriterion` + `nuNewton_eval_eq_qBinom` of `A1/CenterLattice`); the
shifted↔unshifted unit-monomial change of frame carries the λ-transcendence and the
cyclotomic bookkeeping. λ-carrying scalars (`eCoeffZ`, `Dscalar`, `[c;r]`-weights of
`rowVal`) are deliberately OUT of scope here: integral rows have λ-free coefficients
(docs/13), and this file certifies exactly that λ-free polynomial layer.
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace Verma
namespace GL2

open MvPolynomial

universe u

/-! ## Linearity of the finite residue and the telescoped monomial quotient -/

section SwapLayer

variable {K : Type u} [Field K]

/-- `s₁` fixes constants (companion to `s0p_C`/`taup_C` of `A1/CenterPoly`). -/
@[simp] theorem s1p_C (c : K) : s1p (K := K) (C c) = C c := by
  simp [s1p, algebraMap_eq]

/-- The finite residue is additive (by uniqueness of the exact quotient). -/
theorem d1p_add (f g : MvPolynomial (Fin 2) K) : d1p (f + g) = d1p f + d1p g := by
  refine (d1p_unique ?_).symm
  rw [mul_add, d1p_spec, d1p_spec, map_add]
  ring

/-- The finite residue is `C`-linear. -/
theorem d1p_C_mul (c : K) (f : MvPolynomial (Fin 2) K) : d1p (C c * f) = C c * d1p f := by
  refine (d1p_unique ?_).symm
  rw [mul_left_comm, d1p_spec, map_mul, s1p_C]
  ring

/-- The finite residue distributes over finite sums. -/
theorem d1p_sum {ι : Type*} (s : Finset ι) (f : ι → MvPolynomial (Fin 2) K) :
    d1p (∑ i ∈ s, f i) = ∑ i ∈ s, d1p (f i) := by
  induction s using Finset.cons_induction with
  | empty => simp
  | cons a s ha ih => rw [Finset.sum_cons, Finset.sum_cons, d1p_add, ih]

/-- Involution negation: `d1p (s₁ f) = −d1p f` (CAS pin `p6`). -/
theorem d1p_s1p (f : MvPolynomial (Fin 2) K) : d1p (s1p f) = -d1p f := by
  refine (d1p_unique ?_).symm
  rw [mul_neg, d1p_spec, s1p_s1p]
  ring

/-- Fin-2 monomials in `C`-times-`X`-powers form. -/
theorem monomial_eq_C_mul (m : Fin 2 →₀ ℕ) (c : K) :
    (monomial m c : MvPolynomial (Fin 2) K) = C c * (X 0 ^ m 0 * X 1 ^ m 1) := by
  rw [monomial_eq, Finsupp.prod_fintype _ _ fun i => pow_zero _, Fin.prod_univ_two]

/-- **Complete homogeneous telescoping against the finite wall** (CAS pin `p1`):
`(Y₁ − Y₂) · Y₁^b Y₂^b Σ_{i<n} Y₁^i Y₂^{n-1-i} = Y₁^{b+n} Y₂^b − Y₁^b Y₂^{b+n}` —
ℤ-coefficients, over any coefficient ring (`geom_sum₂_mul`). -/
theorem wall1p_mul_telescope (b n : ℕ) :
    wall1p (K := K) *
        (X 0 ^ b * X 1 ^ b * ∑ i ∈ Finset.range n, X 0 ^ i * X 1 ^ (n - 1 - i))
      = X 0 ^ (b + n) * X 1 ^ b - X 0 ^ b * X 1 ^ (b + n) := by
  have hg := geom_sum₂_mul (X 0 : MvPolynomial (Fin 2) K) (X 1) n
  calc wall1p (K := K) *
      (X 0 ^ b * X 1 ^ b * ∑ i ∈ Finset.range n, X 0 ^ i * X 1 ^ (n - 1 - i))
      = X 0 ^ b * X 1 ^ b *
          ((∑ i ∈ Finset.range n, X 0 ^ i * X 1 ^ (n - 1 - i)) * (X 0 - X 1)) := by
        simp only [wall1p]; ring
    _ = X 0 ^ b * X 1 ^ b * (X 0 ^ n - X 1 ^ n) := by rw [hg]
    _ = X 0 ^ (b + n) * X 1 ^ b - X 0 ^ b * X 1 ^ (b + n) := by
        rw [pow_add, pow_add]; ring

/-- The finite residue of a dominant monomial is the telescoped quotient
(exact-division identification through `d1p_unique`). -/
theorem d1p_X_pow (b n : ℕ) :
    d1p (X 0 ^ (b + n) * X 1 ^ b : MvPolynomial (Fin 2) K)
      = X 0 ^ b * X 1 ^ b * ∑ i ∈ Finset.range n, X 0 ^ i * X 1 ^ (n - 1 - i) := by
  refine (d1p_unique ?_).symm
  rw [wall1p_mul_telescope, map_mul, map_pow, map_pow, s1p_X0, s1p_X1]
  ring

/-! ## The single-variable scaling `sigp` (the honest `d0p`-vs-`d1p` conjugator) -/

/-- Single-variable scaling `σ_u : (Y₁,Y₂) ↦ (uY₁, Y₂)` as a `K`-algebra endomorphism.
NOT a `taup` (which scales both variables oppositely) — this is the substitution that
conjugates the finite wall calculus to the affine one (CAS pins `p3`/`p4`). -/
noncomputable def sigp (u : K) : MvPolynomial (Fin 2) K →ₐ[K] MvPolynomial (Fin 2) K :=
  aeval ![C u * X 0, X 1]

@[simp] theorem sigp_X0 (u : K) : sigp u (X 0) = C u * X 0 := by simp [sigp]

@[simp] theorem sigp_X1 (u : K) : sigp u (X 1) = X 1 := by simp [sigp]

@[simp] theorem sigp_C (u c : K) : sigp u (C c) = C c := by simp [sigp, algebraMap_eq]

/-- Scalings compose multiplicatively at the algebra-map level. -/
theorem sigp_comp_sigp (u v : K) :
    (sigp (K := K) u).comp (sigp v) = sigp (u * v) := by
  refine algHom_ext fun i => ?_
  fin_cases i
  · change sigp (K := K) u (sigp v (X 0)) = sigp (u * v) (X 0)
    rw [sigp_X0, map_mul, sigp_C, sigp_X0, sigp_X0, ← mul_assoc, ← C_mul, mul_comm v u]
  · change sigp (K := K) u (sigp v (X 1)) = sigp (u * v) (X 1)
    rw [sigp_X1, sigp_X1, sigp_X1]

/-- `σ_u ∘ σ_v = σ_{uv}`, pointwise. -/
theorem sigp_sigp (u v : K) (f : MvPolynomial (Fin 2) K) :
    sigp u (sigp v f) = sigp (u * v) f :=
  DFunLike.congr_fun (sigp_comp_sigp u v) f

/-- `σ_1 = id` at the algebra-map level. -/
theorem sigp_one_eq_id : sigp (1 : K) = AlgHom.id K (MvPolynomial (Fin 2) K) := by
  refine algHom_ext fun i => ?_
  fin_cases i <;> simp [sigp]

/-- Inverse scalings cancel: `σ_{u⁻¹} ∘ σ_u = id`, pointwise, for `u ≠ 0`. -/
theorem sigp_inv_sigp {u : K} (hu : u ≠ 0) (f : MvPolynomial (Fin 2) K) :
    sigp u⁻¹ (sigp u f) = f := by
  rw [sigp_sigp, inv_mul_cancel₀ hu]
  exact DFunLike.congr_fun sigp_one_eq_id f

end SwapLayer

/-! ## The affine layer: `σ`-conjugation identities (CAS pins `p3`/`p4`) -/

section AffineLayer

variable {K : Type u} [Field K] [P : QFieldParams K]

/-- The `σ_{Q⁻¹}`-image of the finite wall is the affine wall. -/
theorem sigp_wall1p : sigp ((P.q ^ 2)⁻¹) (wall1p (K := K)) = wall0p := by
  simp only [wall1p, wall0p, map_sub, sigp_X0, sigp_X1]

/-- Swap conjugation (CAS pin `p4`): `s₀ = σ_{Q⁻¹} ∘ s₁ ∘ σ_Q`. -/
theorem s0p_eq_sigp_s1p_sigp (f : MvPolynomial (Fin 2) K) :
    s0p f = sigp ((P.q ^ 2)⁻¹) (s1p (sigp (P.q ^ 2) f)) := by
  have h : (s0p : MvPolynomial (Fin 2) K →ₐ[K] MvPolynomial (Fin 2) K)
      = ((sigp ((P.q ^ 2)⁻¹)).comp s1p).comp (sigp (P.q ^ 2)) := by
    refine algHom_ext fun i => ?_
    fin_cases i
    · change s0p (K := K) (X 0) = sigp ((P.q ^ 2)⁻¹) (s1p (sigp (P.q ^ 2) (X 0)))
      rw [s0p_X0, sigp_X0, map_mul, s1p_C, s1p_X0, map_mul, sigp_C, sigp_X1]
    · change s0p (K := K) (X 1) = sigp ((P.q ^ 2)⁻¹) (s1p (sigp (P.q ^ 2) (X 1)))
      rw [s0p_X1, sigp_X1, s1p_X1, sigp_X0]
  exact DFunLike.congr_fun h f

/-- **THE DERIVED d0p–d1p RELATION** (CAS pin `p3`): `d0p = σ_{Q⁻¹} ∘ d1p ∘ σ_Q`.
The briefed τ-candidate `d0p t = taup (−1) (d1p (taup 1 t))` is CAS-FALSE (pin `p5`,
not unit-fixable, pin `p5c`): conjugating `wall1p` into `wall0p` by `taup` would need
the half-integer translation `τ^{1/2}`, which does not exist on the `Q`-lattice. -/
theorem d0p_eq_sigp_d1p_sigp (f : MvPolynomial (Fin 2) K) :
    d0p f = sigp ((P.q ^ 2)⁻¹) (d1p (sigp (P.q ^ 2) f)) := by
  have hQ : (P.q ^ 2 : K) ≠ 0 := pow_ne_zero 2 P.q_ne_zero
  refine (d0p_unique ?_).symm
  rw [← sigp_wall1p, ← map_mul, d1p_spec, map_sub, sigp_inv_sigp hQ,
    ← s0p_eq_sigp_s1p_sigp]

end AffineLayer

/-! ## The coefficient lattice `coeffsInAz` and its closure calculus -/

section Lattice

variable {K : Type u} [Field K] [G : GL2Params K]

/-- The coefficient lattice: every coefficient of `t` lies in
`A_z = ℤ[q^{±1}, z₁^{±1}, z₂^{±1}]` (`AzSubring` of `A1/CenterLattice`). -/
def coeffsInAz (t : MvPolynomial (Fin 2) K) : Prop :=
  ∀ m : Fin 2 →₀ ℕ, t.coeff m ∈ AzSubring (K := K)

theorem coeffsInAz_zero : coeffsInAz (0 : MvPolynomial (Fin 2) K) := fun m => by
  rw [coeff_zero]
  exact zero_mem _

theorem coeffsInAz_one : coeffsInAz (1 : MvPolynomial (Fin 2) K) := fun m => by
  rw [coeff_one]
  split
  · exact one_mem _
  · exact zero_mem _

theorem coeffsInAz_add {f g : MvPolynomial (Fin 2) K} (hf : coeffsInAz f)
    (hg : coeffsInAz g) : coeffsInAz (f + g) := fun m => by
  rw [coeff_add]
  exact add_mem (hf m) (hg m)

theorem coeffsInAz_neg {f : MvPolynomial (Fin 2) K} (hf : coeffsInAz f) :
    coeffsInAz (-f) := fun m => by
  rw [coeff_neg]
  exact neg_mem (hf m)

theorem coeffsInAz_C {c : K} (hc : c ∈ AzSubring (K := K)) :
    coeffsInAz (C c : MvPolynomial (Fin 2) K) := fun m => by
  rw [coeff_C]
  split
  · exact hc
  · exact zero_mem _

theorem coeffsInAz_X (i : Fin 2) : coeffsInAz (X i : MvPolynomial (Fin 2) K) := fun m => by
  rw [coeff_X']
  split
  · exact one_mem _
  · exact zero_mem _

theorem coeffsInAz_monomial (m : Fin 2 →₀ ℕ) {c : K} (hc : c ∈ AzSubring (K := K)) :
    coeffsInAz (monomial m c : MvPolynomial (Fin 2) K) := fun m' => by
  rw [coeff_monomial]
  split
  · exact hc
  · exact zero_mem _

/-- Products stay in the lattice (`coeff_mul` + antidiagonal sum membership). -/
theorem coeffsInAz_mul {f g : MvPolynomial (Fin 2) K} (hf : coeffsInAz f)
    (hg : coeffsInAz g) : coeffsInAz (f * g) := fun m => by
  rw [coeff_mul]
  exact Subring.sum_mem _ fun x _ => mul_mem (hf x.1) (hg x.2)

theorem coeffsInAz_pow {f : MvPolynomial (Fin 2) K} (hf : coeffsInAz f) (n : ℕ) :
    coeffsInAz (f ^ n) := by
  induction n with
  | zero => simpa using coeffsInAz_one
  | succ k ih =>
    rw [pow_succ]
    exact coeffsInAz_mul ih hf

theorem coeffsInAz_sum {ι : Type*} (s : Finset ι) (f : ι → MvPolynomial (Fin 2) K)
    (h : ∀ i ∈ s, coeffsInAz (f i)) : coeffsInAz (∑ i ∈ s, f i) := by
  revert h
  induction s using Finset.cons_induction with
  | empty => exact fun _ => by simpa using coeffsInAz_zero
  | cons a s ha ih =>
    intro h
    rw [Finset.sum_cons]
    exact coeffsInAz_add (h a (Finset.mem_cons_self a s))
      (ih fun i hi => h i (Finset.mem_cons_of_mem hi))

theorem coeffsInAz_smul {c : K} (hc : c ∈ AzSubring (K := K))
    {t : MvPolynomial (Fin 2) K} (ht : coeffsInAz t) : coeffsInAz (c • t) := by
  rw [smul_eq_C_mul]
  exact coeffsInAz_mul (coeffsInAz_C hc) ht

/-! ### `Q`-power memberships -/

theorem Q_mem : (G.q ^ 2 : K) ∈ AzSubring (K := K) := pow_mem (q_mem (K := K)) 2

theorem Q_inv_mem : ((G.q ^ 2 : K))⁻¹ ∈ AzSubring (K := K) := by
  rw [← inv_pow]
  exact pow_mem (q_inv_mem (K := K)) 2

theorem Q_zpow_mem (n : ℤ) : ((G.q ^ 2 : K) ^ n) ∈ AzSubring (K := K) :=
  zpow_mem_of_inv_mem Q_mem Q_inv_mem n

/-! ### Substitutions preserve the lattice -/

/-- Workhorse: a substitution with lattice-integral generator images preserves the
lattice (monomial expansion `as_sum` + closure calculus). -/
theorem coeffsInAz_aeval {g : Fin 2 → MvPolynomial (Fin 2) K} (hg : ∀ i, coeffsInAz (g i))
    {t : MvPolynomial (Fin 2) K} (ht : coeffsInAz t) : coeffsInAz (aeval g t) := by
  rw [t.as_sum, map_sum]
  refine coeffsInAz_sum _ _ fun m _ => ?_
  simp only [monomial_eq_C_mul, map_mul, map_pow, aeval_X, aeval_C, algebraMap_eq]
  exact coeffsInAz_mul (coeffsInAz_C (ht m))
    (coeffsInAz_mul (coeffsInAz_pow (hg 0) (m 0)) (coeffsInAz_pow (hg 1) (m 1)))

/-- `σ_u` preserves the lattice for `u ∈ A_z`. -/
theorem coeffsInAz_sigp {u : K} (hu : u ∈ AzSubring (K := K))
    {t : MvPolynomial (Fin 2) K} (ht : coeffsInAz t) : coeffsInAz (sigp u t) := by
  change coeffsInAz (aeval ![C u * X 0, X 1] t)
  refine coeffsInAz_aeval (fun i => ?_) ht
  fin_cases i
  · exact coeffsInAz_mul (coeffsInAz_C hu) (coeffsInAz_X 0)
  · exact coeffsInAz_X 1

/-- `τ^a` preserves the lattice (unit-monomial `Q^{±a}` coefficients). -/
theorem coeffsInAz_taup (a : ℤ) {t : MvPolynomial (Fin 2) K} (ht : coeffsInAz t) :
    coeffsInAz (taup a t) := by
  change coeffsInAz (aeval ![C ((G.q ^ 2) ^ a) * X 0, C ((G.q ^ 2) ^ (-a)) * X 1] t)
  refine coeffsInAz_aeval (fun i => ?_) ht
  fin_cases i
  · exact coeffsInAz_mul (coeffsInAz_C (Q_zpow_mem (K := K) a)) (coeffsInAz_X 0)
  · exact coeffsInAz_mul (coeffsInAz_C (Q_zpow_mem (K := K) (-a))) (coeffsInAz_X 1)

/-! ### THE DIVISION LEMMAS: the residues preserve the lattice -/

/-- Monomial case of the division lemma: `d1p` of a bare monomial has coefficients
`0, ±1` (telescoped quotient / involution negation), hence lattice-integral. -/
theorem coeffsInAz_d1p_X_pow (a b : ℕ) :
    coeffsInAz (d1p (X 0 ^ a * X 1 ^ b : MvPolynomial (Fin 2) K)) := by
  rcases le_total b a with h | h
  · obtain ⟨n, rfl⟩ : ∃ n, a = b + n := ⟨a - b, by omega⟩
    rw [d1p_X_pow]
    exact coeffsInAz_mul
      (coeffsInAz_mul (coeffsInAz_pow (coeffsInAz_X 0) b) (coeffsInAz_pow (coeffsInAz_X 1) b))
      (coeffsInAz_sum _ _ fun i _ =>
        coeffsInAz_mul (coeffsInAz_pow (coeffsInAz_X 0) i)
          (coeffsInAz_pow (coeffsInAz_X 1) (n - 1 - i)))
  · obtain ⟨n, rfl⟩ : ∃ n, b = a + n := ⟨b - a, by omega⟩
    have hs : (X 0 ^ a * X 1 ^ (a + n) : MvPolynomial (Fin 2) K)
        = s1p (X 0 ^ (a + n) * X 1 ^ a) := by
      rw [map_mul, map_pow, map_pow, s1p_X0, s1p_X1]
      ring
    rw [hs, d1p_s1p, d1p_X_pow]
    exact coeffsInAz_neg (coeffsInAz_mul
      (coeffsInAz_mul (coeffsInAz_pow (coeffsInAz_X 0) a) (coeffsInAz_pow (coeffsInAz_X 1) a))
      (coeffsInAz_sum _ _ fun i _ =>
        coeffsInAz_mul (coeffsInAz_pow (coeffsInAz_X 0) i)
          (coeffsInAz_pow (coeffsInAz_X 1) (n - 1 - i))))

/-- **DIVISION LEMMA, finite wall** (CAS pins `p1`/`p7`): `d1p` preserves the lattice.
The quotient by `Y₁ − Y₂` of an antisymmetrization telescopes with ℤ-coefficients —
over any coefficient subring. -/
theorem coeffsInAz_d1p {t : MvPolynomial (Fin 2) K} (ht : coeffsInAz t) :
    coeffsInAz (d1p t) := by
  rw [t.as_sum, d1p_sum]
  refine coeffsInAz_sum _ _ fun m _ => ?_
  rw [monomial_eq_C_mul, d1p_C_mul]
  exact coeffsInAz_mul (coeffsInAz_C (ht m)) (coeffsInAz_d1p_X_pow (m 0) (m 1))

/-- **DIVISION LEMMA, affine wall** (CAS pins `p2`/`p3`/`p7`): `d0p` preserves the
lattice, by `σ`-conjugation to `d1p` (`d0p_eq_sigp_d1p_sigp`). -/
theorem coeffsInAz_d0p {t : MvPolynomial (Fin 2) K} (ht : coeffsInAz t) :
    coeffsInAz (d0p t) := by
  rw [d0p_eq_sigp_d1p_sigp]
  exact coeffsInAz_sigp Q_inv_mem (coeffsInAz_d1p (coeffsInAz_sigp Q_mem ht))

/-! ### INTEGRAL WORDS AND ROWS (the v104 ingredient, polynomial form) -/

/-- The alternating DCK word preserves the lattice. -/
theorem coeffsInAz_dckWordP (r : ℕ) {t : MvPolynomial (Fin 2) K} (ht : coeffsInAz t) :
    coeffsInAz (dckWordP r t) := by
  induction r with
  | zero => simpa using ht
  | succ n ih =>
    rw [dckWordP_succ]
    split
    · exact coeffsInAz_d0p ih
    · exact coeffsInAz_d1p ih

/-- **INTEGRAL ROWS** (v104 "paired-wall Newton divisibility", polynomial form): every
DCK row of a lattice-integral seed is lattice-integral. This is the polynomial data of
`dckElem`; the ASM-6 frame bridge converts it into unshifted-frame Newton-grid
integrality of the HC image via `gridCriterion` (see the module docstring). -/
theorem coeffsInAz_dckRowP (r : ℕ) {t : MvPolynomial (Fin 2) K} (ht : coeffsInAz t) :
    coeffsInAz (dckRowP r t) := by
  unfold dckRowP
  exact coeffsInAz_mul (coeffsInAz_C (pow_mem (neg_mem (q_mem (K := K))) (r / 2)))
    (coeffsInAz_taup _ (coeffsInAz_dckWordP r ht))

/-- Concrete anchor: all DCK rows of every power-sum seed `Y₁ⁿ + Y₂ⁿ` are
lattice-integral. -/
theorem coeffsInAz_dckRowP_powerSum (n r : ℕ) :
    coeffsInAz (dckRowP r (X 0 ^ n + X 1 ^ n : MvPolynomial (Fin 2) K)) :=
  coeffsInAz_dckRowP r (coeffsInAz_add (coeffsInAz_pow (coeffsInAz_X 0) n)
    (coeffsInAz_pow (coeffsInAz_X 1) n))

end Lattice

end GL2
end Verma
end A1
end HybridQuantumLean
