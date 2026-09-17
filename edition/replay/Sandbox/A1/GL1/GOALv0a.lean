import Sandbox.A1.GL1.NewtonUnivSpan
import Sandbox.A1.GL1.FamilyField1
import Sandbox.A1.GL1.PresentedU

set_option linter.style.header false
set_option linter.unusedSectionVars false

/-!
# `A1.GL1Newton.GOALv0a` — the three clauses of `goalv0a`

Binding statement of record: `sandboxv0a/informal/goalv0a.lock.json`
(tex `91a50173…5a7e`, `sandboxv0a/informal/goalv0a.tex`).
Binding informal proof: `sandboxv0a/informal/PROOFv0a.tex`.
Binding formal design: `sandboxv0a/M1_DESIGN.md` §(d).

## The goal, clause by clause (anti-drift ledger)

Frame: `G = GL₁`, `Φ = ∅`, `W = {1}`, `Λ = ℤ`, `Q = q²`, `A_z = ℤ[q^{±1}, z^{±1}]`,
`K_z = ℚ(q)[z^{±1}]`.  Realised over the concrete field `K₁ = Frac(ℤ[q^±,z^±])`
(`FamilyField1`), whose `AzSubring` is exactly `A_z` (`az1_model_equiv`).

| goalv0a | Lean |
|---|---|
| Def 1 `U` presented by `K_{n,±}` + relations + basis | `Presentation.{U, equivTorus, uBasis}` |
| Def 1 model of `U` used downstream | `Torus K`, justified by `Presentation.modelEquiv` |
| Def 2 even toral = `K_z[Y̌^{±1}]`, `Y̌ = (T⁺)²` | `Frame K`, embedded by `evenEmb : Y̌ ↦ (T⁺)²` |
| Def 2 `ev_χ(Y̌) = Q^χ` (unshifted, `z`-free) | `grid χ` (`grid_Ycheck`) |
| Def 2 `𝒩^ev = {f : ev_χ(f) ∈ A_z ∀ χ ∈ ℤ}` | `Newton` |
| Def 3 `U^ev = 𝒩^ev` | `UevSubalg`; ambient form `UevTorus` |
| Def 3 `Z(U^ev) = U^ev ∩ Z(U ⊗ Frac A_z)` | `ZUevAmbient` (literal), `ZUev_eq_ZUevAmbient` |
| Def 4 `HC = id_U`; `W` acts by `w(Y_n) = Y_{wn}` | `HC = AlgHom.id`; `weyl : Unit → id` |
| Def 5 `ν_r(X) = ∏_{t<r}(X−Q^t)/(Q^r−Q^t)` | `nu r` (`= newtonPolyK 1 r`) |
| (i) `U^ev` is an `A_z`-subalgebra of `U` | `clause_i{,_in_torus,_ambient}` |
| (ii) `HC : Z(U^ev) ≅ (𝒩^ev)^W` `A_z`-algebra iso | `clause_ii`, `clause_ii_ambient` |
| (iii) `𝒩^ev = Σ_{u∈ℤ} Σ_{r≥0} A_z Y̌^u ν_r(Y̌)` | `clause_iii` / `Nev_eq_span`; coords `expand` |

Traps honoured: `Λ = ℤ` (there IS a `Y̌`); no `q`-shift (`2ρ = 0`, `grid` is `z`-free); `W = {1}`
proves nothing about Weyl invariance — clause (ii) is recorded as **degenerate** here and must
never be cited as evidence for the `(−)^W` side of the root goal; `Newton ⊋ Laurent`.

## Modelling assumptions (verification findings F1–F3), wave-3 status

The wave-2 delivery carried three unproved modelling steps between `goalv0a.tex` and the Lean.
All three are now discharged in-tree; **nothing here is assumed**:

* **F1 — the presentation-to-Laurent collapse.**  `goalv0a` Def 1 presents `U` by generators
  `K_{n,±}` and the relations `K_{0,±}=1`, `K_{m+n,±}=K_{m,±}K_{n,±}`, `K_{n,+}K_{n,-}=z^n`, and
  then *asserts* the `(T⁺)^w` basis.  `Sandbox/A1/GL1/PresentedU.lean` **constructs** that
  presented algebra (`Presentation.U z`, a quotient of the group algebra `K[ℤ × ℤ]` by exactly
  the remaining relation `T⁺T⁻ − z`) and **proves** `Presentation.equivTorus : U z ≃ₐ[K] Torus K`,
  the elimination `K_{n,-} = z^n (T⁺)^{-n}` (`Presentation.torusData_Kminus_eq_zpow`), and the
  basis assertion (`Presentation.uBasis`).  `Presentation.modelEquiv` pins the instantiation at
  the model's own family parameter `z = G.z`.
