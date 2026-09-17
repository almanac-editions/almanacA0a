import Sandbox.A1.Verma

set_option linter.style.header false

/-!
# A1 q-arithmetic — intern lemma scaffold (Weeks 1–4 ramp + ring/E/F targets)

Companion to `notes/intern_lean_qarith_lemma_worksheet_2026-06-26.md` and
`notes/translate_to_prover_build_order_and_timeline_2026-06-26.md` §1b.

Builds on the `QFieldParams` API already in `A1/Verma.lean`
(`qInt : ℤ → K`, `qFact : ℕ → K`, `qBinom : ℕ → ℕ → K`).

**Status of this file.**
  * Groups A–D are **CLOSED** (2026-07-01, Sandbox v0): every lemma is CAS-verified,
    prover-generated (Goedel-8B skeletons · Fable-5 proofs), and Lean-certified —
    `#print axioms` shows exactly `[propext, Classical.choice, Quot.sound]` for all of them.
    Helper lemmas carry the `hq_` prefix. NOTE: this file's slim import closure has no
    `ring`/`field_simp`/`norm_num`; all algebra is explicit `rw`-chains — keep it that way
    or widen the imports deliberately.
  * Two were proved from the start as worked examples (`qInt_ne_zero`, `qFact_succ`).
  * Group **E** (q-binomial integrality) is **CLOSED** (2026-07-02): see `A1/LaurentZZ.lean`
    for the ring `ℤ[q^±]`, `evalToField`, `IsIntegral`, and the capstone `qBinom_isIntegral`
    (proved via `qPascalI`; same axiom triple, no `sorryAx`). The spec's computable normal
    form (see `[[computable-laurent-ring-spec-for-lean]]`) remains deferred.
  * Group **F** (convention bridges) is documented at the bottom, NOT yet live; part of F
    already exists in `Verma.lean`.

**Faithfulness note (q-Pascal).** The exponents in `qPascalI/qPascalII` were pinned against the
Julia package `QFunctions.jl :: q_binom_sym` (verified for all `0 ≤ k ≤ n ≤ 7`), and independently
against the symmetric convention `[n]_q = (qⁿ − q⁻ⁿ)/(q − q⁻¹)` in sympy. Do NOT replace them with
the `(qⁿ−1)/(q−1)`-convention powers.
-/

open BigOperators

namespace HybridQuantumLean
namespace A1
namespace Verma

open QFieldParams

universe u
variable {K : Type u} [Field K] [P : QFieldParams K]

/-! ## Genericity hypothesis

`QFieldParams` only forces `[1]_q ≠ 0`. The *division*-based q-binomial lemmas need every nonzero
q-integer to be nonzero — TRUE over ℚ(q) (transcendental q), FALSE at roots of unity. We isolate it
as a `Prop` class so the ramp lemmas can carry the honest hypothesis `[QGeneric K]`. -/
class QGeneric (K : Type u) [Field K] [QFieldParams K] : Prop where
  qInt_ne_zero : ∀ n : ℤ, n ≠ 0 → qInt (K := K) n ≠ 0

/-! ## Tier 1 — the one missing definition

Closed-form q-binomial value `⟨m;t⟩_q = ∏_{r=1}^t [m+1−r]_q / [r]_q`, with `m : ℤ` arbitrary
(including negative). Mirrors `QFunctions.jl :: sym_q_binom_value`. Stated by recursion on `t`
(avoids `Finset` plumbing): `⟨m;0⟩ = 1`, `⟨m;t+1⟩ = ⟨m;t⟩ · [m−t]_q / [t+1]_q`. -/
noncomputable def symQBinomValue (m : ℤ) : ℕ → K
  | 0     => 1
  | t + 1 => symQBinomValue m t * (qInt (m - (t : ℤ)) / qInt ((t : ℤ) + 1))

/-! ## Group A — nondegeneracy / well-definedness -/

/-- WORKED EXAMPLE (no `sorry`): nonzero q-integers, straight from the genericity class. -/
theorem qInt_ne_zero [QGeneric K] {n : ℤ} (hn : n ≠ 0) : qInt (K := K) n ≠ 0 :=
  QGeneric.qInt_ne_zero n hn

