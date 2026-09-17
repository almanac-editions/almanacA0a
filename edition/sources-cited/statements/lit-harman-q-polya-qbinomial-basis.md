---
id: lit-harman-q-polya-qbinomial-basis
status: literature-theorem
provenance: cited
provenance_note: "provenance split from grade 2026-08-01 (Librarian ruling). Provenance is `cited`: Harman and Hopkins prove it, with the classical case due to Pólya (1919). The grade — how well established this is FOR US — is deliberately left unset; this Library holds the transcript, the printed pages for the two propositions, and a CAS probe of the normalisation, but no referee verdict."
status_note: "**REFEREED 2026-08-13 — CONFIRMED, no correction.** First pass (2026-08-09) read printed pp. 3-4 of the scan (Proposition 1.1, the definition of R_q^+, Proposition 1.2 and its proof) against the shelf transcript. **The independent referee pass discharging caveat C1 was run 2026-08-13 from a DIFFERENT artefact — the arXiv LaTeX source `corpus/literature/arxiv_src/1601.06110/main.tex` + `main.bbl`** — and confirmed every statement, the `q^{binom(k,2)}[k]_q!` denominator, the interpolation proof, and the p.14 quotation including the authors' own `R`-for-`R_q` slip (present in the LaTeX, so not an extraction artefact). **Both CAS probes were re-derived from scratch**, not re-run: 49/49 `expr sha256 17543033c2f1ac49ca147cb82790a687107d558df41054e1bedda4700fcb07fb`, and the grid transport CONFIRMED on 6 seeds (n=0,1,2,5,7,12) `identity sha256 fe69d069dedb3942606587ca18b556ab086eed6fec362c325210d67538bc0800`. Report: `corpus/reports/HARMAN-HOPKINS-C1-REFEREE-PASS-2026-08-13.md`. **STILL UNRUN, and it is the one that matters for lattice equality:** the freeness probe in `cas_probe_sketch` (triangular transition matrix with unit diagonal). Read `traps` before use."
lens: externals-misc
sources: ["harman-hopkins-quantum-integer-valued-polynomials:§1, Proposition 1.1 and Proposition 1.2 [printed pp. 3-4]", "Nate Harman and Sam Hopkins, Quantum integer-valued polynomials, arXiv:1601.06110", "the source's own ancestry for Proposition 1.2, quoted on printed p. 4: `[Bha97, Theorem 14]` = Manjul Bhargava, P-orderings and polynomial functions on arbitrary subsets of Dedekind rings, J. Reine Angew. Math. 490 (1997) 101-127; `[CC97, Chapter II, Exercise 15]` = Cahen and Chabert, Integer-valued polynomials, AMS Surveys 48 (1997); `[Gra90]` = Gramain, Fonctions entieres ... prenant des valeurs entieres sur une progression geometrique, Asterisque/LNM 1415 (1990)"]
feeds: ["SandboxA/sandboxA0a GL1 closure manuscript (proofv0a.tex, clause (iii)): this is the ancestry of the bilateral quantum Polya theorem that the manuscript transports to the multiplicative grid. Criterion 13 resolution target.", "own-weight-newton-basis-equals-lusztig-toral-lattice: supplies the T_HH side of the unreconciled T^Lus_X = N^X = T_HH triangle, in the source's own conventions and with the denominator normalisation written out.", "own-sl2-rees-newton-centre-theorem: the note's status table calls T_WN = T_HH proved; this card is the first time the shelf holds what T_HH actually is.", "even-newton-gaussian-grid-values: our nu_r(Q^m) = [m; r]_Q one-sided Gaussian values are the multiplicative-grid image of this basis under Y-check = 1 + (Q-1)x.", "lit-harman-bilateral-q-integer-localization: the bilateral half of the same theorem."]
conventions_gap: "THEIR q IS OUR Q = q^2, AND THEIR z IS OUR Y-check, NOT OUR z. Explicitly. The paper has ONE deformation parameter, written q; matching the program frame A_z = Z[q^{+-1}, z^{+-1}] with Q = q^2 requires q_paper := Q = q_ours^2. Their [n]_{q_paper} = (q_paper^n - 1)/(q_paper - 1) is then our [n]_Q. Their grid is ADDITIVE: integrality is imposed on the values P([n]_q) at the q-integers, whereas the program's grid is MULTIPLICATIVE, Y-check = Q^n. The two are exchanged by the node-preserving affine substitution Y-check = 1 + (Q-1)x, x = (Q-1)^{-1}(Y-check - 1), which is the paper's own §4 z-variable (carded separately as lit-harman-z-variable-lusztig-cartan-form). Their Gaussian binomial is the ONE-SIDED convention qbinom(n,k) = [n]_q!/([n-k]_q![k]_q!) with the unshifted [n]_q = 1 + q + ... + q^{n-1}, NOT the balanced/symmetric convention; the two differ by a unit power of q, so integrality statements survive the change but explicit coefficients do not. The denominator of the basis polynomial is q^{binom(k,2)}[k]_q! and that exponent binom(k,2) is where a normalisation error would hide. Coefficient ring: Z[q_paper] = Z[Q] on the positive part, which is a PROPER SUBRING of our A_z; nothing here gives a statement over A_z on its own."
cas_probe_sketch: "PROBE RUN 2026-08-09, in the source's conventions, on the warm kernel. (1) The defining evaluation property of Proposition 1.2 -- that the basis polynomial with denominator q^{binom(k,2)}[k]_q! evaluates at x := [n]_q to the one-sided Gaussian binomial qbinom(n,k)_q -- was checked for all 0 <= n,k <= 6 (49 of 49 true), certificate expr sha256 bc27c685aa1446ad28061b67e8fc3e1b6e599eedf0b8823b97ab03e7205ca57e. This is the load-bearing normalisation and it holds AS DISPLAYED. (2) The grid transport 1 + (Q-1)[n]_Q = Q^n with Q = q^2 was confirmed on hostile seeds n = 0,1,2,5,7, certificate identity sha256 4a3e62f89ff01b993389529d02187d6abaff4f78c32d4717545b081220931895. NOT PROBED, and the part that actually matters for us: freeness of the lattice itself. To probe it, expand an arbitrary Z[Q]-combination of our toral basis in the qbinom(x,k) basis for k <= 6 and check the transition matrix is triangular with unit diagonal -- two-way integrality alone does not establish equality of lattices (this is the same separation the own-weight-newton-basis card records)."
traps: ["NAME COLLISION ON z. The paper's z := (q-1)x + 1 is a REPARAMETRISATION OF THE SINGLE VARIABLE x, i.e. the multiplicative grid coordinate, which in program conventions is Y-check. It is NOT the program's z, the free torus parameter of A_z = Z[q^{+-1}, z^{+-1}]. Reading their z as our z inverts the whole dictionary.", "THEIR q IS OUR Q = q^2. A transported formula in which q_paper was left as q_ours is off by a square everywhere. Their square-root variable v (with v^2 = q_paper) is what equals OUR q.", "ONE-SIDED GAUSSIAN CONVENTION, unshifted [n]_q = 1 + q + ... + q^{n-1}. Substituting the balanced binomial changes every explicit coefficient by a unit power of q. Integrality claims survive; identities transcribed coefficient-by-coefficient do not.", "THE DENOMINATOR IS q^{binom(k,2)}[k]_q!, not [k]_q! and not q^{binom(k+1,2)}[k]_q!. Verified on the printed page and by CAS.", "ADDITIVE GRID. Proposition 1.2 is about integrality of P([n]_q), n in N. Any multiplicative-grid reading must go through the §4 substitution, and that substitution is an unnumbered remark in the source, not a proposition.", "POSITIVE PART ONLY, over Z[q]. Freeness over Z[q,q^{-1}] on the SAME basis is a consequence of Proposition 4.3 and is stated in one sentence on printed p. 14 (`the q-binomial coefficient polynomials are a Z[q,q^{-1}]-basis of R_q and their structure constants are still as in Theorem 3.2`) -- quoted in the body below because that, not Proposition 1.2 itself, is the form a Laurent-coefficient frame needs.", "THE BASIS INDEX k RUNS OVER N EVEN IN THE BILATERAL RING. Bilaterality lives in the coefficient ring and in the evaluation grid, never in the basis index. Do not expect a two-sided index sequence here; the program's own weight-Newton basis DOES use a bilateral index sequence a_0 = 0, a_1 = 1, a_2 = -1, ..., so the two bases are not term-by-term comparable without a stated matching."]
---
**Proposition 1.1 (Pólya 1919 [Pól19]) [printed p. 3]**
$\mathcal{R}$ *is freely generated as an abelian group by the binomial coefficient polynomials* $\binom{x}{k}$ *for* $k \in \mathbb{N}$ *defined by*
$$\binom{x}{k} := \frac{x(x-1)\dots(x-k+1)}{k!} \qquad \textit{if $k \geq 1$},$$
*with* $\binom{x}{0} := 1$.

