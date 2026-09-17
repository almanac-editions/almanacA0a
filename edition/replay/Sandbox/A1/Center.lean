import Sandbox.A1.QArith
import Mathlib.Algebra.Module.LinearMap.End
import Mathlib.LinearAlgebra.Finsupp.LinearCombination
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

set_option linter.style.header false

/-!
# A1 CENTER program, stage C0 — the GL₂ hybrid weight module and the Casimir

First file of the CENTER program (`sandboxv0/docs/11_center_program_v1.md`; log in
`docs/13_center_log.md`). Everything here is transcribed from the Julia sources and
CAS-verified BEFORE formalization (statement-pinned; see the C0 ledger in docs/13):

  * `src/A1/parent.jl :: parent_gl2_hybrid` — toral algebra `ℚ(q)(z₁,z₂)[T1p,T2p,T1m,T2m]`
    with `Tᵢ₊Tᵢ₋ = zᵢ`, `K₊ = T1p·T2m`, `K₋ = T1m·T2p`, `K₊K₋ = z₁z₂`.
  * `src/A1/toral.jl :: sigma_toral` (gl2 branch) — the σ-twist
    `T1p ↦ qⁿT1p, T2p ↦ q⁻ⁿT2p, T1m ↦ q⁻ⁿT1m, T2m ↦ qⁿT2m`, giving the generator ledger
    `T1p F = q⁻¹ F T1p`, `T2p F = q F T2p`, `T1m F = q F T1m`, `T2m F = q⁻¹ F T2m` and the
    mirrored `e`-rules.
  * `src/A1/multiplication.jl` — `[e,F] = K₊ − K₋` and the divided-power straightening.
  * `src/A1/gl2_casimir.jl` — `Ω = z₁⁻¹T1p² + q²z₂⁻¹T2p² + (q²−1)(z₁z₂)⁻¹·T1p·T2p·e·F`.

**What this file provides (the End-route substrate of stage C1).** The package has NO
GL₂ Verma; the generic weight module `M(λ₁,λ₂)` below was derived from the σ-ledger and
CAS-verified (numerically over ℚ, and symbolically by the Codex C0 run — see
`sandboxv0/scratch/gl2_center_c0_checks_out.md`): basis `v_c` (`c : ℕ`, `v_c = F^{(c)}v₀`),

  `T1p v_c = q^{−c}λ₁ v_c`, `T2p v_c = q^{c}λ₂ v_c`,
  `T1m v_c = z₁q^{c}λ₁⁻¹ v_c`, `T2m v_c = z₂q^{−c}λ₂⁻¹ v_c`,
  `F v_c = [c+1]_q v_{c+1}`, `e v₀ = 0`,
  `e v_c = (q^{1−c}·λ₁z₂λ₂⁻¹ − q^{c−1}·z₁λ₂λ₁⁻¹) v_{c−1}`.

**Flagship theorem (C2-lite):** the Casimir operator is the scalar
`ω = q²λ₁²z₁⁻¹ + λ₂²z₂⁻¹` times the identity (`gl2_casimir_eq_smul_one`), hence commutes
with all six generator operators. This is OPERATOR-level centrality on `M(λ₁,λ₂)`;
upgrading to centrality in the abstract algebra is stage C1 (PBW-freeness/faithfulness).

**Design decision (C0 review item):** `GL2Params extends QFieldParams` with
`z_eq : z = z₁·z₂` — the sl₂-torus data `(q, z)` of `Verma.lean` is the composite
`(q, z₁z₂)` of the GL₂ family, so the entire certified q-arithmetic layer applies to the
GL₂ module with no convention bridge. The weights `λ₁, λ₂` are FREE field elements
(the family/generic point), not integral powers of `q`; the sl₂-Verma of `Verma.lean` is
the specialisation `q^r = λ₁z₂λ₂⁻¹` (CAS check R7).
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace Verma

open QFieldParams

universe u

/-- Parameters of the GL₂ hybrid family: the sl₂ pair `(q, z)` of `QFieldParams`
refined by the split-torus parameters `z₁, z₂` with `z = z₁z₂`
(`parent_gl2_hybrid`: `K₊K₋ = z₁z₂`). -/
class GL2Params (K : Type u) [Field K] extends QFieldParams K where
  z1 : K
  z2 : K
  z1_ne_zero : z1 ≠ 0
  z2_ne_zero : z2 ≠ 0
  z_eq : z = z1 * z2