/-- `[n]_q! ≠ 0` (needs genericity). teaches: `induction`, `mul_ne_zero`. The unlock for group D. -/
theorem qFact_ne_zero [QGeneric K] (n : ℕ) : qFact (K := K) n ≠ 0 := by
  induction n with
  | zero => simp [qFact]
  | succ n ih =>
    rw [show qFact (K := K) (n + 1) = qInt (K := K) (n + 1) * qFact (K := K) n from rfl]
    refine mul_ne_zero (qInt_ne_zero ?_) ih
    omega

/-! ## Group B — q-integer identities (UNCONDITIONAL, over bare `QFieldParams`) -/

/-- `[0]_q = 0`. teaches: `unfold`, `simp`. -/
theorem qInt_zero : qInt (K := K) 0 = 0 := by
  simp [qInt]

/-- `[1]_q = 1`. teaches: `zpow_one`, `zpow_neg`, `div_self`, `q_sub_qinv_ne_zero`. -/
theorem qInt_one : qInt (K := K) 1 = 1 := by
  simp only [qInt, zpow_one, zpow_neg]
  exact div_self (q_sub_qinv_ne_zero (K := K))

/-- `[2]_q = q + q⁻¹`. teaches: `field_simp`, `ring`. source: docstring `[2]=q+q⁻¹`. -/
theorem qInt_two : qInt (K := K) 2 = P.q + P.q⁻¹ := by
  have hq : P.q ≠ 0 := P.q_ne_zero
  have hd := q_sub_qinv_ne_zero (K := K)
  have h2 : (2 : ℤ) = 1 + 1 := by decide
  simp only [qInt]
  rw [div_eq_iff hd, h2, zpow_add₀ hq, neg_add, zpow_add₀ hq, zpow_neg, zpow_one]
  rw [add_mul, mul_sub, mul_sub, mul_inv_cancel₀ hq, inv_mul_cancel₀ hq, sub_add_sub_cancel]

/-- Antisymmetry `[−n]_q = −[n]_q`. teaches: `neg_div`, `ring`. source: `[−3]+[3]=0`. -/
theorem qInt_neg (n : ℤ) : qInt (K := K) (-n) = - qInt (K := K) n := by
  simp only [qInt, neg_neg]
  rw [← neg_div, neg_sub]

/-- Additive recurrence `[n+1]_q = q·[n]_q + q^{−n}`. teaches: `field_simp`, `zpow_add`, `ring`.
    (The "workhorse" — pin the `q^{−n}` term against the Julia value if in doubt.) -/
theorem qInt_succ (n : ℤ) : qInt (K := K) (n + 1) = P.q * qInt (K := K) n + P.q ^ (-n) := by
  have hq : P.q ≠ 0 := P.q_ne_zero
  have hd := q_sub_qinv_ne_zero (K := K)
  have h1 : P.q ^ (n + 1) = P.q * P.q ^ n := by
    rw [zpow_add₀ hq, zpow_one, mul_comm]
  have h2 : P.q ^ (-(n + 1)) = P.q ^ (-n) * P.q⁻¹ := by
    rw [neg_add, zpow_add₀ hq, zpow_neg, zpow_neg, zpow_one]
  have hnum : P.q ^ (n + 1) - P.q ^ (-(n + 1))
      = P.q * (P.q ^ n - P.q ^ (-n)) + P.q ^ (-n) * (P.q - P.q⁻¹) := by
    rw [h1, h2, mul_sub, mul_sub, mul_comm P.q (P.q ^ (-n)), sub_add_sub_cancel]
  simp only [qInt]
  rw [div_eq_iff hd, add_mul, mul_assoc, div_mul_cancel₀ _ hd]
  exact hnum

/-- Telescoping closed form `[n]_q = ∑_{i<n} q^{n−1−2i}` (n : ℕ). The first real induction.
    teaches: `induction`, `Finset.sum_range_succ`. source: docstring `[n]=qⁿ⁻¹+…+q⁻⁽ⁿ⁻¹⁾`. -/
