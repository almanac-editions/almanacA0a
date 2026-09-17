# Adversarial referee report — PROOFv0a.tex

**Target:** `sandboxv0a/informal/PROOFv0a.tex` (stand-alone proof of the three clauses of goalv0a)
**Against:** `sandboxv0a/informal/goalv0a.tex` (signed, tex sha `91a50173…5a7e`, lock `goalv0a.lock.json`)
**Companion consulted:** `informal/goal_memory.md`; HH transcript
`corpus/literature/transcribed/harman-hopkins-quantum-integer-valued-polynomials.md`
**Oracle:** warm CAS on 127.0.0.1:9917 via `sandboxv0/engine/cas_client.sh` (AbstractAlgebra rational
function field in `q`, auto-simplifying; `Q := q^2`). Date: 2026-07-20.

## Verdict: **CONFIRM-WITH-FINDINGS**

The proof is mathematically correct and byte-faithful to the signed statement. Every load-bearing
step (reflection formula and its exponent, unitriangularity, the Z[Q^{±1}]-inverse base-change, the
z-spectator reduction, Laurent clearing, window-to-full) survives adversarial recomputation. The
findings below are **cosmetic citation/notation slips confined to the Attribution remark** and one
non-blocking phrasing over-claim; **none** weakens or strengthens the theorem or breaks any argument.

---

## Attack-by-attack results

### (1) Reflection formula ν_r(Q^{−n}) = (−1)^r Q^{−nr−C(r,2)} [n+r−1, r]_Q — CONFIRMED
Recomputed `ν_r(Q^{−n}) − (−1)^r Q^{−nr−C(r,2)}·[n+r−1,r]_Q` from first principles for four (n,r),
including a hostile pair. Exact client expressions (form
`prod([ (q^(-2n) - q^(2t))/(q^(2r) - q^(2t)) for t in 0:r-1 ]) - (-1)^r * q^(-2*n*r - r*(r-1)) * prod([ (q^(2*(n-1+i)) - 1)/(q^(2*i) - 1) for i in 1:r ])`):

- (n=2,r=3) → `OK	0`
- (n=3,r=2) → `OK	0`
- (n=1,r=4) → `OK	0`
- (n=5,r=4) hostile → `OK	0`

The exponent is exactly `Q^{−nr−C(r,2)}`, i.e. `q` to the power `−2nr − r(r−1)`. Cross-check:
`ν_2(Q^{−3})` returned `(q^8+q^6+2q^4+q^2+1)//q^14`, an even-power (hence Z[Q^{±1}]) Laurent
polynomial equal to `Q^{−7}[4,2]_Q` as the formula predicts. Independent sympy check
`hh_dictionary_check.py` test C → **PASS**. Lemma 1(c) is correct.

### (2) Unitriangularity ν_r(Q^m)=0 (m<r), ν_r(Q^r)=1 — CONFIRMED
Client form `prod([ (q^(2m) - q^(2t))/(q^(2r) - q^(2t)) for t in 0:r-1 ])`:

- Diagonal: `ν_3(Q^3)=ν_4(Q^4)=ν_5(Q^5)` → `OK	1`, `OK	1`, `OK	1`.
- Sub-diagonal: `ν_3(Q^0)=ν_3(Q^1)=ν_3(Q^2)=0`; `ν_4(Q^1)=ν_4(Q^3)=0` → all `OK	0`.
- Part (b): `ν_3(Q^5)` → `OK	q^12+q^10+2*q^8+2*q^6+2*q^4+q^2+1`, identical to the explicit Gaussian
  binomial `[5,3]_Q`; `ν_2(Q^4)−[4,2]_Q → OK	0`. sympy test A → **PASS**.
- The q-Pascal recurrence invoked in Lemma 1(b) proof, `[5,3]_Q − ([4,2]_Q + Q^3[4,3]_Q)` →
  `OK	0` (matches transcript eq:qpascal, `[n,k]_Q = q^k[n−1,k]_Q + [n−1,k−1]_Q`).

So V = (B_r(m))_{0≤m,r≤d} is lower unitriangular, det V = 1. Correct.

### (3) Base change Q(q) vs Q(Q), Q=q² — CONFIRMED, and the direct argument is airtight
`Z[Q^{±1}] = Z[q^{±2}] ⊆ Z[q^{±1}] ⊆ A_z` is correct. The reverse-inclusion coordinates are obtained
by the **direct** route the proof itself gives as "most directly": V is lower-unitriangular with
entries in Z[Q^{±1}], so V⁻¹ = (I+N)⁻¹ = I−N+N²−… is lower-unitriangular with entries in the same ring
Z[Q^{±1}] ⊆ A_z; with the value vector v ∈ A_z^{d+1}, c = V⁻¹v ∈ A_z^{d+1}. This needs **no**
flatness hypothesis. The additional "free with basis {1,q}, hence flat, grade-preserving" paragraph
is correct but redundant (not load-bearing). The remark `Q(Q) ∩ Z[q^{±1}] = Z[Q^{±1}]` is also true
(a Laurent poly in Z[q^{±1}] fixed by q↦−q has only even powers) but is likewise not load-bearing.
No error; flatness/window-finiteness is genuinely justified because the window matrix is finite
(d+1 square) and unitriangular.