* **F2 — clause (i)'s "of `U`".**  `evenEmbₐ` upgrades the even embedding to an `A_z`-algebra
  map; `UevTorus = UevSubalg.map evenEmbₐ` exhibits `U^ev` as a genuine `A_z`-subalgebra **of the
  ambient torus**, `clause_i_ambient` identifies its members, and `UevTorusEquiv` is the
  `A_z`-algebra isomorphism onto it.
* **F3 — the centre object.**  `ZUevAmbient = UevSubalg ⊓ (center of the ambient `U`) ∘ evenEmbₐ`
  is `goalv0a` Def 3 literally (the centre of the *ambient base-changed* algebra, not of the even
  algebra).  `ZTorus_eq_top` proves the ambient centre is everything (commutativity) and
  `ZUev_eq_ZUevAmbient` proves the two readings coincide — the coincidence is *proved*, not
  assumed, and both forms of clause (ii) are recorded (`clause_ii`, `clause_ii_ambient`).

One recorded deviation remains and is a **strengthening**, not a gap (verification finding F4):
the ambient coefficient field is `K₁ = Frac(ℤ[q^±,z^±]) = ℚ(q,z) ⊋ K_z = ℚ(q)[z^{±1}]`, so every
statement below quantifies over a larger algebra than `goalv0a` asks for.

## Status (M2, revised wave 3)

Complete and `sorry`-free: all three clauses are proved in both the even-coordinate and the
ambient form, and `GOALv0a` bundles them over `K₁`.
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

/-! ## 1. `U^ev = 𝒩^ev` as an `A_z`-subalgebra (clause (i)) -/

/-- `𝒩^ev` contains the image of `A_z`: `ev_χ` fixes `A_z` pointwise (`PROOFv0a` clause (i)). -/
theorem Newton_algebraMap (r : ↥(AzSubring (K := K))) :
    Newton (G := G) (algebraMap (↥(AzSubring (K := K))) (Frame K) r) := by
  have h : algebraMap (↥(AzSubring (K := K))) (Frame K) r = LaurentPolynomial.C (r : K) := rfl
  intro χ
  rw [h]
  simp only [Az, grid_C]
  exact r.2

/-- **`U^ev`** — the even hybrid family integral form `U^ev = 𝒩^ev` (`goalv0a` Def 3), as an
`A_z`-subalgebra of the even toral algebra.  It is an intersection of the subrings
`ev_χ^{-1}(A_z)`, each containing `A_z` (`PROOFv0a` clause (i)). -/
noncomputable def UevSubalg : Subalgebra (↥(AzSubring (K := K))) (Frame K) where
  carrier := {t | Newton (G := G) t}
  mul_mem' := Newton_mul
  add_mem' := Newton_add
  algebraMap_mem' := Newton_algebraMap
  zero_mem' := Newton_zero
  one_mem' := Newton_one

/-- **`goalv0a` clause (i)** — `U^ev` is an `A_z`-subalgebra of `U`, with underlying set exactly
`𝒩^ev`.  (`UevSubalg` is a bundled `Subalgebra`; this records that its carrier is `𝒩^ev`.) -/
theorem clause_i (t : Frame K) : t ∈ UevSubalg (G := G) ↔ Newton (G := G) t := Iff.rfl

/-! ### The even embedding is injective (clause (i), ambient form)

`evenEmb` doubles toral exponents, `Y̌^n ↦ (T⁺)^{2n}`; doubling is injective on `ℤ`, so the
map is injective coefficientwise. -/

/-- `evenEmb` on toral monomials: `Y̌^n ↦ (T⁺)^{2n}`. -/
theorem evenEmb_T (n : ℤ) : evenEmb (T n : Frame K) = (T (2 * n) : Torus K) := by
  unfold evenEmb
  rw [LaurentPolynomial.eval₂_T, val_unit_T_zpow]
  congr 1
  ring