theorem qInt_telescope (n : ℕ) :
    qInt (K := K) (n : ℤ) = ∑ i ∈ Finset.range n, P.q ^ ((n : ℤ) - 1 - 2 * (i : ℤ)) := by
  have hq : P.q ≠ 0 := P.q_ne_zero
  induction n with
  | zero =>
    simp only [Nat.cast_zero, Finset.range_zero, Finset.sum_empty]
    simp only [qInt, neg_zero, zpow_zero, sub_self, zero_div]
  | succ n ih =>
    push_cast
    rw [qInt_succ, ih]
    simp only [Finset.mul_sum, Finset.sum_range_succ]
    have hsum : ∀ i ∈ Finset.range n,
        P.q * P.q ^ ((n : ℤ) - 1 - 2 * (i : ℤ)) = P.q ^ ((n : ℤ) + 1 - 1 - 2 * (i : ℤ)) := by
      intro i _
      have h1 : (n : ℤ) + 1 - 1 - 2 * (i : ℤ) = 1 + ((n : ℤ) - 1 - 2 * (i : ℤ)) := by omega
      rw [h1, zpow_add₀ hq, zpow_one]
    have hlast : ((n : ℤ) + 1 - 1 - 2 * (n : ℤ)) = -(n : ℤ) := by omega
    rw [Finset.sum_congr rfl hsum, hlast]

/-! ## Group C — q-factorial (UNCONDITIONAL) -/

/-- WORKED EXAMPLE: the factorial recurrence is the definition. source: `[5]!=[5][4]!`.
    (If `rfl` does not fire on your Mathlib, use `by simp [qFact]`.) -/
theorem qFact_succ (n : ℕ) :
    qFact (K := K) (n + 1) = qInt (K := K) (n + 1) * qFact (K := K) n := rfl

/-- Product form `[n]_q! = ∏_{k<n} [k+1]_q`. teaches: `induction`, `Finset.prod_range_succ`. -/
theorem qFact_eq_prod (n : ℕ) :
    qFact (K := K) n = ∏ k ∈ Finset.range n, qInt (K := K) ((k : ℤ) + 1) := by
  induction n with
  | zero => simp [qFact]
  | succ n ih =>
    rw [qFact_succ, ih, Finset.prod_range_succ]
    exact mul_comm _ _

/-! ## Group D — q-binomial -/

/-- Symmetry `[n;k]_q = [n;n−k]_q` (UNCONDITIONAL — just `mul_comm` in the denominator).
    Do this one FIRST in group D. source: `[5;2]=[5;3]`. -/
theorem qBinom_symm {n k : ℕ} (h : k ≤ n) :
    qBinom (K := K) n k = qBinom (K := K) n (n - k) := by
  simp only [qBinom]
  rw [if_pos h, if_pos (Nat.sub_le n k), Nat.sub_sub_self h, mul_comm]

/-- `[n;0]_q = 1` (needs genericity: else `qFact n / qFact n = 0/0 = 0`). teaches: `div_self`. -/
theorem qBinom_zero [QGeneric K] (n : ℕ) : qBinom (K := K) n 0 = 1 := by
  have h0 : qFact (K := K) 0 = 1 := rfl
  simp only [qBinom]
  rw [if_pos (Nat.zero_le n), Nat.sub_zero, h0, one_mul]
  exact div_self (qFact_ne_zero n)

/-- `[n;n]_q = 1` (needs genericity). -/
theorem qBinom_self [QGeneric K] (n : ℕ) : qBinom (K := K) n n = 1 := by
  simp only [qBinom, if_pos (le_refl n), Nat.sub_self, qFact, mul_one]
  exact div_self (qFact_ne_zero n)

/-- Out-of-range vanishing `[n;k]_q = 0` for `n < k`. teaches: `if_neg`. source: `[5;6]=0`. -/
theorem qBinom_eq_zero_of_lt {n k : ℕ} (h : n < k) : qBinom (K := K) n k = 0 := by
  simp only [qBinom, if_neg (Nat.not_le.mpr h)]

/-- Factorial ladder `[c]_q! · ∏_{j<n} [c+j+1]_q = [c+n]_q!` (unconditional).
    (Moved here from `ActionBridges.lean` 2026-07-02 — generic q-arithmetic, needed by
    the GL₂ CENTER program; statement unchanged.) -/
theorem qFact_mul_prod_qInt (c n : ℕ) :
    qFact (K := K) c * ∏ j ∈ Finset.range n, qInt (K := K) ((c + j : ℕ) + 1)
      = qFact (K := K) (c + n) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.prod_range_succ, ← mul_assoc, ih,
      show c + (n + 1) = c + n + 1 from rfl, qFact_succ]
    exact mul_comm _ _

/-- CAS-pinned scalar identity `[n]_q! · [c+n; n]_q = ∏_{j<n} [c+j+1]_q`
    (REPL-verified for `c ≤ 5`, `n ≤ 5`; moved here from `ActionBridges.lean`
    2026-07-02, statement unchanged). -/