Here $\mathcal{R}$ is the ring of $P \in \mathbb{Q}[x]$ with $P(n) \in \mathbb{Z}$ for all $n \in \mathbb{N}$.

**Definition [§1, printed p. 3].** With $[n]_q := (q^n-1)/(q-1) = (1 + q + \cdots + q^{n-1})$ for $n \in \mathbb{N}$, $[0]_q = 0$, $[n]_q! := [n]_q[n-1]_q\cdots[1]_q$, $[0]_q! := 1$, and
$$\qbinom{n}{k}_q := \frac{[n]_q!}{[n-k]_q![k]_q!} \quad\text{when } 0 \le k \le n, \qquad \qbinom{n}{k}_q := 0 \text{ if } k > n \text{ or } k < 0,$$
$$\mathcal{R}^{+}_q := \{P(x) \in \mathbb{Q}(q)[x]\colon P([n]_q) \in \mathbb{Z}[q] \textrm{ for all } n \in \mathbb{N}\}.$$

**Proposition 1.2 [printed p. 4]**
$\mathcal{R}^{+}_q$ *is freely generated as a* $\mathbb{Z}[q]$*-module by the* $q$*-binomial coefficient polynomials* $\qbinom{x}{k}$ *for* $k \in \mathbb{N}$ *defined by*
$$\qbinom{x}{k} := \frac{x(x-[1]_q)\dots(x-[k-1]_q)}{q^{\binom{k}{2}}[k]_q!} \qquad \textit{if $k \geq 1$},$$
*with* $\qbinom{x}{0} := 1$. *These polynomials satisfy* $\qbinom{[n]_q}{k} = \qbinom{n}{k}_q$.

