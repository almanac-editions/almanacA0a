---
id: lit-dcp-verma-contravariant-shapovalov
status: literature-theorem
provenance: cited
provenance_note: "C. De Concini and C. Procesi, *Quantum Groups*, Springer LNM 1565, §§17.1–17.4. Held in full; the transcript is statement-complete here with printed page anchors (p.82–84). Grade left unset — transcript, not verdict."
lens: Verma-modules-the-contravariant-form-and-the-quantum-Shapovalov-determinant-in-DCP-normalization
sources: ["corpus/literature/transcribed/deconcini-procesi-quantum-groups-lnm1565.md §17.1, §17.2, §17.3, §17.4", "C. De Concini and C. Procesi, Quantum Groups, Springer Lecture Notes in Mathematics 1565, pp. 82-84"]
feeds: ["own-gln-family-verma-stabilizer-newton-pbw — its mixed Shapovalov determinant is derived from this family of formulas (it names De Concini-Kac Proposition 1.9 and DCP §17.4 as giving the same determinant).", "SP-2026-010v2 Packet A — `sections 17.1-17.4 for Verma modules, contravariant forms and the Shapovalov determinant`."]
created: 2026-08-10 (Librarian, on residentA LR-20260808T063250Z Packet A)
conventions_gap: "DCP's Verma is induced from a multiplicative character Lambda of M over k(q): V(Lambda) = U ⊗_B k(q)(Lambda). SINGLE torus, no z-variables, no split K^+/K^-, and no family parameter — the programme's family Verma M_z(lambda) is a genuinely different object with a split torus and central z_a. Their determinant is written in the bracket notation [K_beta; c] with the rho-shift (rho|beta) INSIDE the bracket argument and a -(m/2)(beta|beta) term; the GL_n manuscripts' wall factor B_{ab,m}^lambda = v^{b-a-m+lambda_a-lambda_b} t_b - v^{-b+a+m-lambda_a+lambda_b} t_a carries t_a AND t_b and is NOT in that notation. Matching them means matching the rho-shift convention, the d_beta normalization, and the split-torus split of the wall — three separate steps."
traps: ["THE DETERMINANT IS STATED WITH THE [m]_{d_beta} FACTOR PRESENT. det_mu = prod_{beta in R^+} prod_{m in N} ([m]_{d_beta} [K_beta; (rho|beta) - (m/2)(beta|beta)])^{P(mu-m beta)}. Any version in DIVIDED words has absorbed those [m] factors into the rescaling — that is precisely the step the GL_n manuscript performs, and it changes the formula. Do not compare the two displays directly.", "THE KERNEL STATEMENT IS TWO STATEMENTS. §17.3's Lemma says the contravariant form EXISTS and is unique given Hermitian symmetry, <au,v> = <u,kappa(a)v>, and <v_Lambda,v_Lambda> = 1. §17.3's Theorem says its kernel IS the maximal proper submodule N_Lambda. Uniqueness is cheap; the kernel identification is the theorem.", "P(mu - m beta) IS THE KOSTANT PARTITION FUNCTION OF THE AMBIENT ROOT SYSTEM, not of a Levi or an interval subsystem. In the GL_n manuscripts the corresponding exponent is P_n(mu - m beta_{ab}) with P_n counting Kostant partitions in K_n. Same role, and the reader must check the same indexing set.", "A SECOND, DIFFERENT DETERMINANT IS ALREADY ON THIS SHELF: lit-dck-shapovalov-wall-determinant carries De Concini-Kac Proposition 1.9. The GL_n manuscript cites BOTH as giving the same determinant. They are two presentations, in two normalizations, in two papers by overlapping authors — do not treat a match in one as a match in the other without checking the bracket convention."]
---

# De Concini–Procesi §§17.1–17.4 — Verma modules, contravariant form, quantum Shapovalov determinant

| anchor | statement | page |
|---|---|---|
| **§17.1 Def./Thm.** | For a multiplicative character `Λ` of `M`, `V(Λ) = U ⊗_B k(q)(Λ)` is the Verma module. It is **indecomposable**, has a **unique maximal proper submodule `N_Λ`**, and a unique irreducible quotient `L_Λ`. `v_Λ` is the unique vector of weight `λ` | p.82 |
| **§17.2 Prop.** | If `β` is in the relevant set, `V(λ)` contains a submodule isomorphic to `V(λ − rβ)` | p.83 |
| **§17.3 Lem.** | The **contravariant form** exists and is uniquely characterized by Hermitian symmetry, `⟨au,v⟩ = ⟨u,κ(a)v⟩`, and `⟨v_Λ,v_Λ⟩ = 1` | p.83 |
| **§17.3 Thm.** | Its **kernel is exactly `N_Λ`**, the maximal proper submodule | p.84 |
| **§17.4 Thm.** | **Quantum Shapovalov determinant:** `det_μ = ∏_{β∈R^+} ∏_{m∈N} ( [m]_{d_β}·[K_β; (ρ|β) − (m/2)(β|β)] )^{P(μ−mβ)}` | p.84 |

## Search keywords

De Concini Procesi Verma module · contravariant form · quantum Shapovalov determinant ·
`det_mu` · maximal proper submodule kernel · LNM 1565 §17.4 · Kostant partition exponent ·
wall factor `[K_beta; ...]`