/-- `evenEmb` on general monomials `c·Y̌^n`. -/
theorem evenEmb_C_mul_T (a : K) (n : ℤ) :
    evenEmb (LaurentPolynomial.C a * T n : Frame K)
      = (LaurentPolynomial.C a * T (2 * n) : Torus K) := by
  rw [map_mul, evenEmb_T]
  congr 1
  unfold evenEmb
  rw [LaurentPolynomial.eval₂_C]

/-- Coefficient extraction through the even embedding: the `2n`-th coefficient of `evenEmb f`
is the `n`-th coefficient of `f`. -/
theorem evenEmb_apply_two_mul (f : Frame K) (n : ℤ) : (evenEmb f) (2 * n) = f n := by
  induction f using LaurentPolynomial.induction_on' with
  | add p q hp hq =>
    rw [map_add]
    simp [hp, hq]
  | C_mul_T m a =>
    rw [evenEmb_C_mul_T, ← LaurentPolynomial.single_eq_C_mul_T,
      ← LaurentPolynomial.single_eq_C_mul_T, Finsupp.single_apply, Finsupp.single_apply]
    by_cases h : m = n
    · subst h; simp
    · rw [if_neg h, if_neg (by omega)]

/-- Clause (i), ambient form: `U^ev` sits inside `U` as an `A_z`-subalgebra, via the even
embedding `Y̌ ↦ (T⁺)²`.  (`evenEmb` is injective, so the image is a subalgebra isomorphic to
`UevSubalg`.) -/
theorem clause_i_in_torus : Function.Injective (evenEmb (K := K)) := by
  intro f g h
  ext n
  rw [← evenEmb_apply_two_mul f n, ← evenEmb_apply_two_mul g n, h]

/-! ### `U^ev` as a subalgebra **of the ambient torus** (verification finding F2)

`clause_i` exhibits `U^ev` as a `Subalgebra` of the even coordinate algebra `Frame K`, and
`clause_i_in_torus` records that `Frame K` injects into `U = Torus K`.  `goalv0a` clause (i) says
`U^ev` is an `A_z`-subalgebra **of `U`**; that is what the three declarations below state
directly. -/

/-- The even embedding `Y̌ ↦ (T⁺)²` as an `A_z`-**algebra** map (not merely a ring map): it is
`eval₂` at the constant map `C`, so it fixes `A_z ⊆ K` pointwise. -/
noncomputable def evenEmbₐ : Frame K →ₐ[↥(AzSubring (K := K))] Torus K :=
  { evenEmb with
    commutes' := fun r => by
      change evenEmb (LaurentPolynomial.C (r : K)) = LaurentPolynomial.C (r : K)
      unfold evenEmb
      rw [LaurentPolynomial.eval₂_C] }

@[simp] theorem coe_evenEmbₐ : ⇑(evenEmbₐ (K := K)) = evenEmb := rfl

/-- **`U^ev` inside `U`** — the image of `UevSubalg` under the even embedding, a genuine
`A_z`-subalgebra of the ambient torus `U = Torus K` (`goalv0a` clause (i), ambient form). -/
noncomputable def UevTorus : Subalgebra (↥(AzSubring (K := K))) (Torus K) :=
  (UevSubalg (G := G)).map (evenEmbₐ (K := K))

/-- **`goalv0a` clause (i), ambient form** — the members of the `A_z`-subalgebra `UevTorus ⊆ U`
are exactly the images of the even Newton elements. -/
theorem clause_i_ambient (t : Frame K) :
    evenEmb t ∈ UevTorus (G := G) ↔ Newton (G := G) t := by
  constructor
  · rintro ⟨s, hs, hst⟩
    exact (clause_i_in_torus hst) ▸ hs
  · intro h
    exact ⟨t, h, rfl⟩

/-- `U^ev` and its image in `U` are isomorphic as `A_z`-algebras (`evenEmb` is injective). -/
noncomputable def UevTorusEquiv :
    UevSubalg (G := G) ≃ₐ[↥(AzSubring (K := K))] UevTorus (G := G) :=
  Subalgebra.equivMapOfInjective _ _ clause_i_in_torus

/-! ## 2. The Harish–Chandra projection and the (trivial) Weyl action -/