**Proof sketch [printed p. 4].** The authors record that the proposition "falls into a general framework set up by Bhargava; it can be seen as an instance of [Bha97, Theorem 14]. It also is essentially the same as [CC97, Chapter II, Exercise 15], which in turn cites [Gra90]", and then give a self-contained argument by polynomial interpolation: evaluation at $x := [n]_q$ and a degree argument give linear independence, and for $P \in \mathcal{R}^+_q$ one builds
$$P_0(x) := P(0); \qquad P_k(x) := P_{k-1}(x) + (P([k]_q) - P_{k-1}([k]_q))\qbinom{x}{k} \quad \text{if } k \ge 1,$$
whose coefficients lie in $\mathbb{Z}[q]$ by hypothesis; $P - P_d$ has degree $\le d$ and vanishes at the $d+1$ points $[0]_q,[1]_q,\ldots,[d]_q$, hence is zero, so $P = P_d$.

**The bilateral form of the same basis statement [printed p. 14, immediately after Proposition 4.3]**, quoted because it is the form a Laurent-coefficient frame needs:

> Proposition 4.3 means that many results we have proved about $\mathcal{R}^+_q$ transfer directly to $\mathcal{R}$: for example, the $q$-binomial coefficient polynomials $\qbinom{x}{k}$ are a $\mathbb{Z}[q,q^{-1}]$-basis of $\mathcal{R}$ and their structure constants are still as in Theorem 3.2.

(Quoted exactly as printed. Both occurrences of $\mathcal{R}$ in that sentence are a slip of the pen for $\mathcal{R}_q$ — the printed page was checked as an image, so this is the source's own typo and not a text-extraction artefact. $\mathcal{R} \subset \mathbb{Q}[x]$ is the classical ring and is not a $\mathbb{Z}[q,q^{-1}]$-module at all, while $\mathcal{R}_q$ is exactly the object Proposition 4.3 has just described. Recorded, not silently corrected.)
> ### ⚠ [Librarian, 2026-08-13] QUALIFICATION — the `[CC97, Ch II Ex 15]` equivalence this card quotes is NOT an equality of statements
>
> **Raised by the Editor (`20260813T115302Z`) after reading Cahen–Chabert directly.** This card
> quotes Harman–Hopkins saying their Proposition 1.2 *"is essentially the same as
> [CC97, Chapter II, Exercise 15]"*. **Read at source, the two are not the same statement**, and the
> differences are exactly the ones that matter for transport:
>
> | | Cahen–Chabert Ch II Ex 15 | Harman–Hopkins Prop 1.2 |
> |---|---|---|
> | evaluation set | **multiplicative**, `{q^k}` | **additive**, the `q`-integers `[n]_q` |
> | `q` | a **fixed integer `≥ 2`** | an **indeterminate** |
> | the module | a **`ℤ`-module** basis of `Int(E,ℤ)` | a free **`ℤ[q]`-module** |
>
> **So the quoted sentence is the authors' own gloss, not a verified identification, and this card
> reproduces it as such.** The multiplicative-grid statement's actual home is **Gramain, LNM 1415,
> Prop 2.2, p.124** — see `lit-gramain-geometric-progression-integer-valued-basis`. Cahen–Chabert
> treat the geometric progression in exactly one place, **without proof**, attributing it to Gramain;
> so **Ex 15 is a signpost to Gramain, not an independent source**, and it is on the *other* grid
> from Harman–Hopkins.
>
> **What I verified myself, and what I did not — UPDATED THE SAME DAY.** *Originally recorded: I read
> Gramain's Prop 2.2 at source but could NOT isolate Ch II Ex 15, because the book's OCR mangles the
> chapter-level exercise numbering; the Ex 15 half was carried on the Editor's reading.* **That gap
> is now closed: on 2026-08-13 I read printed p. 46 directly as a page image** (bypassing the text
> layer entirely) and **confirm all three differences above at source.** Exercise 15 opens *"Let `q`
> be a fixed integer `≥ 2`"*, evaluates on `E = {q^k}`, and gives a **`ℤ`**-module basis of
> `Int(E,ℤ)`. **The Ex 15 statement is now carded in its own right — `lit-cahen-chabert-ex15-erratum-two-misprints`
> — because as printed it carries two misprints**, one of which (a dropped minus in the prefactor
> exponent) is a mis-transcription from Gramain, machine-refuted symbolically in `q`.
>
> Nothing else on this card changes: Propositions 1.1 and 1.2 and their frame stand as recorded.