### (4) z-spectator: evaluation acts z-coefficient-wise — CONFIRMED
ev_χ is the K_z-algebra substitution Y̌ ↦ Q^χ = q^{2χ}; the substituted value lies in Z[q^{±1}] and
carries no z, while coefficients live in K_z = Q(q)[z^{±1}]. Hence for g = Σ_r c_r ν_r with
c_r = Σ_k c_{r,k} z^k, one has ev_χ(g) = Σ_k (Σ_r B_r(χ) c_{r,k}) z^k, so z-degree is preserved and
membership ev_χ(g) ∈ A_z is equivalent, per fixed k, to the same unitriangular system over Z[Q^{±1}]
with RHS in Z[q^{±1}]. The reduction is valid.

### (5) Laurent clearing — CONFIRMED (both directions)
Y̌^N f ∈ K_z[Y̌] for N ≥ max negative exponent; ev_χ(Y̌^N f) = Q^{Nχ}·ev_χ(f) with Q^{Nχ} a unit of
A_z, so f ∈ N^ev ⇔ Y̌^N f ∈ N^ev, and the decomposition transfers back by the same unit. Correct.
`ν_2(Q^{−3})` being a genuine Z[Q^{±1}]-Laurent value confirms the unit-multiplication mechanics.

### (6) Window-to-full (union over d and shifts u) — CONFIRMED, no gap
Lemma 3 uses only the finite window χ = 0,…,d (a *subset* of the all-χ integrality available from
g ∈ N^ev), which already pins c_r ∈ A_z by unitriangularity; union over d covers all polynomial
degrees, and Laurent clearing places every f in the u = −N slice of S = Σ_u Σ_r A_z Y̌^u ν_r(Y̌).
Complete partition of the χ-cases (χ≥r: 1(b); 0≤χ<r: 1(a); χ<0: 1(c)). No gap.

### (7) Citation audit — MATCHES (one cosmetic notation slip, F1)
- `Prop.~§1.2, prop:qbinom` ↔ transcript line 43 `Proposition [§1.2] {label: prop:qbinom}`. ✔
- `Prop.~§4.3, prop:localization`, R_q = R_q^+ ⊗_{Z[q]} Z[q^{±1}] ↔ transcript line 91–92. ✔
- z-variable / Cartan-part-of-Lusztig remark ↔ transcript §4 remark (line 96). ✔
- arXiv:1601.06110 ↔ transcript line 5. ✔
- "their q = our Q = q²" ↔ dictionary card / transcript §5 (their single deformation parameter). ✔
- Node map: Y̌ = 1 + (Q−1)x sends x=[n]_Q ↦ Q^n (checked: 1+(Q−1)(Q^n−1)/(Q−1) = Q^n). ✔
  Term-by-term basis transport HH q-binomial |_{x=(X−1)/(Q−1)} = ν_k(X): sympy test B → **PASS**.