namespace GL2

variable {K : Type u} [Field K] [G : GL2Params K]

/-! ## The generic weight module `M(λ₁,λ₂)` — scalar ladders -/

/-- `T1p`-eigenvalue on `v_c`: `q^{−c}λ₁`. -/
noncomputable def t1p (lam1 : K) (c : ℕ) : K := G.q ^ (-(c : ℤ)) * lam1

/-- `T2p`-eigenvalue on `v_c`: `q^{c}λ₂`. -/
noncomputable def t2p (lam2 : K) (c : ℕ) : K := G.q ^ (c : ℤ) * lam2

/-- `T1m`-eigenvalue on `v_c`: `z₁q^{c}λ₁⁻¹` (so `T1p·T1m = z₁` holds on every `v_c`). -/
noncomputable def t1m (lam1 : K) (c : ℕ) : K := G.z1 * G.q ^ (c : ℤ) * lam1⁻¹

/-- `T2m`-eigenvalue on `v_c`: `z₂q^{−c}λ₂⁻¹` (so `T2p·T2m = z₂` holds on every `v_c`). -/
noncomputable def t2m (lam2 : K) (c : ℕ) : K := G.z2 * G.q ^ (-(c : ℤ)) * lam2⁻¹

/-- `e`-step scalar `E(c)` lowering `v_c → v_{c−1}`:
`E(c) = q^{1−c}·λ₁z₂λ₂⁻¹ − q^{c−1}·z₁λ₂λ₁⁻¹` (from `e·F^{(c)} = F^{(c)}e +
F^{(c−1)}(q^{1−c}K₊ − q^{c−1}K₋)` applied to `v₀`). -/
noncomputable def eCoeff (lam1 lam2 : K) (c : ℕ) : K :=
  G.q ^ (1 - (c : ℤ)) * (lam1 * G.z2 * lam2⁻¹) - G.q ^ ((c : ℤ) - 1) * (G.z1 * lam2 * lam1⁻¹)

/-- `e`-action on basis vectors (`e v₀ = 0`). -/
noncomputable def eAct (lam1 lam2 : K) : ℕ → VermaSpace K
  | 0 => 0
  | c + 1 => eCoeff lam1 lam2 (c + 1) • VermaSpace.basis c

/-! ## The generator operators on `M(λ₁,λ₂)` -/

/-- Diagonal operator with eigenvalue ladder `d : ℕ → K`. -/
noncomputable def diagOp (d : ℕ → K) : Module.End K (VermaSpace K) :=
  Finsupp.linearCombination K fun c => d c • VermaSpace.basis c

omit G in
@[simp] theorem diagOp_basis (d : ℕ → K) (c : ℕ) :
    diagOp d (VermaSpace.basis c) = d c • VermaSpace.basis c := by
  simp [diagOp, VermaSpace.basis]

/-- `T1p` as an operator. -/
noncomputable def T1pOp (lam1 : K) : Module.End K (VermaSpace K) := diagOp (t1p lam1)

/-- `T2p` as an operator. -/
noncomputable def T2pOp (lam2 : K) : Module.End K (VermaSpace K) := diagOp (t2p lam2)

/-- `T1m` as an operator. -/
noncomputable def T1mOp (lam1 : K) : Module.End K (VermaSpace K) := diagOp (t1m lam1)

/-- `T2m` as an operator. -/
noncomputable def T2mOp (lam2 : K) : Module.End K (VermaSpace K) := diagOp (t2m lam2)

/-- `F` as an operator: `F v_c = [c+1]_q v_{c+1}` (divided-power basis ladder). -/
noncomputable def FOp : Module.End K (VermaSpace K) :=
  Finsupp.linearCombination K fun c => qInt (K := K) (c + 1) • VermaSpace.basis (c + 1)

/-- `e` as an operator. -/
noncomputable def eOp (lam1 lam2 : K) : Module.End K (VermaSpace K) :=
  Finsupp.linearCombination K (eAct lam1 lam2)

/-- `K₊ = T1p·T2m` as an operator (composite, faithful to `parent_gl2_hybrid`). -/
noncomputable def KpOp (lam1 lam2 : K) : Module.End K (VermaSpace K) :=
  T1pOp lam1 * T2mOp lam2

