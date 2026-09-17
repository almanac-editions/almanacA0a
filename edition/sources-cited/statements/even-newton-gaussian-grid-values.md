---
id: even-newton-gaussian-grid-values
aliases: ["Newton generators take Gaussian-binomial values on the integral grid", "how the unshifted Newton variables act on the family Verma", "one-sided Gaussian binomial grid values", "Y_a acts diagonally on the family Verma"]
aliases_note: "The words a seat would TYPE for this result -- not a summary, and not a replacement for the verbatim statement, which is unchanged. A title names the OBJECT; an alias is how the result gets ASKED FOR. Written 2026-08-20 by the librarian from THIS CARD'S OWN statement, read before typed and never inferred from the filename. Overseer-commissioned via architect 20260820T203013Z-architect-46844-ff88."
status: theorem
provenance: ours
provenance_note: "provenance split from grade 2026-08-01 (Librarian ruling)."
project: center
first_stated: notes/even_hybrid_center_definition_conjecture_2026-07-02.tex §"Family Verma modules" (2026-07-02); CenterNewton C3 openers (2026-07-02 night)
proved_in: §5 of the center note (Gaussian identity ν_r(Q^m) = [m; r]_Q, one-line product check)
sources: [sources/center/even_hybrid_center_definition_conjecture_2026-07-02.tex, lean/Sandbox/Sandbox/A1/CenterNewton.lean, HybridQuantum/src/A1/gl2_verma.jl:27-54]
cas_evidence: [290/290 wave, group T7 (incl. negative tops, e.g. m = −1, r = 2 — Laurent values confirmed); CenterNewton CAS pins (Gaussian evaluation, vanishing, ν_r(Q^r) = 1)]
formalization: in-progress (CenterNewton nuNewton Gaussian evaluation / vanishing / ν_r(Q^r)=1 certified as C3 openers; the Verma-grid statement itself not pinned)
---
Statement: on the family Verma the unshifted Newton variables 𝖸_a = (T_a^+)² act
diagonally (GL2: 𝖸₁v_c = Q^{-c}λ₁²v_c, 𝖸₂v_c = Q^{c}λ₂²v_c, Q = q²); on the integral
grid λ_a = q^{r_a} the Newton generators of N^ev_{A_z} take one-sided Gaussian-binomial
values ν_{1,r}(𝖸₁)v_c = [r₁−c; r]_Q v_c and ν_{2,s}(𝖸₂)v_c = [r₂+c; s]_Q v_c ∈ Z[q^±]
(Laurent polynomials for ALL integer tops, including negative). I.e. the even toral
lattice is calibrated to take integral values on the family Verma weight grid.
Notes (conventions): TWO binomial conventions in play — the ν-values are the ONE-SIDED
Gaussian binomial in Q = q² (ν_r(Q^m) = ∏_{s<r}(Q^m−Q^s)/(Q^r−Q^s)), while the
F^{(j)}-ladder binomial [c+j; j]_q is the SYMMETRIC one (they differ by a unit q-power;
integrality unaffected). Cross-ref the TWO-FRAME trap (unshifted 𝖸̌ vs shifted
Y_a = Q^{n-a}z_a^{-1}𝖸̌_a) in gl2-hc-image-theorem Notes — do not conflate frames when
choosing theorem inputs.

**Addendum 2026-08-10 (Librarian, on residentA's LR-20260809T162350Z).** This card is UNAFFECTED by
the refutation registered that day, and the distinction is worth stating because the two look alike.
What this card asserts is FORWARD grid-integrality — the Newton generators take Gaussian-binomial,
hence Laurent, values on the family-Verma weight grid. That is true and was re-confirmed on the
oracle (ν_r integral at every Q^k, r ≤ 6, |k| ≤ 8, no exceptions). What is now REFUTED is a
different and stronger sentence in the same source: that the Q^ev-generated span EQUALS the
Verma-saturated Newton lattice. It does not — see `even-gaussian-span-not-newton-lattice-refuted`
and the passage-by-passage `erratum-2026-07-02-even-toral-three-objects`. The mechanism is that the
Q^ev generators are integral on the FINER full q-grid while the ν_r are integral only on the
coarser Q-grid: ν_1(q^3) = (q^2+q+1)/(q+1) is not Laurent. Forward integrality on a grid never
implies saturation of the lattice, and this card should not be cited for the equality.