theorem qFact_mul_qBinom_eq_prod_qInt [QGeneric K] (n c : ℕ) :
    qFact (K := K) n * qBinom (K := K) (c + n) n
      = ∏ j ∈ Finset.range n, qInt (K := K) ((c + j : ℕ) + 1) := by
  have hn0 : qFact (K := K) n ≠ 0 := qFact_ne_zero n
  have hc0 : qFact (K := K) c ≠ 0 := qFact_ne_zero c
  simp only [qBinom]
  rw [if_pos (Nat.le_add_left n c), Nat.add_sub_cancel, ← qFact_mul_prod_qInt c n,
    mul_div_assoc', div_eq_iff (mul_ne_zero hn0 hc0)]
  ac_rfl

/-- Sandbox-v0 helper: the symmetric q-integer addition rule `[a+b]_q = qᵃ·[b]_q + q⁻ᵇ·[a]_q`
    (pure `ℤ` exponents, no `ℕ`-subtraction — the algebraic core of q-Pascal rule (I)). -/
theorem hq_qInt_add (a b : ℤ) :
    qInt (K := K) (a + b) = P.q ^ a * qInt (K := K) b + P.q ^ (-b) * qInt (K := K) a := by
  have hq : P.q ≠ 0 := P.q_ne_zero
  have hnum : P.q ^ a * P.q ^ b - P.q ^ (-a) * P.q ^ (-b)
      = P.q ^ a * (P.q ^ b - P.q ^ (-b)) + P.q ^ (-b) * (P.q ^ a - P.q ^ (-a)) := by
    rw [mul_sub, mul_sub, mul_comm (P.q ^ (-b)) (P.q ^ a), mul_comm (P.q ^ (-b)) (P.q ^ (-a)),
        sub_add_sub_cancel]
  simp only [qInt]
  rw [zpow_add₀ hq, neg_add, zpow_add₀ hq, hnum, add_div, mul_div_assoc, mul_div_assoc]

omit P in
/-- Sandbox-v0 helper: the fraction-splitting shape of the q-Pascal endgame
    (`ring`/`field_simp` are unavailable under this file's slim import closure). -/
theorem hq_frac_split (x y u v c a b : K) (hu : u ≠ 0) (hv : v ≠ 0) :
    (x * u + y * v) * c / (u * a * (v * b))
      = x * (c / (a * (v * b))) + y * (c / (u * a * b)) := by
  rw [add_mul, add_div]
  congr 1
  · rw [mul_comm x u, mul_assoc u x c, mul_assoc u a (v * b),
        mul_div_mul_left (x * c) (a * (v * b)) hu, mul_div_assoc]
  · rw [mul_comm y v, mul_assoc v y c, mul_left_comm (u * a) v b,
        mul_div_mul_left (y * c) (u * a * b) hv, mul_div_assoc]

/-- **q-Pascal, rule (I):** `[n;k]_q = q^{n−k}·[n−1;k−1]_q + q^{−k}·[n−1;k]_q`.
    Exponents pinned against `q_binom_sym` (see header). The engine of integrality (group E).
    teaches: the central `field_simp; ring` move. -/
theorem qPascalI [QGeneric K] {n k : ℕ} (h1 : 1 ≤ k) (h2 : k ≤ n) :
    qBinom (K := K) n k
      = P.q ^ ((n : ℤ) - (k : ℤ)) * qBinom (K := K) (n - 1) (k - 1)
        + P.q ^ (-(k : ℤ)) * qBinom (K := K) (n - 1) k := by
  obtain ⟨j, rfl⟩ : ∃ j, k = j + 1 := ⟨k - 1, by omega⟩
  obtain ⟨m, rfl⟩ : ∃ m, n = j + 1 + m := ⟨n - (j + 1), by omega⟩
  by_cases hm : m = 0
  · -- boundary case k = n
    subst hm
    simp only [Nat.add_zero, Nat.add_sub_cancel]
    rw [show ((j + 1 : ℕ) : ℤ) - ((j + 1 : ℕ) : ℤ) = 0 by omega, zpow_zero]
    simp only [qBinom]
    rw [if_pos (le_refl (j + 1)), if_pos (le_refl j), if_neg (show ¬ (j + 1 ≤ j) by omega)]
    simp only [Nat.sub_self]
    rw [show qFact (K := K) 0 = 1 by simp only [qFact]]
    simp only [mul_one, one_mul, mul_zero, add_zero]
    rw [div_self (qFact_ne_zero (K := K) (j + 1)), div_self (qFact_ne_zero (K := K) j)]
  · -- generic case k < n
    obtain ⟨m', rfl⟩ : ∃ m', m = m' + 1 := ⟨m - 1, by omega⟩
    rw [show j + 1 + (m' + 1) = j + m' + 1 + 1 by omega]
    simp only [Nat.add_sub_cancel]
    rw [show ((j + m' + 1 + 1 : ℕ) : ℤ) - ((j + 1 : ℕ) : ℤ) = (m' : ℤ) + 1 by omega]
    rw [show (-((j + 1 : ℕ) : ℤ)) = -((j : ℤ) + 1) by omega]
    simp only [qBinom]
    rw [if_pos (show j + 1 ≤ j + m' + 1 + 1 by omega),
        if_pos (show j ≤ j + m' + 1 by omega),
        if_pos (show j + 1 ≤ j + m' + 1 by omega)]
    rw [show j + m' + 1 + 1 - (j + 1) = m' + 1 by omega,
        show j + m' + 1 - j = m' + 1 by omega,
        show j + m' + 1 - (j + 1) = m' by omega]
    rw [qFact_succ (K := K) (j + m' + 1), qFact_succ (K := K) j, qFact_succ (K := K) m']
    rw [show ((j + m' + 1 : ℕ) : ℤ) + 1 = ((m' : ℤ) + 1) + ((j : ℤ) + 1) by omega]
    rw [hq_qInt_add ((m' : ℤ) + 1) ((j : ℤ) + 1)]
    have hQj : qInt (K := K) ((j : ℤ) + 1) ≠ 0 := qInt_ne_zero (by omega)
    have hQm : qInt (K := K) ((m' : ℤ) + 1) ≠ 0 := qInt_ne_zero (by omega)
    rw [zpow_neg]
    exact hq_frac_split (P.q ^ ((m' : ℤ) + 1)) ((P.q ^ ((j : ℤ) + 1))⁻¹)
      (qInt (K := K) ((j : ℤ) + 1)) (qInt (K := K) ((m' : ℤ) + 1))
      (qFact (K := K) (j + m' + 1)) (qFact (K := K) j) (qFact (K := K) m') hQj hQm

/-- Sandbox-v0 helper: the mirrored q-integer addition rule `[a+b]_q = q⁻ᵃ·[b]_q + qᵇ·[a]_q`
    (the algebraic core of q-Pascal rule (II)). -/
theorem hq_qInt_add' (a b : ℤ) :
    qInt (K := K) (a + b) = P.q ^ (-a) * qInt (K := K) b + P.q ^ b * qInt (K := K) a := by
  have hq : P.q ≠ 0 := P.q_ne_zero
  have hd := q_sub_qinv_ne_zero (K := K)
  have h1 : P.q ^ (a + b) = P.q ^ a * P.q ^ b := zpow_add₀ hq a b
  have h2 : P.q ^ (-(a + b)) = P.q ^ (-a) * P.q ^ (-b) := by
    rw [neg_add, zpow_add₀ hq]
  simp only [qInt]
  rw [div_eq_iff hd, add_mul, mul_assoc, div_mul_cancel₀ _ hd, mul_assoc,
    div_mul_cancel₀ _ hd, h1, h2, mul_sub, mul_sub,
    add_comm (P.q ^ (-a) * P.q ^ b - P.q ^ (-a) * P.q ^ (-b))
      (P.q ^ b * P.q ^ a - P.q ^ b * P.q ^ (-a)),
    mul_comm (P.q ^ b) (P.q ^ (-a)), sub_add_sub_cancel,
    mul_comm (P.q ^ b) (P.q ^ a)]

/-- **q-Pascal, rule (II):** `[n;k]_q = q^{k−n}·[n−1;k−1]_q + q^{k}·[n−1;k]_q`.
    The mirror of (I); either suffices for integrality. -/
theorem qPascalII [QGeneric K] {n k : ℕ} (h1 : 1 ≤ k) (h2 : k ≤ n) :
    qBinom (K := K) n k
      = P.q ^ ((k : ℤ) - (n : ℤ)) * qBinom (K := K) (n - 1) (k - 1)
        + P.q ^ (k : ℤ) * qBinom (K := K) (n - 1) k := by
  obtain ⟨j, rfl⟩ : ∃ j, k = j + 1 := ⟨k - 1, by omega⟩
  obtain ⟨m, rfl⟩ : ∃ m, n = j + 1 + m := ⟨n - (j + 1), by omega⟩
  by_cases hm : m = 0
  · -- boundary column k = n : the second q-binomial vanishes
    subst hm
    simp only [Nat.add_zero]
    have hz : qBinom (K := K) (j + 1 - 1) (j + 1) = 0 := by
      have e : j + 1 - 1 = j := by omega
      rw [e]
      simp only [qBinom]
      rw [if_neg (by omega : ¬ (j + 1 ≤ j))]
    rw [hz, Nat.add_sub_cancel, qBinom_self, qBinom_self, sub_self, zpow_zero,
      one_mul, mul_zero, add_zero]
  · -- interior: k < n, all three binomials are genuine factorial quotients
    obtain ⟨m', rfl⟩ : ∃ m', m = m' + 1 := ⟨m - 1, by omega⟩
    have hA : qBinom (K := K) (j + 1 + (m' + 1)) (j + 1)
        = qFact (K := K) (j + 1 + (m' + 1))
          / (qFact (K := K) (j + 1) * qFact (K := K) (m' + 1)) := by
      simp only [qBinom]
      rw [if_pos (by omega : j + 1 ≤ j + 1 + (m' + 1))]
      have e : j + 1 + (m' + 1) - (j + 1) = m' + 1 := by omega
      rw [e]
    have hB : qBinom (K := K) (j + 1 + (m' + 1) - 1) (j + 1 - 1)
        = qFact (K := K) (j + 1 + m') / (qFact (K := K) j * qFact (K := K) (m' + 1)) := by
      have e1 : j + 1 + (m' + 1) - 1 = j + 1 + m' := by omega
      have e2 : j + 1 - 1 = j := by omega
      rw [e1, e2]
      simp only [qBinom]
      rw [if_pos (by omega : j ≤ j + 1 + m')]
      have e3 : j + 1 + m' - j = m' + 1 := by omega
      rw [e3]
    have hC : qBinom (K := K) (j + 1 + (m' + 1) - 1) (j + 1)
        = qFact (K := K) (j + 1 + m') / (qFact (K := K) (j + 1) * qFact (K := K) m') := by
      have e1 : j + 1 + (m' + 1) - 1 = j + 1 + m' := by omega
      rw [e1]
      simp only [qBinom]
      rw [if_pos (by omega : j + 1 ≤ j + 1 + m')]
      have e3 : j + 1 + m' - (j + 1) = m' := by omega
      rw [e3]
    rw [hA, hB, hC]
    have eexp1 : ((j + 1 : ℕ) : ℤ) - ((j + 1 + (m' + 1) : ℕ) : ℤ) = -((m' : ℤ) + 1) := by
      omega
    rw [eexp1]
    have eexp2 : ((j + 1 : ℕ) : ℤ) = (j : ℤ) + 1 := by omega
    rw [eexp2]
    have en : j + 1 + (m' + 1) = j + 1 + m' + 1 := by omega
    rw [en, qFact_succ (j + 1 + m'), qFact_succ j, qFact_succ m']
    have eint : ((j + 1 + m' : ℕ) : ℤ) + 1 = ((m' : ℤ) + 1) + ((j : ℤ) + 1) := by omega
    rw [eint, hq_qInt_add' ((m' : ℤ) + 1) ((j : ℤ) + 1)]
    have hfG : qFact (K := K) j ≠ 0 := qFact_ne_zero _
    have hfH : qFact (K := K) m' ≠ 0 := qFact_ne_zero _
    have hiU : qInt (K := K) ((j : ℤ) + 1) ≠ 0 := qInt_ne_zero (by omega)
    have hiV : qInt (K := K) ((m' : ℤ) + 1) ≠ 0 := qInt_ne_zero (by omega)
    have hdB : qFact (K := K) j * (qInt (K := K) ((m' : ℤ) + 1) * qFact (K := K) m') ≠ 0 :=
      mul_ne_zero hfG (mul_ne_zero hiV hfH)
    have hdC : qInt (K := K) ((j : ℤ) + 1) * qFact (K := K) j * qFact (K := K) m' ≠ 0 :=
      mul_ne_zero (mul_ne_zero hiU hfG) hfH
    have hdA : qInt (K := K) ((j : ℤ) + 1) * qFact (K := K) j
        * (qInt (K := K) ((m' : ℤ) + 1) * qFact (K := K) m') ≠ 0 :=
      mul_ne_zero (mul_ne_zero hiU hfG) (mul_ne_zero hiV hfH)
    rw [mul_div_assoc', mul_div_assoc', div_add_div _ _ hdB hdC,
      div_eq_div_iff hdA (mul_ne_zero hdB hdC), add_mul, add_mul, add_mul]
    congr 1
    · ac_rfl
    · ac_rfl

/-- Sandbox-v0 helper: the column recurrence `[n;k+1]_q = [n;k]_q · [n−k]_q/[k+1]_q`
    (the factorial-quotient side of the `symQBinomValue` recursion). -/
theorem hq_step [QGeneric K] {n k : ℕ} (h : k + 1 ≤ n) :
    qBinom (K := K) n (k + 1)
      = qBinom (K := K) n k
        * (qInt (K := K) ((n : ℤ) - (k : ℤ)) / qInt (K := K) ((k : ℤ) + 1)) := by
  have hk : k ≤ n := by omega
  obtain ⟨d, hd⟩ : ∃ d, n = k + 1 + d := ⟨n - (k + 1), by omega⟩
  have h1 : n - (k + 1) = d := by omega
  have h2 : n - k = d + 1 := by omega
  have h3 : (n : ℤ) - (k : ℤ) = (d : ℤ) + 1 := by omega
  have hfk : qFact (K := K) k ≠ 0 := qFact_ne_zero k
  have hfd : qFact (K := K) d ≠ 0 := qFact_ne_zero d
  have hik : qInt (K := K) ((k : ℤ) + 1) ≠ 0 := qInt_ne_zero (by omega)
  have hid : qInt (K := K) ((d : ℤ) + 1) ≠ 0 := qInt_ne_zero (by omega)
  simp only [qBinom]
  rw [if_pos h, if_pos hk, h1, h2, h3, qFact_succ k, qFact_succ d]
  rw [div_mul_div_comm]
  rw [div_eq_div_iff (mul_ne_zero (mul_ne_zero hik hfk) hfd)
      (mul_ne_zero (mul_ne_zero hfk (mul_ne_zero hid hfd)) hik)]
  ac_rfl

/-- The two definitions agree on range: `[n;k]_q = ⟨n;k⟩_q` for `k ≤ n`.
    teaches: relating the factorial-ratio and the closed-form product.
    source: `sym(5,2)=binom(5,2)`. -/
theorem qBinom_eq_symValue [QGeneric K] {n k : ℕ} (h : k ≤ n) :
    qBinom (K := K) n k = symQBinomValue (K := K) (n : ℤ) k := by
  induction k with
  | zero =>
    have hs : symQBinomValue (K := K) (n : ℤ) 0 = 1 := rfl
    rw [hs, qBinom_zero]
  | succ k ih =>
    have hk : k ≤ n := by omega
    rw [hq_step h, ih hk]
    simp only [symQBinomValue]

/-- Sandbox-v0 helper: `symQBinomValue` as an explicit product over `Finset.range`. -/
theorem hq_symValue_eq_prod (m : ℤ) (t : ℕ) :
    symQBinomValue (K := K) m t
      = ∏ r ∈ Finset.range t, (qInt (K := K) (m - (r : ℤ)) / qInt (K := K) ((r : ℤ) + 1)) := by
  induction t with
  | zero => simp [symQBinomValue]
  | succ n ih =>
    rw [Finset.prod_range_succ, ← ih]
    simp only [symQBinomValue]

/-- Sandbox-v0 helper: numerator-product reflection `∏_{r<t} [m+r]_q = ∏_{r<t} [m+t−1−r]_q`. -/
theorem hq_prod_reflect (m : ℤ) (t : ℕ) :
    ∏ r ∈ Finset.range t, qInt (K := K) (m + (r : ℤ))
      = ∏ r ∈ Finset.range t, qInt (K := K) (m + (t : ℤ) - 1 - (r : ℤ)) := by
  induction t generalizing m with
  | zero => simp
  | succ n ih =>
    rw [Finset.prod_range_succ', Finset.prod_range_succ]
    have hzero : m + ((0 : ℕ) : ℤ) = m := by omega
    have hlast : m + ((n + 1 : ℕ) : ℤ) - 1 - (n : ℤ) = m := by omega
    rw [hzero, hlast]
    congr 1
    have hL : (∏ i ∈ Finset.range n, qInt (K := K) (m + ((i + 1 : ℕ) : ℤ)))
        = ∏ i ∈ Finset.range n, qInt (K := K) ((m + 1) + (i : ℤ)) :=
      Finset.prod_congr rfl fun i _ => by congr 1; omega
    have hR : (∏ i ∈ Finset.range n, qInt (K := K) (m + ((n + 1 : ℕ) : ℤ) - 1 - (i : ℤ)))
        = ∏ i ∈ Finset.range n, qInt (K := K) ((m + 1) + (n : ℤ) - 1 - (i : ℤ)) :=
      Finset.prod_congr rfl fun i _ => by congr 1; omega
    rw [hL, hR]
    exact ih (m + 1)

/-- Negative-`m` reflection `⟨−m;t⟩_q = (−1)^t · ⟨m+t−1;t⟩_q`.
    teaches: product reindexing + sign bookkeeping. source: `sym(−3,2)=sym(4,2)`. -/
theorem symValue_neg_reflection (m : ℤ) (t : ℕ) :
    symQBinomValue (K := K) (-m) t = (-1) ^ t * symQBinomValue (K := K) (m + (t : ℤ) - 1) t := by
  have hstep : ∀ r : ℕ,
      qInt (K := K) (-m - (r : ℤ)) / qInt (K := K) ((r : ℤ) + 1)
        = (-1 : K) * (qInt (K := K) (m + (r : ℤ)) / qInt (K := K) ((r : ℤ) + 1)) := by
    intro r
    have h1 : -m - (r : ℤ) = -(m + (r : ℤ)) := by omega
    rw [h1, qInt_neg, neg_div, neg_one_mul]
  rw [hq_symValue_eq_prod, hq_symValue_eq_prod]
  have hprodL :
      (∏ r ∈ Finset.range t, (qInt (K := K) (-m - (r : ℤ)) / qInt (K := K) ((r : ℤ) + 1)))
        = ∏ r ∈ Finset.range t,
            ((-1 : K) * (qInt (K := K) (m + (r : ℤ)) / qInt (K := K) ((r : ℤ) + 1))) :=
    Finset.prod_congr rfl fun r _ => hstep r
  rw [hprodL, Finset.prod_mul_distrib, Finset.prod_const, Finset.card_range]
  congr 1
  rw [Finset.prod_div_distrib, Finset.prod_div_distrib]
  congr 1
  exact hq_prod_reflect m t

end Verma
end A1
end HybridQuantumLean

/-!
## Group E — the bridge theorem (CLOSED 2026-07-02 — `A1/LaurentZZ.lean`)

`A1/LaurentZZ.lean` provides `LaurentZZ := LaurentPolynomial ℤ` (= `ℤ[q^±¹]`), the evaluation
`evalToField : LaurentZZ →+* K` (`T ↦ q`, a unit by `q_ne_zero`), the predicate
`IsIntegral (x : K) : Prop := ∃ p : LaurentZZ, evalToField p = x` with its closure API, and

  `theorem qBinom_isIntegral [QGeneric K] (n k : ℕ) : IsIntegral (qBinom (K := K) n k)`

proved by induction on `n` via `qPascalI` (base cases `qBinom_zero`/`qBinom_eq_zero_of_lt`),
`#print axioms` = `[propext, Classical.choice, Quot.sound]`. This is the obligation the
`Verma.lean` `lattice_preserved` docstring names; rewiring `lattice_preserved` itself (ORACLE
row 0), the spec's computable normal form, and the bivariate `ℤ[q^±, z^±]` remain future work —
see the design notes in the header of `LaurentZZ.lean`.

## Group F — convention bridges (do after E)

* `Fdiv_coeff` — `F^{(a)} · v_c = [c+a; a]_q · v_{c+a}` — ALREADY PROVED in `Verma.lean` as
  `Verma.Action.Fdiv_eq` (it is the definition of `Fdiv`). Nothing to do; cite it.
* `Fpow_eq_qFact_smul_Fdiv` — `Fⁿ = [n]_q! · F^{(n)}` — needs the iterated-action setup; source
  test `a1_convention.jl:11`.
* `qFact_sym_to_asym` — `q^{m(m−1)/2} · [m]_q! = ` (asymmetric `[m]!`), and the `q^{−m(m−1)/2}`
  mirror; source tests `gl2_cyclotomic_pole_tracker.jl:154,170`. Needs the asymmetric q-factorial
  `(qⁿ−1)/(q−1)` first.
-/
