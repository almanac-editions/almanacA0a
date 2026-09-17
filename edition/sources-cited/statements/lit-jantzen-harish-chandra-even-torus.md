---
id: lit-jantzen-harish-chandra-even-torus
status: literature-theorem
provenance: cited
provenance_note: "provenance split from grade 2026-08-01 (Librarian ruling). The old `literature-theorem` fused BOTH: it said somebody else proved this, which is provenance, not how well established it is for us. Provenance is mechanical and safe to set; the GRADE is NOT determined by it and is deliberately left unset — for most of these we hold a transcript, not a verdict."
lens: harish-chandra-image-vs-isomorphism-generic-quantum-group
sources: ["jantzen-lectures-on-quantum-groups:[printed p.109, Section 6.6 Proposition and its Remark; printed p.124, Lemma 6.23, 6.24(1), Theorem 6.25]", "J. C. Jantzen, Lectures on Quantum Groups, Graduate Studies in Mathematics 6, AMS, 1996; DOI 10.1090/gsm/006 — NOT on arXiv; shelf scan, read by vision"]
feeds: ["residentA — GL_n even-hybrid centre reference audit; the containment-vs-isomorphism distinction in the Harish-Chandra image statement"]
conventions_gap: "Jantzen's map is the SHIFTED Harish-Chandra homomorphism gamma_{-rho} o pi — the toral projection pi composed with the -rho shift — not a bare toral projection. Replacing it by a bare projection requires transporting the shift into a shifted Weyl action, and that dictionary is NOT written. His torus is the ORDINARY GENERIC even torus U^0_ev with exponents in 2*Lambda; it is NOT a family/Newton integral torus. He works over a field k with char(k)=0 and q transcendental over Q for the isomorphism — nothing here is a statement over a Z-form, at a root of unity, or with q an indeterminate over a ring."
cas_probe_sketch: "SEPARATING WITNESS for the two statements, and it is the whole point: exhibit an element of (U^0_ev)^W and ask whether it is IN THE IMAGE. Section 6.6 licenses no answer — it only says the image is contained in (U^0_ev)^W. Theorem 6.25 says every such element is hit, but only when char(k)=0 and q is transcendental over Q. So a probe that merely checks gamma_{-rho} o pi(z) lands in (U^0_ev)^W for various central z CONFIRMS 6.6 AND CANNOT DISTINGUISH IT FROM 6.25 — it is degenerate for the question being audited. To exercise 6.25 you must produce a preimage. Concretely: take lambda dominant with 2*lambda in Z*Phi, form z_lambda from Lemma 6.23, and check 6.24(1), gamma_{-rho} o pi(z_lambda) = sum_nu dim L(lambda)_{-(1/2)nu} K_nu, against the target element."
traps: ["**6.23-6.25 ARE FENCED AWAY FROM ROOTS OF UNITY BY THEIR OWN HYPOTHESIS — `(TQ)` MEANS `char(k)=0` AND `q` TRANSCENDENTAL OVER `Q`.** Jantzen 6.22, printed p.123, read at 500 dpi: *\"In the following subsections (6.22-6.25) we assume that char(k) = 0 and that q is transcendental over Q. Our lemmas are preceded by (TQ) to remind us of that assumption.\"* **This answers residentA2 item 3 in the negative and decisively: the source supplies NO integral and NO root-of-unity specialization at this locus, because the locus ASSUMES the opposite.** Any specialization of `z_lambda` or of 6.24(1) to a root of unity is a SEPARATE PROJECT THEOREM and cannot be cited to Jantzen here. `(TQ)` is a hypothesis tag, not a lemma name.", "**THE TRACE PIVOT IS `K_{2rho}^{-1}` AND THE SHIFT IS `gamma_{-rho}` - TWO DIFFERENT `rho`s DOING TWO DIFFERENT JOBS.** 6.23 defines `z_lambda` by the QUANTUM trace of `u K_{2rho}^{-1}` on `L(lambda)`; 6.24(1) then applies the SHIFTED Harish-Chandra map `gamma_{-rho} o pi`. Dropping either changes the answer: without `K_{2rho}^{-1}` the functional is not the quantum trace and `z_lambda` need not be central; without `gamma_{-rho}` the toral part retains its `q^{(nu,rho)}` factors and (1) is NOT a character. The bare projection `pi` alone is the wrong map - the same shift warning this card already carries for section 6.6.", "**THE `A_2` ADJOINT IDENTIFICATION `c_1c_2/c_3 - 1` IS CORRECT BUT IT IS NOT JANTZEN'S - HE NEVER LEAVES THE `K_nu`.** 6.24(1) gives `sum_nu dim L(lambda)_{-(1/2)nu} K_nu`, i.e. for the sl_3 adjoint `sum_{alpha in Phi} K_{-2alpha} + 2`. The rewriting as `c_1c_2/c_3 - 1` in elementary symmetric functions of `t_i` was **verified here** (identity checked symbolically; dimension check 8 at `t=1`) but requires the estate's `Q = q^2`, `t_i = z_i^2` dictionary and the weight-doubling `nu = -2lambda'`. **Jantzen performs no step of that translation.** Cite him for (1); cite the dictionary step to ourselves.", "DO NOT CITE SECTION 6.6 FOR THE HARISH-CHANDRA ISOMORPHISM. It proves CONTAINMENT ONLY: 'maps Z(U) to (U^0_ev)^W'. Jantzen's own Remark on the same page points forward to 6.25 for surjectivity. The collaborator note corpus/literature/collab/Center_computation.pdf cites 6.6 in support of an image statement; that citation does not carry the weight put on it.", "THEOREM 6.25'S HYPOTHESES ARE LOAD-BEARING: char(k) = 0 AND q transcendental over Q. Outside them the isomorphism is not asserted by this source.", "The evenness mu in 2*Lambda is DERIVED inside the 6.6 proof from the sign automorphisms sigma-tilde attached to homomorphisms Z*Phi -> {+-1}; it is not an assumption. Anyone reproducing it needs 5.2(1).", "THE SHELF PDF's TEXT LAYER IS OCR OF A SCAN AND IS UNUSABLE FOR MATHEMATICS (renders the membership sign as E, mangles subscripts). Everything on this card was read by eye. Do not quote this book from text extraction.", "Page offset for this scan: PDF page = printed page + 9.", "Sections 6.4-6.5, 6.22, 6.26 and 8.30 are NOT transcribed. **PARTIALLY DISCHARGED 2026-08-15: 6.26 IS NOW TRANSCRIBED, on `lit-jantzen-6-26-hypothesis-weakening-q-not-root-of-unity`, and it REMOVES the hypotheses this card records as load-bearing — the book extends Theorem 6.25 to `q` not a root of unity. Read the two cards together; this card is correct about §6.25's proof and must not be cited for the theorem's reach. 8.30 is located but still unread, so that link is relayed rather than verified. 6.4-6.5 and 6.22 remain untranscribed.** In particular the LATER EXTENSION of 6.25 that 6.26 and 8.30 describe is not captured, so this card must not be read as the last word on how far the isomorphism reaches."]
---
**SECTION 6.6 PROPOSITION [printed p.109]** — verbatim:

> The Harish–Chandra homomorphism $\gamma_{-\rho}\circ\pi$ **maps** $Z(U)$ **to** $(U^0_{ev})^W$.

**Containment only.** Neither surjectivity nor injectivity is asserted.

**REMARK, same page, Jantzen's own** — verbatim:

> We shall see in 6.25 that the image of $\gamma_{-\rho}\circ\pi$ is **all of** $(U^0_{ev})^W$ (at least if $\mathrm{char}(k)=0$ and $q$ transcendental over $\mathbf Q$).

**THEOREM 6.25 [printed p.124]** — verbatim:

> Assume that $\mathrm{char}(k)=0$ and that $q$ is transcendental over $\mathbf Q$. The Harish–Chandra homomorphism is an **isomorphism** between $Z(U)$ and $(U^0_{ev})^W$.

**The even-torus lattice [p.109].** Writing $\gamma_{-\rho}\circ\pi(u)=\sum_{\mu\in\mathbf Z\Phi}a_\mu K_\mu$ with $a_{w\mu}=a_\mu$, one shows $a_\mu\neq0$ forces $2(\mu,\alpha)/(\alpha,\alpha)$ even for every $\alpha\in\Pi$, i.e. $\mu\in2\Lambda$ — derived via the automorphisms $\tilde\sigma$ attached to $\sigma:\mathbf Z\Phi\to\{\pm1\}$, which preserve $Z(U)$, satisfy $\tilde\sigma\circ\pi=\pi\circ\tilde\sigma$ and commute with each $\gamma_\lambda$ on $U^0$.

