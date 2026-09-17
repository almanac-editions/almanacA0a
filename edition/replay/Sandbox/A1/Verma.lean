import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Field.Basic
import Mathlib.Algebra.GroupWithZero.Units.Basic
import Mathlib.Data.Finsupp.Defs
import Mathlib.Data.Finsupp.Single
import Mathlib.Data.Finsupp.SMul

set_option linter.style.header false

/-!
# A1 quantum Verma module — default-mode skeleton

Mirrors the Julia object `A1VermaModule` (default mode, `parent_a1()`) from
`HybridQuantum/src/A1/verma.jl`.  Spec produced by Codex at
`julia/hybrid/notes/lean_spec_a1_verma.json`.

Scope of this file (MVP):
  * Coefficient-ring abstraction `QFieldParams` (q, z and basic nondeg
    hypotheses).  Concrete realisation as ℚ(q)(z) is left to a future file.
  * Symmetric q-integer, q-factorial, q-binomial.
  * The Verma module as a free K-module on ℕ (using `Finsupp`).
  * Generator actions on basis vectors: F, F^(a), e, e^b, K_+, K_-.
  * Statement-level theorems with proofs where they are immediate, and
    `sorry` where they need real work (lattice preservation, e-power product
    rewriting under the c ≥ b guard, etc.).
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace Verma

universe u

/-! ## Coefficient ring abstraction -/

/-- Hypotheses on the coefficient ring K sufficient to define the A1 q-Verma
module in its default (`parent_a1()`) form.

For the Julia realisation, `K = ℚ(q)(z)` with `q` the quantum parameter and
`z = K_+ K_-` the central toral element; `q` is transcendental over ℚ and
`z` over ℚ(q).  Here we abstract over `q` and `z`, only requiring nondegen­
eracy of the symmetric q-integer denominator. -/
class QFieldParams (K : Type u) [Field K] where
  q : K
  z : K
  q_ne_zero : q ≠ 0
  /-- `q² ≠ 1`, equivalently `q - q⁻¹ ≠ 0`, equivalently `[1]_q ≠ 0`.
      This is the minimal nondegeneracy ensuring the symmetric
      q-integer formula is meaningful. -/
  q_sq_ne_one : q * q ≠ 1

namespace QFieldParams

variable {K : Type u} [Field K] [P : QFieldParams K]

/-- `q - q⁻¹` is nonzero under `q_sq_ne_one`. -/
lemma q_sub_qinv_ne_zero : P.q - P.q⁻¹ ≠ 0 := by
  intro h
  apply P.q_sq_ne_one
  have hq_eq : P.q = P.q⁻¹ := sub_eq_zero.mp h
  have hmul : P.q * P.q⁻¹ = 1 := mul_inv_cancel₀ P.q_ne_zero
  -- rewrite q⁻¹ ↦ q on the LHS using hq_eq (right-to-left)
  rw [← hq_eq] at hmul
  exact hmul

/-- Symmetric q-integer `[n]_q = (q^n - q^{-n}) / (q - q⁻¹)`, for `n : ℤ`. -/
noncomputable def qInt (n : ℤ) : K :=
  (P.q ^ n - P.q ^ (-n)) / (P.q - P.q⁻¹)

/-- q-factorial `[n]_q!`. -/
noncomputable def qFact : ℕ → K
  | 0 => 1
  | n+1 => qInt (K := K) (n+1) * qFact n

/-- Symmetric Gaussian q-binomial `[n; k]_q = [n]_q! / ([k]_q! [n-k]_q!)`
for `0 ≤ k ≤ n`, and 0 otherwise.  Matches `QFunctions.jl :: q_binom_sym`. -/
noncomputable def qBinom (n k : ℕ) : K :=
  if k ≤ n then qFact (K := K) n / (qFact (K := K) k * qFact (K := K) (n - k))
  else 0

end QFieldParams

/-! ## The Verma module as a free `K`-module on `ℕ` -/

/-- A vector in the Verma module `M_q(r)`, stored as a finitely-supported
function `ℕ →₀ K`.  Index `c` represents the basis vector `v_c = F^(c) v_0`. -/
abbrev VermaSpace (K : Type u) [Field K] : Type u := ℕ →₀ K

namespace VermaSpace

variable {K : Type u} [Field K]

/-- The basis vector `v_c` (coefficient 1 in position `c`, zero elsewhere). -/
noncomputable def basis (c : ℕ) : VermaSpace K := Finsupp.single c (1 : K)

end VermaSpace

/-! ## Actions of `U_q^Λ(sl_2)` generators on basis vectors

These follow the spec in `lean_spec_a1_verma.json` § generator_actions_on_basis,
restricted to `parent_a1()` (default) mode.  Linear extension to arbitrary
`VermaSpace K` vectors is provided by mathlib's `Finsupp.sum` machinery and
is not unfolded here. -/

namespace Action

variable {K : Type u} [Field K] [P : QFieldParams K]

open QFieldParams

/-- Closed-form scalar attached to a single `e` step lowering `v_c` to `v_{c-1}`.
    `eOneCoeff r c = q^{r-c+1} - z · q^{c-r-1}`.
    Matches `_a1_verma_one_e_coeff` (default branch). -/
noncomputable def eOneCoeff (r : ℤ) (c : ℕ) : K :=
  P.q ^ (r - (c : ℤ) + 1) - P.z * P.q ^ ((c : ℤ) - r - 1)

/-- Action of the divided power `F^(a)` on `v_c`:
    `F^(a) · v_c = [c+a; a]_q · v_{c+a}`. -/