/-- **`HC`** — the Harish–Chandra projection.  Every element of `U` is toral (`Φ = ∅`), so
`HC = id_U` (`goalv0a` Def 4); it restricts to the identity on the even part. -/
noncomputable def HC : Frame K →ₐ[K] Frame K := AlgHom.id K (Frame K)

@[simp] theorem HC_apply (t : Frame K) : HC t = t := rfl

/-- **`W`** — the Weyl group of `GL₁`, `W = {1}` (`goalv0a` §1). -/
abbrev WeylGL1 : Type := Unit

/-- The shifted Weyl action `w(Y_n) = Y_{wn}` (`goalv0a` Def 4).  `W = {1}`, so it is trivial.
**This proves nothing about Weyl invariance in higher rank** (trap 3). -/
noncomputable def weyl (_w : WeylGL1) : Frame K ≃ₐ[K] Frame K := AlgEquiv.refl

/-- **`(𝒩^ev)^W`** — the `W`-invariants of the even Newton lattice (`goalv0a` clause (ii) target).
Degenerate: `W = {1}`, so the invariance condition is vacuous. -/
noncomputable def NevW : Subalgebra (↥(AzSubring (K := K))) (Frame K) where
  carrier := {t | Newton (G := G) t ∧ ∀ w : WeylGL1, weyl w t = t}
  mul_mem' := fun hf hg => ⟨Newton_mul hf.1 hg.1, fun _ => rfl⟩
  add_mem' := fun hf hg => ⟨Newton_add hf.1 hg.1, fun _ => rfl⟩
  algebraMap_mem' := fun r => ⟨Newton_algebraMap r, fun _ => rfl⟩
  zero_mem' := ⟨Newton_zero, fun _ => rfl⟩
  one_mem' := ⟨Newton_one, fun _ => rfl⟩

/-- **`Z(U^ev)`** — the central part `U^ev ∩ Z(U ⊗_{K_z} Frac(A_z))` (`goalv0a` Def 3).  Over
`K₁ = Frac(A_z)` the base change is already performed, so the second factor is the centre of the
ambient algebra. -/
noncomputable def ZUev : Subalgebra (↥(AzSubring (K := K))) (Frame K) :=
  UevSubalg (G := G) ⊓ Subalgebra.center (↥(AzSubring (K := K))) (Frame K)

/-- **(Degenerate.)** `U` is commutative, so `Z(U^ev) = U^ev = 𝒩^ev` (`PROOFv0a` clause (ii)). -/
theorem mem_ZUev_iff (t : Frame K) : t ∈ ZUev (G := G) ↔ Newton (G := G) t := by
  rw [ZUev, Algebra.mem_inf]
  refine ⟨fun h => h.1, fun h => ⟨h, ?_⟩⟩
  rw [Subalgebra.mem_center_iff]
  intro b
  exact mul_comm b t

/-- **(Degenerate.)** `W = {1}`, so `(𝒩^ev)^W = 𝒩^ev` (`PROOFv0a` clause (ii)).
This says **nothing** about Weyl invariance in higher rank (trap 3). -/
theorem mem_NevW_iff (t : Frame K) : t ∈ NevW (G := G) ↔ Newton (G := G) t :=
  ⟨fun h => h.1, fun h => ⟨h, fun _ => rfl⟩⟩

/-- **`goalv0a` clause (ii)** — the Harish–Chandra projection restricts to an isomorphism of
`A_z`-algebras `HC : Z(U^ev) ≅ (𝒩^ev)^W`.  The second conjunct pins that the isomorphism **is**
`HC` (the identity on toral elements), not merely some abstract isomorphism. -/
theorem clause_ii :
    ∃ e : ZUev (G := G) ≃ₐ[↥(AzSubring (K := K))] NevW (G := G),
      ∀ t : ZUev (G := G), ((e t : Frame K)) = HC (t : Frame K) := by
  have hEq : ZUev (G := G) = NevW (G := G) :=
    SetLike.ext fun t => (mem_ZUev_iff t).trans (mem_NevW_iff t).symm
  exact ⟨Subalgebra.equivOfEq _ _ hEq, fun t => rfl⟩

/-! ### The centre of the **ambient** algebra (verification finding F3)