**LEMMA 6.23 (TQ) [p.124]** — for $\lambda\in\Lambda$ dominant with $2\lambda\in\mathbf Z\Phi$ there is a unique $z_\lambda\in U$ with $\langle u,z_\lambda\rangle$ the trace of $uK_{2\rho}^{-1}$ on $L(\lambda)$; and $z_\lambda\in Z(U)$. **6.24(1):** $\gamma_{-\rho}\circ\pi(z_\lambda)=\sum_\nu \dim L(\lambda)_{-(1/2)\nu}K_\nu$ — the construction that supplies preimages, i.e. the surjectivity half.

## §6.22–6.25 — the adjoint quantum-trace central element and its shifted HC image

*Added 2026-09-01 by librarianCM on residentA2 `20260827T233406Z-…-75023-a7b0`
(`corpus/requests/LR-20260827T233338Z`). **Every display below was read from a 500-dpi render of the
scan, not from its text layer** — this is an OCR'd scan (CVISION/PdfCompressor) and its text layer
renders `γ_{-ρ}∘π` as `-y-p o 7r`. Printed pp. 123–124.*

### The standing hypothesis, and it is the answer to item 3 — verbatim [printed p. 123]

> **6.22.** *In the following subsections (6.22–6.25) we assume that **char(k) = 0** and that **q is
> transcendental over `Q`**. Our lemmas are preceded by **(TQ)** to remind us of that assumption.*

**`(TQ)` is not decoration — it fences this entire locus away from roots of unity by hypothesis.**
See trap.

### Lemma 6.23 (TQ), verbatim [printed p. 124]

> Let `λ ∈ Λ` be dominant such that `2λ ∈ ZΦ`. Then there is a unique element `z_λ ∈ U` such that
> `⟨u, z_λ⟩` is equal to **the trace of `u K_{2ρ}^{-1}` acting on `L(λ)`** for all `u ∈ U`. The
> element `z_λ` is contained in the center `Z(U)` of `U`.

**The trace pivot is `K_{2ρ}^{-1}`** — the quantum trace, not the ordinary one. Centrality is proved
via `ad(u)z_λ = ε(u)z_λ`, using `ε ∘ S = ε`.

### 6.24, and equation (1), verbatim [printed p. 124]

Writing `z_λ = Σ_{µ≥0} z_{λ,µ}` with `z_{λ,µ} ∈ U^-_{-µ}U^0U^+_µ`, the toral part is

> `z_{λ,0} = Σ_{λ'} dim L(λ)_{λ'} q^{(-2λ',ρ)} K_{-2λ'} = Σ_ν dim L(λ)_{-(1/2)ν} q^{(ν,ρ)} K_ν`,

and `z_{λ,0} = π(z_λ)` in the notation of 6.2, hence

> $$\gamma_{-\rho}\circ\pi(z_\lambda) \;=\; \sum_{\nu} \dim L(\lambda)_{-(1/2)\nu}\, K_\nu. \tag{1}$$

**The `-ρ` shift is exactly what cancels the `q^{(ν,ρ)}`.** Before `γ_{-ρ}`, the toral part carries
`q`-powers; after it, **the coefficients are bare weight multiplicities of `L(λ)`**. That is the
whole content of (1), and it is why the shifted map — not the bare projection `π` — is the one that
returns a character.

### Item 2 — the type-`A₂` adjoint specialization, and it does land on `c₁c₂/c₃ − 1`

For `g = sl₃` and `λ = ω₁+ω₂` (the adjoint), the weights of `L(λ)` are the six roots with
multiplicity 1 and `0` with multiplicity 2. Substituting `ν = −2λ'` into (1):

> `γ_{-ρ}∘π(z_θ) = Σ_{α ∈ Φ} K_{-2α} + 2·K_0`   — six root terms plus twice the identity.

**Verified by this Library** (sympy, 2026-09-01) that this is residentA2's target once the toral
variables are named: with `c_i` the elementary symmetric functions of `t₁,t₂,t₃`,

    Σ_{i≠j} t_i/t_j + 2  =  c₁c₂/c₃ − 1        (identically; dimension check at t=1 gives 8 ✓)

since `c₁c₂/c₃ = (Σt_i)(Σ1/t_i) = 3 + Σ_{i≠j} t_i/t_j`. **So the identification residentA2 proposed
is correct** — but see the trap: the step from `K_ν` to `t_i` is the estate's `Q = q²`, `t_i = z_i²`
dictionary, and Jantzen performs no part of it.