/-- `K₋ = T1m·T2p` as an operator. -/
noncomputable def KmOp (lam1 lam2 : K) : Module.End K (VermaSpace K) :=
  T1mOp lam1 * T2pOp lam2

@[simp] theorem FOp_basis (c : ℕ) :
    FOp (K := K) (VermaSpace.basis c) = qInt (K := K) (c + 1) • VermaSpace.basis (c + 1) := by
  simp [FOp, VermaSpace.basis]

@[simp] theorem eOp_basis_zero (lam1 lam2 : K) : eOp lam1 lam2 (VermaSpace.basis 0) = 0 := by
  simp [eOp, VermaSpace.basis, eAct]

@[simp] theorem eOp_basis_succ (lam1 lam2 : K) (c : ℕ) :
    eOp lam1 lam2 (VermaSpace.basis (c + 1))
      = eCoeff lam1 lam2 (c + 1) • VermaSpace.basis c := by
  simp [eOp, VermaSpace.basis, eAct]

omit G in
/-- Operators on `VermaSpace K` are equal iff they agree on all basis vectors. -/
theorem end_ext {f g : Module.End K (VermaSpace K)}
    (h : ∀ c, f (VermaSpace.basis c) = g (VermaSpace.basis c)) : f = g := by
  refine Finsupp.lhom_ext fun c b => ?_
  have hb : (Finsupp.single c b : VermaSpace K) = b • VermaSpace.basis c := by
    simp [VermaSpace.basis, Finsupp.smul_single]
  rw [hb, map_smul, map_smul, h c]

/-! ## The σ-ledger, operator level (CAS checks R2) -/

theorem rel_T1p_F (lam1 : K) :
    T1pOp (K := K) lam1 * FOp = G.q⁻¹ • (FOp * T1pOp lam1) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  simp only [Module.End.mul_apply, LinearMap.smul_apply, FOp_basis, T1pOp, diagOp_basis,
    map_smul, smul_smul, t1p]
  congr 1
  rw [show ((c : ℕ) + 1 : ℕ) = c + 1 from rfl]
  push_cast
  rw [neg_add, zpow_add₀ hq]
  simp only [zpow_neg, zpow_one]
  ring

theorem rel_T2p_F (lam2 : K) :
    T2pOp (K := K) lam2 * FOp = G.q • (FOp * T2pOp lam2) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  simp only [Module.End.mul_apply, LinearMap.smul_apply, FOp_basis, T2pOp, diagOp_basis,
    map_smul, smul_smul, t2p]
  congr 1
  push_cast
  rw [zpow_add₀ hq, zpow_one]
  ring

theorem rel_T1m_F (lam1 : K) :
    T1mOp (K := K) lam1 * FOp = G.q • (FOp * T1mOp lam1) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  simp only [Module.End.mul_apply, LinearMap.smul_apply, FOp_basis, T1mOp, diagOp_basis,
    map_smul, smul_smul, t1m]
  congr 1
  push_cast
  rw [zpow_add₀ hq, zpow_one]
  ring

theorem rel_T2m_F (lam2 : K) :
    T2mOp (K := K) lam2 * FOp = G.q⁻¹ • (FOp * T2mOp lam2) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  simp only [Module.End.mul_apply, LinearMap.smul_apply, FOp_basis, T2mOp, diagOp_basis,
    map_smul, smul_smul, t2m]
  congr 1
  push_cast
  rw [neg_add, zpow_add₀ hq]
  simp only [zpow_neg, zpow_one]
  ring

theorem rel_e_T1p (lam1 lam2 : K) :
    eOp (K := K) lam1 lam2 * T1pOp lam1 = G.q⁻¹ • (T1pOp lam1 * eOp lam1 lam2) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  cases c with
  | zero => simp [Module.End.mul_apply, T1pOp, diagOp_basis, map_smul]
  | succ c =>
    simp only [Module.End.mul_apply, LinearMap.smul_apply, T1pOp, diagOp_basis, map_smul,
      eOp_basis_succ, smul_smul, t1p]
    congr 1
    push_cast
    rw [neg_add, zpow_add₀ hq]
    simp only [zpow_neg, zpow_one]
    ring

