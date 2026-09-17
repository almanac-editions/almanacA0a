---
id: gl2-hc-image-theorem
aliases: ["GL_2 centre of the even hybrid algebra", "Harish-Chandra isomorphism for GL_2", "the rank-one centre theorem", "goalv1", "every shifted-Weyl-invariant even Newton function has a unique integral central lift"]
aliases_note: "The words a seat would TYPE for this result, not a summary and not a replacement for the verbatim statement, which is unchanged. A title names the OBJECT; an alias is how the result gets ASKED FOR. Written 2026-08-20 by the librarian from THIS CARD'S OWN statement -- read before typed, never inferred from the filename. Overseer-commissioned (architect ...46844-ff88): the estate should be able to find every result it has proved by the vocabulary it would use to propose one."
status: theorem
provenance: ours
provenance_note: "provenance split from grade 2026-08-01 (Librarian ruling)."
project: center
first_stated: rank-one conjecture (pre-v99)
proved_in: v99, retained in v104 (sources/fu_blm/hybrid_fu_blm_v104.tex §"The rank-one Harish–Chandra image theorem", thm ~L4085)
sources: [sources/fu_blm/hybrid_fu_blm_v104.tex, sources/center/even_hybrid_center_definition_conjecture_2026-07-02.tex]
cas_evidence: [Conjecture-B cocycle deg ≤ 5, central series residuals 0, sandbox C0–C5 records]
formalization: ✅ FULLY CERTIFIED 2026-07-09 — gl2_center_closed_newton over K0 (Newton lattice BY DEFINITION; HybridQuantumLean/A1/UQ/CenterClosedNewtonProof.lean; goal_gate 9/9, independent audit PASS, separator B1 kernel-certified vs the 2026-07-06 polynomial-form gl2_center_closed). Earlier: CERTIFIED in module realization, surjectivity direction (2026-07-03) — GL2.gl2_center_main (HybridQuantumLean/A1/CenterMain.lean; final sweep 400 decls all exactly the axiom triple); all five v104 ingredients certified (map in sandboxv1/REPORT.md); NOT yet: abstract U_A form + necessity/⊆ (λ-transcendence layer), two-variable even-grid bridge
---
Statement: HC : Z(U^{hyb,ev}_{A_z}) ≅ (N^ev_{A_z})^{s₁} — every shifted-Weyl-invariant
even-Newton toral function has a unique even-hybrid integral central lift.
Proof structure (v104): injectivity = PBW triangularity; image = integral form + rational
HC invariance; surjectivity = lem:v99-straightening + prop:v99-theta-recursion
(Θ_r = (−q)^⌊r/2⌋ τ^{−⌊r/2⌋} W_r f) + lem:v99-reflected (anti-involution; s₁-invariance
enters HERE) + prop:v99-finite-support (root-string degree) + prop:v99-integral-rows
(paired-wall divisibility, τ-conjugated).
Notes: convention trap — source Casimir is eF-order, DCK rows are Fe-order; translation
absorbs B(c)(K₊−K₋) into row 0 (certified: GL2.casimirRow0).
Notes (2026-07-03, sandbox V4 micro-check): TWO-FRAME TRAP — the hypothesis lattice N^ev
is Newton in the UNSHIFTED Y̌ᵢ = (Tᵢ⁺)², while s₁-invariance is natural in the SHIFTED
Y₁ = Qz₁⁻¹Y̌₁, Y₂ = z₂⁻¹Y̌₂. ν_d(Y_shifted) seeds are NOT in N^ev (not valid theorem
inputs); monomial-symmetric shifted seeds (Y₁Y₂, Y₁²+Y₂², e₁) are. Any formalization or
CAS probe must not conflate the frames (sandboxv0/scratch/gl2_center_c5_v4_micro_out.md).
