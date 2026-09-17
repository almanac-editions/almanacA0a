---
id: lit-harman-bilateral-q-integer-localization
status: literature-theorem
provenance: cited
provenance_note: "provenance split from grade 2026-08-01 (Librarian ruling). The old `literature-theorem` fused BOTH: it said somebody else proved this, which is provenance, not how well established it is for us. Provenance is mechanical and safe to set; the GRADE is NOT determined by it and is deliberately left unset — for most of these we hold a transcript, not a verdict."
lens: externals-misc
sources: ["harman-hopkins-quantum-integer-valued-polynomials:§4, Proposition 4.3", "Nate Harman and Sam Hopkins, Quantum integer-valued polynomials, arXiv:1601.06110"]
feeds: ["v1c completed centre + ribbon — a precise positive-to-bilateral localization and finite-grid integrality criterion models cumulative-window saturation."]
conventions_gap: "Their [n]_q=(q^n-1)/(q-1) is one-sided and q_paper is not our Q=q^2 unless explicitly substituted. Use z=q_paper^n and x=(z-1)/(q_paper-1); to compare with HQ set q_paper=Q=q_ours^2 and then adjoin K with K^2=z only if the square-root cover is intended. Their coefficient localization inverts q_paper, not cyclotomic factors or z."
cas_probe_sketch: "For degrees d<=5, interpolate P on [0]_Q,...,[d]_Q, test that bilateral grid integrality is equivalent to a Q-power clearing denominators into the positive q-binomial basis, and compare the Smith pivots with HQ window matrices."
traps: ["no Habiro completion is constructed", "localization only in q", "one-sided q-integers", "finite degree d is essential in the integrality test"]
---
**Lemma [§4.2] {label: lem:qotherchars}**
Let $P\in\mathbb{Q}(q)[x]$ be a polynomial of degree $d$ with $P([n]_q) \in \mathbb{Z}[q]$ for $n\in[0,d]$. Then:
1. $P([n]_q) \in \mathbb{Z}[q]$ for $n \in \mathbb{N}$ (in other words, $P \in \mathcal{R}_q^+$).
2. $P([n]_q) \in \mathbb{Z}[q,q^{-1}]$ for $n \in \mathbb{Z}$.

**Proposition [§4.3] {label: prop:localization}**
$$\mathcal{R}_q = \mathcal{R}_{q}^{+} \otimes_{\mathbb{Z}[q]} \mathbb{Z}[q,q^{-1}]$$
viewed as subrings of $\mathbb{Q}(q)[x]$.