noncomputable def Fdiv (a c : ℕ) : VermaSpace K :=
  (qBinom (K := K) (c + a) a) • VermaSpace.basis (c + a)

/-- Action of the single generator `F` on `v_c`:
    `F · v_c = [c+1]_q · v_{c+1}`.  Specialisation of `Fdiv` at `a = 1`. -/
noncomputable def F (c : ℕ) : VermaSpace K := Fdiv (K := K) 1 c

/-- Action of `e` on `v_c`:
    `e · v_c = eOneCoeff r c · v_{c-1}` if `c ≥ 1`, otherwise `0`. -/
noncomputable def e (r : ℤ) : ℕ → VermaSpace K
  | 0     => 0
  | c + 1 => (eOneCoeff (K := K) r (c + 1)) • VermaSpace.basis c

/-- Action of `e^b` on `v_c`:
    `e^b · v_c = (∏_{j=0}^{b-1} eOneCoeff r (c-j)) · v_{c-b}` if `c ≥ b`,
    otherwise `0`.  Matches `_a1_verma_e_power_coeff`. -/
noncomputable def ePow (r : ℤ) (b c : ℕ) : VermaSpace K :=
  if c < b then 0
  else (∏ j ∈ Finset.range b, eOneCoeff (K := K) r (c - j)) •
         VermaSpace.basis (c - b)

/-- Action of `K_+` on `v_c`:
    `K_+ · v_c = q^{r - 2c} · v_c`. -/
noncomputable def Kp (r : ℤ) (c : ℕ) : VermaSpace K :=
  (P.q ^ (r - 2 * (c : ℤ))) • VermaSpace.basis c

/-- Action of `K_-` on `v_c`:
    `K_- · v_c = z · q^{2c - r} · v_c`. -/
noncomputable def Km (r : ℤ) (c : ℕ) : VermaSpace K :=
  (P.z * P.q ^ (2 * (c : ℤ) - r)) • VermaSpace.basis c

end Action

/-! ## Theorem statements

Statements mirror the `invariants_and_theorems` block of the spec.  Easy
proofs are discharged; the deep facts (lattice preservation, simplicity for
generic `r`, etc.) are stated with `sorry`. -/

namespace Theorem

variable {K : Type u} [Field K] [P : QFieldParams K]

open Action VermaSpace

/-- Highest-vector annihilation: `e · v_0 = 0`. -/
theorem e_v0_eq_zero (r : ℤ) : e (K := K) r 0 = 0 := rfl

/-- `K_+` acts diagonally on `v_c` with eigenvalue `q^{r-2c}`. -/
theorem Kp_diagonal (r : ℤ) (c : ℕ) :
    Kp (K := K) r c = P.q ^ (r - 2 * (c : ℤ)) • VermaSpace.basis c := rfl

/-- `K_-` acts diagonally on `v_c` with eigenvalue `z · q^{2c-r}`. -/
theorem Km_diagonal (r : ℤ) (c : ℕ) :
    Km (K := K) r c = (P.z * P.q ^ (2 * (c : ℤ) - r)) • VermaSpace.basis c := rfl

/-- `F^(a) · v_c = [c+a; a]_q · v_{c+a}`. -/
theorem Fdiv_eq (a c : ℕ) :
    Fdiv (K := K) a c
      = (QFieldParams.qBinom (K := K) (c + a) a) • VermaSpace.basis (c + a) := rfl

/-- Closed form of `e^b · v_c` for `c ≥ b`. -/
theorem ePow_closed_form (r : ℤ) (b c : ℕ) (hbc : b ≤ c) :
    ePow (K := K) r b c
      = (∏ j ∈ Finset.range b, eOneCoeff (K := K) r (c - j))
          • VermaSpace.basis (c - b) := by
  unfold ePow
  rw [if_neg (Nat.not_lt.mpr hbc)]

/-- `e^b · v_c = 0` when `c < b`. -/
theorem ePow_vanish (r : ℤ) (b c : ℕ) (hbc : c < b) :
    ePow (K := K) r b c = 0 := by
  unfold ePow
  rw [if_pos hbc]

/-! ### Deep theorems (proofs deferred). -/

/-- **Lattice preservation** (statement only; load-bearing target).

For any element of `U_q^Λ(sl_2)` whose PBW coefficients lie in
`ℤ[q^{±1}, z^{±1}]`, its action on every basis vector `v_c` of `M_q(r)`
produces Verma coefficients in `ℤ[q^{±1}, z^{±1}]`.

Julia counterpart: `a1_verma_lattice_preserved` / `_diff` (verma.jl:218-260).

The Lean statement requires first formalising
  • the algebra `U_q^Λ(sl_2)` and its PBW basis,
  • the subring `ℤ[q^{±1}, z^{±1}] ⊂ K`,
  • the integrality predicate on PBW elements.

Proof strategy when those are in place: induction on the PBW form
`F^(a) · t · e^b`, using
  (i) Laurent-integrality of `qBinom` (q-binomials are in `ℤ[q^±]`),
  (ii) Laurent-integrality of `eOneCoeff` (since it is `q^k - z q^{-k}`),
  (iii) toral evaluations land in `ℤ[q^±, z^±]` since `K_+ → q^{r-2c}`,
       `K_- → z q^{2c-r}`. -/
theorem lattice_preserved
    -- placeholder signature; refine once the algebra-and-integrality
    -- infrastructure is in place.
    : True := trivial

end Theorem

end Verma
end A1
end HybridQuantumLean