theorem rel_e_T2p (lam1 lam2 : K) :
    eOp (K := K) lam1 lam2 * T2pOp lam2 = G.q • (T2pOp lam2 * eOp lam1 lam2) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  cases c with
  | zero => simp [Module.End.mul_apply, T2pOp, diagOp_basis, map_smul]
  | succ c =>
    simp only [Module.End.mul_apply, LinearMap.smul_apply, T2pOp, diagOp_basis, map_smul,
      eOp_basis_succ, smul_smul, t2p]
    congr 1
    push_cast
    rw [zpow_add₀ hq, zpow_one]
    ring

theorem rel_e_T1m (lam1 lam2 : K) :
    eOp (K := K) lam1 lam2 * T1mOp lam1 = G.q • (T1mOp lam1 * eOp lam1 lam2) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  cases c with
  | zero => simp [Module.End.mul_apply, T1mOp, diagOp_basis, map_smul]
  | succ c =>
    simp only [Module.End.mul_apply, LinearMap.smul_apply, T1mOp, diagOp_basis, map_smul,
      eOp_basis_succ, smul_smul, t1m]
    congr 1
    push_cast
    rw [zpow_add₀ hq, zpow_one]
    ring

theorem rel_e_T2m (lam1 lam2 : K) :
    eOp (K := K) lam1 lam2 * T2mOp lam2 = G.q⁻¹ • (T2mOp lam2 * eOp lam1 lam2) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  cases c with
  | zero => simp [Module.End.mul_apply, T2mOp, diagOp_basis, map_smul]
  | succ c =>
    simp only [Module.End.mul_apply, LinearMap.smul_apply, T2mOp, diagOp_basis, map_smul,
      eOp_basis_succ, smul_smul, t2m]
    congr 1
    push_cast
    rw [neg_add, zpow_add₀ hq]
    simp only [zpow_neg, zpow_one]
    ring

/-! ## Toral normal form and the defining relation `[e,F] = K₊ − K₋` -/

/-- `T1p·T1m = z₁` on the module (the normal-form reduction of `parent_gl2_hybrid`). -/
theorem rel_T1p_T1m (lam1 : K) (hl1 : lam1 ≠ 0) :
    T1pOp (K := K) lam1 * T1mOp lam1 = G.z1 • (1 : Module.End K (VermaSpace K)) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  have hqc : G.q ^ (c : ℤ) ≠ 0 := zpow_ne_zero _ hq
  simp only [Module.End.mul_apply, LinearMap.smul_apply, Module.End.one_apply, T1pOp, T1mOp,
    diagOp_basis, map_smul, smul_smul, t1p, t1m]
  congr 1
  rw [zpow_neg]
  field_simp

/-- `T2p·T2m = z₂` on the module. -/
theorem rel_T2p_T2m (lam2 : K) (hl2 : lam2 ≠ 0) :
    T2pOp (K := K) lam2 * T2mOp lam2 = G.z2 • (1 : Module.End K (VermaSpace K)) := by
  refine end_ext fun c => ?_
  have hq : G.q ≠ 0 := G.q_ne_zero
  have hqc : G.q ^ (c : ℤ) ≠ 0 := zpow_ne_zero _ hq
  simp only [Module.End.mul_apply, LinearMap.smul_apply, Module.End.one_apply, T2pOp, T2mOp,
    diagOp_basis, map_smul, smul_smul, t2p, t2m]
  congr 1
  rw [zpow_neg]
  field_simp