`goalv0a` Def 3 reads `Z(U^ev) = U^ev ∩ Z(U ⊗_{K_z} Frac(A_z))`: the second factor is the centre
of the *full, base-changed* algebra `U`, not of the even part.  `ZUev` above takes the centre of
the even algebra.  Over `K₁ = Frac(A_z)` the base change is already performed, so the ambient
algebra is `Torus K` and the literal reading is `ZUevAmbient` below.  The two readings coincide
here — and that coincidence is **proved** (`ZTorus_eq_top`, `ZUev_eq_ZUevAmbient`), not assumed. -/

/-- **`Z(U ⊗_{K_z} Frac(A_z))`** — the centre of the ambient (already base-changed) algebra `U`,
as an `A_z`-subalgebra of `Torus K`. -/
noncomputable def ZTorus : Subalgebra (↥(AzSubring (K := K))) (Torus K) :=
  Subalgebra.center (↥(AzSubring (K := K))) (Torus K)

/-- `U` is commutative (`Φ = ∅`), so its centre is everything.  This is the fact that makes the
even-algebra and ambient-algebra readings of `goalv0a` Def 3 agree. -/
theorem ZTorus_eq_top : ZTorus (K := K) = ⊤ := by
  ext x
  simp only [ZTorus, Subalgebra.mem_center_iff, Algebra.mem_top, iff_true]
  intro b
  exact mul_comm b x

/-- **`Z(U^ev)`, `goalv0a` Def 3 literally** — `U^ev ∩ Z(U ⊗_{K_z} Frac(A_z))`, the intersection
taken inside `U` along the even embedding. -/
noncomputable def ZUevAmbient : Subalgebra (↥(AzSubring (K := K))) (Frame K) :=
  UevSubalg (G := G) ⊓ (ZTorus (K := K)).comap (evenEmbₐ (K := K))

/-- **(Degenerate.)** `U` is commutative, so the literal `Z(U^ev)` is again `𝒩^ev`. -/
theorem mem_ZUevAmbient_iff (t : Frame K) :
    t ∈ ZUevAmbient (G := G) ↔ Newton (G := G) t := by
  rw [ZUevAmbient, Algebra.mem_inf]
  refine ⟨fun h => h.1, fun h => ⟨h, ?_⟩⟩
  rw [Subalgebra.mem_comap, ZTorus, Subalgebra.mem_center_iff]
  intro b
  exact mul_comm b _

/-- **The two readings of `goalv0a` Def 3 agree** — the centre of the even algebra and the
centre of the ambient base-changed algebra cut out the same `A_z`-subalgebra of `𝒩^ev`. -/
theorem ZUev_eq_ZUevAmbient : ZUev (G := G) = ZUevAmbient (G := G) :=
  SetLike.ext fun t => (mem_ZUev_iff t).trans (mem_ZUevAmbient_iff t).symm

/-- **`goalv0a` clause (ii), with the centre object of Def 3 taken literally** — the
Harish–Chandra projection restricts to an isomorphism of `A_z`-algebras
`HC : U^ev ∩ Z(U ⊗_{K_z} Frac(A_z)) ≅ (𝒩^ev)^W`. -/
theorem clause_ii_ambient :
    ∃ e : ZUevAmbient (G := G) ≃ₐ[↥(AzSubring (K := K))] NevW (G := G),
      ∀ t : ZUevAmbient (G := G), ((e t : Frame K)) = HC (t : Frame K) := by
  have hEq : ZUevAmbient (G := G) = NevW (G := G) :=
    SetLike.ext fun t => (mem_ZUevAmbient_iff t).trans (mem_NevW_iff t).symm
  exact ⟨Subalgebra.equivOfEq _ _ hEq, fun t => rfl⟩

/-! ## 3. Clause (iii) restated here for the bundle -/

/-- **`goalv0a` clause (iii)** — `𝒩^ev = Σ_{u ∈ ℤ} Σ_{r ≥ 0} A_z · Y̌^u ν_r(Y̌)`. -/
theorem clause_iii [QGeneric K] (t : Frame K) :
    Newton (G := G) t ↔ t ∈ Submodule.span (AzSubring (K := K)) (nuGenSet (G := G)) :=
  Newton_iff_mem_span t

/-! ## 4. The `GOALv0a` bundle, pinned over the concrete family field `K₁` -/

open FamilyField1