- **Lean anchors verified by reading the files:**
  `Sandbox/A1/UQ/NewtonSpan.lean:298` is `theorem nuNewtonIntegral_iff_mem_span …` (name and line
  exact; docstring matches the quoted description "grid criterion = membership in the A_z-span of the
  product Newton generators"). `Sandbox/A1/UQ/CenterNewtonTransfer.lean:604` is
  `theorem gl2_center_closed_newton_laurent …` (name and line exact; docstring matches "passage to
  the full Laurent even lattice"). Both exist at the quoted lines. ✔

### (8) Byte-faithfulness to goalv0a.tex — FAITHFUL (one non-blocking phrasing point, F3)
Definitions of A_z, K_z, Q; the algebra U and its relations; toral/even/Y̌; N^ev; U^{hyb,ev}=N^ev and
Z(U^ev)=U^ev∩Z(U⊗_{K_z}Frac(A_z)); HC=id, W={1}, (N^ev)^W=N^ev; ν_r — all reproduced without change.
Goal clauses (i),(ii),(iii) are stated identically (the boxed HC iso and the exact sum
Σ_{u∈Z}Σ_{r≥0} A_z Y̌^u ν_r(Y̌)). No weakening, no strengthening, no convention change. In particular
the four documented traps are respected: Λ=Z (Y̌ present, N^ev ⊋ A_z[Y̌^±]), NO q-shift (ev_χ(Y̌)=Q^χ
with no spurious Q; 2ρ=0), W trivial (clause (ii) degenerates cleanly, no Weyl claim leaked), and the
Newton lattice is strictly larger than the monomial ring (ν_r is the reason). The clause (ii)
identity chain Z(U^ev)=U^ev∩(U⊗Frac(A_z))=U^ev is valid because K_z ↪ Frac(A_z)=Q(q,z) is injective
and U is K_z-free, so U ↪ U⊗Frac(A_z).

---

## Findings (all minor; none blocks acceptance)

1. **[cosmetic, citation notation — Attribution, PROOFv0a.tex lines ~352 & ~361]** The HH q-binomial
   coefficient *polynomials* are typeset with the plain symbol `\binom{x}{k}` ("…freely generated …
   by the q-binomial coefficient polynomials $\binom{x}{k}$" and "carries each basis term
   $\binom{x}{k}$ onto $\nu_k(\Yc)$"). HH's object (prop:qbinom §1.2) is the q-deformed
   $\qbinom{x}{k}$ with denominator $q^{\binom{k}{2}}[k]_q!$ — distinct from the classical Pólya
   basis $\binom{x}{k}$ (prop:binom §1.1). The citation, the ring, and the prose ("q-binomial
   coefficient polynomials") are correct and the transport was CAS-verified (sympy test B); only the
   symbol is the un-deformed one. Recommend writing $\qbinom{x}{k}$ (or an explicit "HH's" glyph).

2. **[minor, notation collision — Attribution, PROOFv0a.tex line ~360]** The parenthetical
   "(equivalently their $z$-variable $z=(q-1)x+1$…)" quotes HH's formula in HH's $q$, but in this
   document $q$ denotes the honest square root with $Q=q^2$, so read literally in the proof's own
   notation the affine map is $z=(Q-1)x+1$, not $(q-1)x+1$. The primary, load-bearing substitution
   $\Yc = 1+(Q-1)x$ (same line) is written correctly in $Q$; the "their" qualifier makes the
   parenthetical a faithful source quote, but the dual use of the letter $q$ is a latent hazard.
   Recommend "(their $z$-variable, in their parameter $Q$: $z=(Q-1)x+1$)".

3. **[non-blocking phrasing — Conventions, PROOFv0a.tex lines ~70–71]** ev_χ is first defined as "the
   K_z-algebra homomorphism substituting the unit Q^χ for Y̌" (correct, well-defined, fixes K_z) and
   then also called "the unique A_z-linear ring homomorphism with ev_χ(Y̌)=Q^χ". Uniqueness among
   *merely A_z-linear* ring homomorphisms is not literally forced (one must also fix Q(q)); the map
   is pinned by being a K_z-algebra map, which the proof does state. goalv0a's own Def 2 says
   "A_z-linear map … determined by ev(Y̌)=Q^χ", so this inherits the source's looseness rather than
   introducing drift. N^ev is the identical set either way; no consequence for any argument.

## Oracle transcript (representative, exact replies)

```
$ cas_client.sh 'prod([ (q^(-2*2) - q^(2*t))/(q^(2*3) - q^(2*t)) for t in 0:2 ]) - (-1)^3 * q^(-2*2*3 - 3*2) * prod([ (q^(2*(2-1+i)) - 1)/(q^(2*i) - 1) for i in 1:3 ])'
OK	0                                   # reflection (n=2,r=3)
$ cas_client.sh 'prod([ (q^(-2*5) - q^(2*t))/(q^(2*4) - q^(2*t)) for t in 0:3 ]) - (-1)^4 * q^(-2*5*4 - 4*3) * prod([ (q^(2*(5-1+i)) - 1)/(q^(2*i) - 1) for i in 1:4 ])'
OK	0                                   # reflection (n=5,r=4) hostile
$ cas_client.sh 'prod([ (q^(2*3) - q^(2*t))/(q^(2*3) - q^(2*t)) for t in 0:2 ])'   # ν_3(Q^3)
OK	1
$ cas_client.sh 'prod([ (q^(2*2) - q^(2*t))/(q^(2*3) - q^(2*t)) for t in 0:2 ])'   # ν_3(Q^2), m<r
OK	0
$ cas_client.sh 'prod([ ((q^2)^(-3) - (q^2)^t)/((q^2)^2 - (q^2)^t) for t in 0:1 ])' # ν_2(Q^-3)
OK	(q^8 + q^6 + 2*q^4 + q^2 + 1)//q^14
$ python3 sandboxv0a/informal/hh_dictionary_check.py
A. nu_r(Q^m) == Gaussian binom [m,r]_Q          : PASS
B. HH q-binomial(x) |_{x=(X-1)/(Q-1)} == nu_k(X): PASS
C. reflection nu_r(Q^-n) = (-1)^r Q^{-rn-C(r,2)} [n+r-1,r]_Q: PASS
```

**Bottom line:** accept PROOFv0a.tex. The three clauses are proved correctly and the write-up is
faithful to the signed goalv0a.tex; only the three cosmetic/phrasing items above (all in the
Attribution/Conventions prose, none in a proof step) warrant a light editorial pass.