/-- The defining relation on the module: `e·F − F·e = K₊ − K₋`
(scalar core: `[c+1]E(c+1) − [c]E(c) = q^{−2c}λ₁z₂λ₂⁻¹ − q^{2c}z₁λ₂λ₁⁻¹`; CAS check R6b). -/
theorem rel_e_F (lam1 lam2 : K) (hl1 : lam1 ≠ 0) (hl2 : lam2 ≠ 0) :
    eOp (K := K) lam1 lam2 * FOp - FOp * eOp lam1 lam2 = KpOp lam1 lam2 - KmOp lam1 lam2 := by
  have hq : G.q ≠ 0 := G.q_ne_zero
  have hd : G.q - G.q⁻¹ ≠ 0 := q_sub_qinv_ne_zero
  have hq2 : G.q ^ 2 - 1 ≠ 0 := fun h => G.q_sq_ne_one (by rw [← sq]; exact sub_eq_zero.mp h)
  refine end_ext fun c => ?_
  cases c with
  | zero =>
    simp only [LinearMap.sub_apply, Module.End.mul_apply, FOp_basis, map_smul,
      eOp_basis_succ, eOp_basis_zero, map_zero, KpOp, KmOp, T1pOp, T2mOp, T1mOp, T2pOp,
      diagOp_basis, smul_smul, sub_zero]
    rw [← sub_smul]
    congr 1
    simp only [eCoeff, t1p, t2m, t1m, t2p, qInt]
    push_cast
    norm_num
    field_simp
  | succ c =>
    have hqc : G.q ^ (c : ℤ) ≠ 0 := zpow_ne_zero _ hq
    simp only [LinearMap.sub_apply, Module.End.mul_apply, FOp_basis, map_smul,
      eOp_basis_succ, KpOp, KmOp, T1pOp, T2mOp, T1mOp, T2pOp, diagOp_basis, smul_smul]
    rw [← sub_smul, ← sub_smul]
    congr 1
    simp only [eCoeff, t1p, t2m, t1m, t2p, qInt]
    push_cast
    have eg : G.q ^ ((c : ℤ) + 1) = G.q ^ (c : ℤ) * G.q := by
      rw [zpow_add₀ hq, zpow_one]
    have ea : G.q ^ ((c : ℤ) + 1 + 1) = G.q ^ (c : ℤ) * (G.q * G.q) := by
      rw [zpow_add₀ hq, eg, zpow_one, mul_assoc]
    have eb : G.q ^ (-((c : ℤ) + 1 + 1)) = (G.q ^ (c : ℤ) * (G.q * G.q))⁻¹ := by
      rw [zpow_neg, ea]
    have ec : G.q ^ (1 - ((c : ℤ) + 1 + 1)) = (G.q ^ (c : ℤ) * G.q)⁻¹ := by
      rw [show (1 - ((c : ℤ) + 1 + 1)) = -((c : ℤ) + 1) by ring, zpow_neg, eg]
    have ed : G.q ^ ((c : ℤ) + 1 + 1 - 1) = G.q ^ (c : ℤ) * G.q := by
      rw [show ((c : ℤ) + 1 + 1 - 1) = (c : ℤ) + 1 by ring, eg]
    have ee : G.q ^ (1 - ((c : ℤ) + 1)) = (G.q ^ (c : ℤ))⁻¹ := by
      rw [show (1 - ((c : ℤ) + 1)) = -(c : ℤ) by ring, zpow_neg]
    have ef : G.q ^ ((c : ℤ) + 1 - 1) = G.q ^ (c : ℤ) := by
      rw [show ((c : ℤ) + 1 - 1) = (c : ℤ) by ring]
    have eh : G.q ^ (-((c : ℤ) + 1)) = (G.q ^ (c : ℤ) * G.q)⁻¹ := by
      rw [zpow_neg, eg]
    rw [ea, eb, ec, ed, ee, ef, eh, eg]
    field_simp
    ring

/-! ## The Casimir (CAS checks R5, R6d) -/

/-- The GL₂ Casimir as an operator on `M(λ₁,λ₂)` — transcription of `gl2_casimir.jl`:
`Ω = z₁⁻¹T1p² + q²z₂⁻¹T2p² + (q²−1)(z₁z₂)⁻¹·T1p·T2p·e·F`. -/
noncomputable def casimirOp (lam1 lam2 : K) : Module.End K (VermaSpace K) :=
  G.z1⁻¹ • (T1pOp lam1 * T1pOp lam1)
    + (G.q ^ 2 * G.z2⁻¹) • (T2pOp lam2 * T2pOp lam2)
    + ((G.q ^ 2 - 1) * (G.z1 * G.z2)⁻¹) •
        (T1pOp lam1 * (T2pOp lam2 * (eOp lam1 lam2 * FOp)))

/-- The Casimir scalar `ω = q²λ₁²z₁⁻¹ + λ₂²z₂⁻¹` (CAS: `w(c) = w(0)` for all `c`,
closed form verified). -/
noncomputable def casimirScalar (lam1 lam2 : K) : K :=
  G.q ^ 2 * lam1 ^ 2 * G.z1⁻¹ + lam2 ^ 2 * G.z2⁻¹