/-- The three clauses of `goalv0a`, over the concrete `GL₁` family field
`K₁ = Frac(ℤ[q^±, z^±])` (so that `A_z` really is `ℤ[q^±, z^±]`, `az1_model_equiv`).

Wave-3 note: the first four fields are the wave-2 bundle **verbatim**; the last four are the
modelling steps that were previously assumed (verification findings F1–F3) and are now proved.
Nothing was weakened; the structure is strictly stronger than before. -/
structure GOALv0aStatement : Prop where
  /-- (i) `U^ev = 𝒩^ev` is an `A_z`-subalgebra of `U`. -/
  subalgebra : ∀ t : Frame K1, t ∈ UevSubalg (G := instGL2ParamsK1) ↔ Newton t
  /-- (i, ambient) the even part embeds in `U` as `Y̌ ↦ (T⁺)²`. -/
  even_embedded : Function.Injective (evenEmb (K := K1))
  /-- (ii) `HC : Z(U^ev) ≅ (𝒩^ev)^W` is an `A_z`-algebra isomorphism, and it is `HC`. -/
  hc_iso : ∃ e : ZUev (G := instGL2ParamsK1) ≃ₐ[↥(AzSubring (K := K1))] NevW (G := instGL2ParamsK1),
      ∀ t : ZUev (G := instGL2ParamsK1), ((e t : Frame K1)) = HC (t : Frame K1)
  /-- (iii) `𝒩^ev = Σ_{u ∈ ℤ} Σ_{r ≥ 0} A_z · Y̌^u ν_r(Y̌)`. -/
  newton_span : ∀ t : Frame K1,
      Newton t ↔ t ∈ Submodule.span (AzSubring (K := K1)) (nuGenSet (G := instGL2ParamsK1))
  /-- (Def 1, F1) the algebra presented by `goalv0a` Def 1 over the family parameter `z = G.z`
  **is** the Laurent torus this development uses as `U`. -/
  presented : Nonempty (Presentation.U (K := K1) (instGL2ParamsK1.z) ≃ₐ[K1] Torus K1)
  /-- (Def 1, F1) the monomials `(T⁺)^w = K_{w,+}`, `w ∈ ℤ`, form a basis of the presented `U`. -/
  torus_basis : ∃ b : Module.Basis ℤ K1 (Presentation.U (K := K1) instGL2ParamsK1.z),
      ∀ w : ℤ,
        b w = (Presentation.uData instGL2ParamsK1.z (Presentation.z_ne_zero K1)).Kplus w
  /-- (i, ambient, F2) `U^ev` is an `A_z`-subalgebra **of `U`**, with the stated members. -/
  subalgebra_of_U : ∀ t : Frame K1,
      evenEmb t ∈ UevTorus (G := instGL2ParamsK1) ↔ Newton t
  /-- (ii, F3) clause (ii) with `Z(U^ev)` read literally as `U^ev ∩ Z(U ⊗_{K_z} Frac(A_z))`,
  together with the proof that this agrees with the even-algebra reading. -/
  hc_iso_ambient :
      ZUev (G := instGL2ParamsK1) = ZUevAmbient (G := instGL2ParamsK1) ∧
      ∃ e : ZUevAmbient (G := instGL2ParamsK1)
            ≃ₐ[↥(AzSubring (K := K1))] NevW (G := instGL2ParamsK1),
        ∀ t : ZUevAmbient (G := instGL2ParamsK1), ((e t : Frame K1)) = HC (t : Frame K1)

/-- **GOALv0a** — the bundled statement.  Every field is the corresponding clause theorem
specialised to `K₁`; no new mathematical content is introduced here. -/
theorem GOALv0a : GOALv0aStatement where
  subalgebra := fun t => clause_i t
  even_embedded := clause_i_in_torus
  hc_iso := clause_ii
  newton_span := fun t => clause_iii t
  presented := ⟨Presentation.modelEquiv K1⟩
  torus_basis :=
    ⟨Presentation.uBasis _ (Presentation.z_ne_zero K1), fun w => Presentation.uBasis_apply _ _ w⟩
  subalgebra_of_U := fun t => clause_i_ambient t
  hc_iso_ambient := ⟨ZUev_eq_ZUevAmbient, clause_ii_ambient⟩

end GL1Newton
end A1
end HybridQuantumLean