/-- **FLAGSHIP (C2-lite).** The Casimir acts on the generic weight module as the scalar
`ω = q²λ₁²z₁⁻¹ + λ₂²z₂⁻¹` times the identity. Operator-level centrality follows;
centrality in the abstract algebra is stage C1 (via PBW-faithfulness of `M(λ₁,λ₂)`). -/
theorem casimir_eq_smul_one (lam1 lam2 : K) (hl1 : lam1 ≠ 0) (hl2 : lam2 ≠ 0) :
    casimirOp (K := K) lam1 lam2
      = casimirScalar lam1 lam2 • (1 : Module.End K (VermaSpace K)) := by
  have hq : G.q ≠ 0 := G.q_ne_zero
  have hd : G.q - G.q⁻¹ ≠ 0 := q_sub_qinv_ne_zero
  have hq2 : G.q ^ 2 - 1 ≠ 0 := fun h => G.q_sq_ne_one (by rw [← sq]; exact sub_eq_zero.mp h)
  have hz1 : G.z1 ≠ 0 := G.z1_ne_zero
  have hz2 : G.z2 ≠ 0 := G.z2_ne_zero
  refine end_ext fun c => ?_
  have hqc : G.q ^ (c : ℤ) ≠ 0 := zpow_ne_zero _ hq
  simp only [casimirOp, LinearMap.add_apply, LinearMap.smul_apply, Module.End.mul_apply,
    Module.End.one_apply, T1pOp, T2pOp, diagOp_basis, map_smul, FOp_basis, eOp_basis_succ,
    smul_smul, casimirScalar]
  rw [← add_smul, ← add_smul]
  congr 1
  simp only [eCoeff, t1p, t2p, qInt]
  push_cast
  have e6 : G.q ^ ((c : ℤ) + 1) = G.q ^ (c : ℤ) * G.q := by
    rw [zpow_add₀ hq, zpow_one]
  have e3 : G.q ^ (1 - ((c : ℤ) + 1)) = (G.q ^ (c : ℤ))⁻¹ := by
    rw [show (1 - ((c : ℤ) + 1)) = -(c : ℤ) by ring, zpow_neg]
  have e4 : G.q ^ ((c : ℤ) + 1 - 1) = G.q ^ (c : ℤ) := by
    rw [show ((c : ℤ) + 1 - 1) = (c : ℤ) by ring]
  have e5 : G.q ^ (-(c : ℤ)) = (G.q ^ (c : ℤ))⁻¹ := zpow_neg _ _
  have e7 : G.q ^ (-((c : ℤ) + 1)) = (G.q ^ (c : ℤ) * G.q)⁻¹ := by
    rw [zpow_neg, e6]
  rw [e6, e3, e4, e5, e7]
  field_simp
  ring

/-- The Casimir commutes with every operator (it is a scalar). -/
theorem casimir_commute (lam1 lam2 : K) (hl1 : lam1 ≠ 0) (hl2 : lam2 ≠ 0)
    (g : Module.End K (VermaSpace K)) : Commute (casimirOp (K := K) lam1 lam2) g := by
  rw [casimir_eq_smul_one lam1 lam2 hl1 hl2]
  exact (Commute.one_left g).smul_left _

/-! ## Harish–Chandra via the vacuum matrix coefficient (GL₂, family form)

Canonical source: `notes/even_hybrid_center_definition_conjecture_2026-07-02.tex`
(§ shifted Harish–Chandra variables; Theorem thm:gl2). On a PBW element
`Σ_j F^{(j)} t_j e^j` the vacuum vector `v₀` kills every row `j ≥ 1` (`e v₀ = 0`), so
the `v₀`-matrix coefficient reads off exactly the height-zero toral part evaluated at
the family point `(λ₁,λ₂)` — the Harish–Chandra image in the matrix-coefficient
(Kamnitzer–Tingley) picture. The λ's are FREE, so the λ-dependence carries the full
toral function. -/

omit G in
/-- The vacuum matrix coefficient `x ↦ ⟨v₀, x·v₀⟩` (coefficient of `v₀` in `x·v₀`). -/
noncomputable def hcVac : Module.End K (VermaSpace K) →ₗ[K] K where
  toFun x := (x (VermaSpace.basis 0)) 0
  map_add' x y := by simp
  map_smul' a x := by simp

omit G in
@[simp] theorem hcVac_diagOp (d : ℕ → K) : hcVac (diagOp (K := K) d) = d 0 := by
  rw [show hcVac (diagOp (K := K) d) = ((diagOp (K := K) d) (VermaSpace.basis 0)) 0 from rfl,
    diagOp_basis]
  simp [VermaSpace.basis]

omit G in
@[simp] theorem hcVac_one : hcVac (1 : Module.End K (VermaSpace K)) = 1 := by
  simp [hcVac, VermaSpace.basis]

/-- Shifted Harish–Chandra variable `Y₁ˢ = Q^{2−1}·z₁⁻¹·(T₁⁺)²` at the vacuum:
`Y₁ˢ(v₀) = q²λ₁²z₁⁻¹` (tex: `Y_a = Q^{n−a} z_a⁻¹ (T_a⁺)²`, `n = 2`). -/
noncomputable def Y1sh (lam1 : K) : K := G.q ^ 2 * lam1 ^ 2 * G.z1⁻¹

/-- Shifted Harish–Chandra variable `Y₂ˢ = Q^{0}·z₂⁻¹·(T₂⁺)²` at the vacuum:
`Y₂ˢ(v₀) = λ₂²z₂⁻¹`. -/
noncomputable def Y2sh (lam2 : K) : K := lam2 ^ 2 * G.z2⁻¹

/-- **HC of the Casimir** — the Harish–Chandra image of `Ω` is the first elementary
symmetric function of the shifted variables, `HC(Ω) = Y₁ˢ + Y₂ˢ`: manifestly invariant
under the shifted Weyl swap `s₁ : Y₁ˢ ↔ Y₂ˢ`, exactly the shape of the target
isomorphism `HC : Z(U^{hyb,ev}) ≅ (N^ev)^{s₁}` (thm:gl2). -/
theorem hcVac_casimir (lam1 lam2 : K) (hl1 : lam1 ≠ 0) (hl2 : lam2 ≠ 0) :
    hcVac (casimirOp (K := K) lam1 lam2) = Y1sh lam1 + Y2sh lam2 := by
  rw [casimir_eq_smul_one lam1 lam2 hl1 hl2, map_smul, hcVac_one, smul_eq_mul, mul_one]
  rfl

omit G in
/-- The shifted-Weyl swap invariance of the Casimir's HC shape (`e₁` is symmetric). -/
theorem e1_shifted_weyl_symm (y1 y2 : K) : y1 + y2 = y2 + y1 := add_comm y1 y2

/-! ## Divided-power row operators (the building blocks of `U^{hyb,ev}_{A,2}`)

The even hybrid form is `Σ_j F^{(j)}·T^ev(j)·e^j` (tex, GL₂ Newton form); here are the
`F`-ladder ingredients: the `F`-power formula and the divided power `F^{(j)}` whose
basis action is the Gaussian binomial — reusing the CERTIFIED generic q-arithmetic
(`qFact_mul_qBinom_eq_prod_qInt`). -/

/-- Iterated `F`-action: `Fⁿ v_c = (∏_{i<n} [c+i+1]_q) v_{c+n}`. -/
theorem FOp_pow_basis (n c : ℕ) :
    (FOp (K := K) ^ n) (VermaSpace.basis c)
      = (∏ i ∈ Finset.range n, qInt (K := K) ((c + i : ℕ) + 1)) • VermaSpace.basis (c + n) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [pow_succ', Module.End.mul_apply, ih, map_smul, FOp_basis, smul_smul,
      Finset.prod_range_succ, show c + n + 1 = c + (n + 1) by omega]

/-- The divided power `F^{(j)} = Fʲ/[j]_q!` as an operator. -/
noncomputable def FdivOp (j : ℕ) : Module.End K (VermaSpace K) :=
  (qFact (K := K) j)⁻¹ • FOp ^ j

/-- Divided-power basis action: `F^{(j)} v_c = [c+j; j]_q v_{c+j}` — the Gaussian
binomial ladder, matching `Action.Fdiv` of the sl₂ layer and `F_divided_power` in
Julia. Uses the certified `qFact_mul_qBinom_eq_prod_qInt`. -/
theorem FdivOp_basis [QGeneric K] (j c : ℕ) :
    FdivOp (K := K) j (VermaSpace.basis c)
      = qBinom (K := K) (c + j) j • VermaSpace.basis (c + j) := by
  rw [FdivOp, LinearMap.smul_apply, FOp_pow_basis, smul_smul,
    ← qFact_mul_qBinom_eq_prod_qInt, ← mul_assoc,
    inv_mul_cancel₀ (qFact_ne_zero j), one_mul]

end GL2

end Verma
end A1
end HybridQuantumLean
