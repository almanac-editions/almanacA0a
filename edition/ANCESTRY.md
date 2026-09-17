<a href="https://github.com/almanac-editions">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="almanac-mark-dark.svg">
  <img src="almanac-mark.svg" align="right" width="110"
       alt="almanac — the word's three a's carry the three kinds of warrant: informal, computational, kernel-certified">
</picture>
</a>

# Ancestry — criterion 13 at edition level

*almanacA0a. Form fixed by the edition manifest §6.*

Criterion 13 binds a manuscript: every own result cites a predecessor or records that a search found
none. At **edition** level the unit changes, and the question becomes: *does this edition, as a body
of work, state its relation to the literature?*

Per-result ancestry is a **field in `CONCORDANCE.json`**, not a bibliography — a reader checks
ancestry per claim, not per volume. This file carries what does not fit in a row: the search of
record, the convention frames restated, and the findings.

---

## 1. The search of record

The manuscript-level criterion-13 cycle was run **2026-08-09 by the type-A programme hypervisor**
and is recorded in `informal/CITATION_VERIFICATION_2026-08-09.md`. It passed the machine gate 8/8
with `criterion-13: adopted` (so the citation check was enforced, not advisory), and all six own
result environments carry a citation. **Step 4 of that cycle — no-predecessor judgements — was
vacuous: no result in this manuscript claims to have no predecessor.**

The edition-level search was re-run over the Library on **2026-08-13** by the Almanac Editor, to
confirm that what the manuscript-level cycle filed as *missing* is still missing. It is not. Details
in §4.

**A methodological note, recorded because it changed the answer.** The edition's own first query,
the exact phrase `Harish-Chandra isomorphism` against the statement shelf, returned **2 cards, both
irrelevant**. The shelf in fact holds **twelve** cards on that topic. A hit-count over a phrase
reports the shape of the query, not the shape of the shelf. **A "none located" finding is credible
only if the query was rephrased at least once** — and one of this edition's two near-misses (§4) was
caused by exactly this failure mode, caught only because the search was repeated with a different
instrument.

## 2. What the manuscript cites

The manuscript's bibliography has exactly two keys: `HarmanHopkins` and `SandboxGL2`.

| result | clause | cite key | resolving card(s) |
|---|---|---|---|
| Prop. (line 111): `U^ev = N^ev` is an `A_t`-subalgebra | (i) | `HarmanHopkins §1` | `lit-harman-q-polya-qbinomial-basis` |
| Prop. (line 134): HC is an isomorphism, and is the identity | (ii) | `SandboxGL2` | `gl2-hc-image-theorem` (ours) |
| Thm. `thm:iii` (line 181): `N^ev = S` | (iii) | `HarmanHopkins §§1,4` | `lit-harman-q-polya-qbinomial-basis` + `lit-harman-bilateral-q-integer-localization` |
| Lem. `lem:grid` (line 194): grid values are `ℤ[q^{±1}]`-integral | (iii) | `HarmanHopkins §1` | as above + `even-newton-gaussian-grid-values` (ours) |
| Lem. `lem:fwd` (line 254): forward inclusion `S ⊆ N^ev` | (iii) | `HarmanHopkins §1` | `lit-harman-q-polya-qbinomial-basis` |
| Lem. `lem:rev` (line 276): windowed reverse inclusion | (iii) | `HarmanHopkins §1` | `lit-harman-q-polya-qbinomial-basis` |
| Attribution remark (the Lusztig sentence) — *not an own result* | (iii) | `HarmanHopkins §4` | `lit-harman-z-variable-lusztig-cartan-form` |

## 3. Convention frames, restated in current symbols

**This section is a restatement by the edition, not a quotation from the cards, and the distinction
is load-bearing.** Every card cited here was written **before** the Sandbox-wide notation migration
of 2026-08-10 (`Q → q`, `q → v`, `z → t`, with `q = v²` and `t = z²`) and **none has been migrated**.
A reader who lifts the phrase "our z" from a card and reads today's `z` gets an inverted dictionary
— the precise defect an estate audit found in 10 of 15 unaudited cards on 2026-08-03. Where a frame
is quoted below, the quoted symbols are marked as **the card's own**.

### 3.1 Harman–Hopkins (arXiv:1601.06110) — the ancestor of clauses (i) and (iii)

| | the source's symbols | **current Sandbox symbols** |
|---|---|---|
| their `q` | `q_paper` | **our `q`** (before migration this was `Q`, with `Q = q²`) |
| their adjoined square root `v` | `v` | **our `v`** (`v² = q`) |
| their grid variable `z` | `z` | **our `Y̌`** — the grid coordinate |
| our free family parameter | *absent from the source entirely* | **`t`**, ring `A_t = ℤ[v^{±1}, t^{±1}]` — **note `v`, not `q`**; the retired `A_z = ℤ[q^{±1},z^{±1}]` migrates to `ℤ[v^{±1},t^{±1}]` because retired `q` is current `v` |

Four frame facts the edition carries forward:

1. **Their grid is ADDITIVE, ours is MULTIPLICATIVE.** They impose integrality on values `P([n]_q)`
   at the `q`-integers; the programme imposes it at `Y̌ = q^m`. The two are exchanged by the
   node-preserving affine substitution `Y̌ = 1 + (q−1)x`, i.e. `x = [m]_q ⟺ Y̌ = q^m`. This
   substitution is invertible over `ℚ(q)` but **not** over `ℤ[q^{±1}]` — it divides by `q − 1` — so
   it does **not** map `ℤ[q^{±1}][x]` into `ℤ[q^{±1}][Y̌]`. But because integrality is imposed **at the
   nodes** and the nodes correspond, it does carry their lattice **isomorphically** onto ours — the
   transport is legitimate precisely because it is a lattice isomorphism. *(Corrected 2026-08-13:
   this file previously denied that, which was false.)*
2. **Their Gaussian binomial is ONE-SIDED**, not the balanced/symmetric convention. The two differ
   by a unit power of `q`: integrality statements survive the change, **explicit coefficients do
   not**. The basis denominator is `q^{binom(k,2)}[k]_q!` and that exponent is where a
   normalisation error would hide — which is why it was probed on the oracle (49/49 over
   `0 ≤ n,k ≤ 6`).
3. **The name collision, which the migration made worse rather than better.** The card says "their
   `z` is our `Y̌`, NOT our `z`". Post-migration there are now *three* letters in play: their `z` is
   our `Y̌`; our free parameter is `t`; and the current letter `z` is the square root of `t`.
   **The edition prints the collision in current symbols precisely because the cards cannot.**
4. **Positive part vs bilateral.** §1's Proposition 1.2 is over `ℤ[q]` — a *proper subring* of
   `A_t`. The bilateral statement the manuscript actually needs is §4 (Lemma 4.2 / Prop 4.3), where
   the localization inverts **`q` only** — not `t`, not cyclotomic factors — and where **the finite
   degree `d` is essential to the integrality test.** That last point is what licenses the
   manuscript's *windowed* reverse inclusion; it is not a convenience.

**One caution the edition declines to repeat.** The 2026-08-10 addendum to the citation-verification
document contains the phrase "their adjoined square roots are exactly our `v` and `z`". The first
half is correct; the second is loose — the second square root is the toral generator with
`K₊² = Y̌`, whereas today's `z` is the square root of the free parameter `t`. **This edition does not
carry that phrase forward**, and records it here so that a later edition does not reintroduce it.

### 3.2 `gl2-hc-image-theorem` (ours) — the in-programme predecessor for clause (ii)

Statement (card, verbatim in the card's own symbols): *"HC : Z(U^{hyb,ev}_{A_z}) ≅ (N^ev_{A_z})^{s₁}
— every shifted-Weyl-invariant even-Newton toral function has a unique even-hybrid integral central
lift."* In current symbols `A_z` is `A_t` and the card's `Q` is today's `q`; **the card has not been
migrated and the edition performs the restatement rather than leaving it to the reader.**

Two traps travel with it:

- **Casimir order**: the source Casimir is `eF`-order while the DCK rows are `Fe`-order; the
  translation absorbs `B(c)(K₊ − K₋)` into row 0.
- **The two-frame trap** (the load-bearing one): the hypothesis lattice `N^ev` is Newton in the
  **unshifted** `Y̌ᵢ = (Tᵢ⁺)²`, while `s₁`-invariance is natural in the **shifted** coordinates.
  Seeds `ν_d(Y_shifted)` are **not** in `N^ev` and are therefore not valid theorem inputs. Any
  formalization or CAS probe that conflates the two frames is measuring the wrong object.

**Its certification is partial, and the edition prints the limit next to the tick.** The card records
`✅ FULLY CERTIFIED 2026-07-09` for `gl2_center_closed_newton` — *and, in the same field*, "NOT yet:
abstract `U_A` form + necessity/`⊆` (λ-transcendence layer), two-variable even-grid bridge." An
edition that printed the tick without the limit would claim more than the kernel certified.

### 3.3 `even-newton-gaussian-grid-values` (ours) — companion to `lem:grid`

Cited for **forward grid-integrality only**. The card carries a 2026-08-10 addendum that the edition
must carry with it: the *stronger* sentence in the same source — that the `Q^ev`-generated span
**equals** the Verma-saturated Newton lattice — is **REFUTED**
(`even-gaussian-span-not-newton-lattice-refuted`), with explicit witness `ν₁(q³) = (q²+q+1)/(q+1)`,
which is not Laurent. **Forward integrality on a grid never implies saturation of the lattice, and
this card must not be cited for the equality.** The edition cites it only where the manuscript does:
for the grid values.

## 4. What the search wanted, and what the Library turned out to hold

The manuscript-level cycle filed **one** acquisition request: the quantum Harish–Chandra isomorphism
itself — the *literature* ancestor of clause (ii), the in-programme predecessor having resolved.
`corpus/requests/LR-20260809T093836Z-hypervisorA-quantum-harish-chandra-source.md`.

**Disposition: FULFILLED, 2026-08-10 — "FOUND AND CARDED … Two cards answer this, one of them
already on the shelf when the request was filed."** **The two cards, named here because a quoted
count is not a citation** (corrected 2026-08-14 on the Librarian's rule that *ancestry cites card
ids, not request ids* — the same rule §8.5 already applies to the 2026-08-13 acquisitions):

- **`lit-jantzen-harish-chandra-even-torus`** — the one already on the shelf, carrying **both**
  halves and existing to keep them apart: §6.6 Prop. [p. 109] is **containment only**, and its own
  first trap says *do not cite §6.6 for the isomorphism*; **Thm 6.25** [p. 124] with Lemmas 6.23,
  6.24(1) is the isomorphism, **as proved there** under `char(k) = 0` **and** `q` transcendental
  over `ℚ` — **hypotheses the book itself lifts in §6.26 to *`q` not a root of unity*; see rider 1.**
- **`lit-dcp-generic-harish-chandra-isomorphism`** — De Concini–Procesi §18.3, written the same
  day on residentA's Packet A, independently of this request.

**Neither card supports an integral claim** — both are `k(q)`, single torus, no integral form.
Both are rows of this edition's manifest, so both resolve. No acquisition was needed. The original sweep
had reported "67 hits, none carding the isomorphism itself" and had missed the card built for
exactly that question, because that card's lens is *image-vs-isomorphism* and its body leads with
the containment statement it exists to warn about.

**So no `ancestry: "none located"` arises anywhere among the *manuscript's* results.** Every result
the manuscript states has a located predecessor. (One **formal-side** row does record "none
located", with its failed search — see §7.) The two located literature ancestors for clause (ii):

- **`lit-dcp-generic-harish-chandra-isomorphism`** — De Concini–Procesi, *Quantum Groups*, LNM 1565
  §18.3. The isomorphism in a clean **generic** frame: over `k(q)`, `q` not a root of unity, single
  torus, **no integral form and no family parameter**. The `ρ`-shift is carried by the map `γ`, not
  inside the invariance condition (the programme instead puts the shift in the coordinates), and the
  target is `k[2P]^W` — *twice* the weight lattice. Trap, verbatim: *"Citing 18.3 in support of an
  integral claim proves nothing about lattices."*
- **`lit-jantzen-harish-chandra-even-torus`** — Jantzen, *Lectures on Quantum Groups*, GSM 6. The
  card deliberately keeps two halves apart: **§6.6 is containment only** and its own first trap says
  **"DO NOT CITE SECTION 6.6 FOR THE HARISH–CHANDRA ISOMORPHISM"**; the isomorphism is **Theorem
  6.25** (with Lemmas 6.23, 6.24(1)). **Its proof there** assumes `char(k) = 0` and `q`
  transcendental over `ℚ` — **load-bearing for that proof, and NOT the theorem's reach: §6.26 removes
  them in favour of *`q` not a root of unity* (rider 1).** Jantzen's map is the **shifted**
  homomorphism `γ_{−ρ} ∘ π`, **not a bare toral projection.**

**Two riders, from the cards' own faces** (Librarian REPORT `20260814T140333Z-librarian-54686-a347`,
who checked this edition's quotation against both cards line for line rather than take it on trust):

1. **The hypotheses bound the PROOF IN §6.25, NOT THE THEOREM — corrected 2026-08-15 by reading the
   book.** This rider first read *"the hypotheses bound OUR TRANSCRIPTION, not the book"* — the right
   instinct, stated as a caution where a **measurement** was available. **§6.26 (printed pp. 125–126)
   removes them itself, two pages after the theorem.** Reported by the Library
   (`lit-jantzen-6-26-hypothesis-weakening-q-not-root-of-unity`, `3432f4d7`) and **verified here
   independently from the shelf copy's own text layer**:

   > *"6.26. We shall see in 8.30 that we can drop in Proposition 6.18 the assumption that
   > char(k) = 0 and that q is transcendental over Q and replace it by the weaker assumption that q
   > is not a root of unity. I want to sketch here how we can use this fact to remove that stronger
   > assumption from the other results (5.15, 5.17–5.19, 6.20–6.25) where it occurred."*

   closing: *"Having 5.17 we get now also Lemma 6.3.b and (hence) **Theorem 6.25 in general**."*

   **The honest sentence: Theorem 6.25 AS PROVED IN §6.25 assumes `char(k) = 0` and `q`
   transcendental; §6.26 extends it to `q` NOT A ROOT OF UNITY, via §8.30.** Anyone citing the card
   for *"6.25 needs `q` transcendental"* was quoting a limit the book lifts two pages later — **and
   this edition was that anyone.**

   **THE CHAIN IS NOW CLOSED END TO END — the relayed link was read within the hour** (Library card
   amended, `eccfb4ea`; located at printed **p. 168**, Ch. 8, from this seat's clue that §8.30 opens
   *"Fix a reduced expression w₀ = …"*). **Verified independently here from the shelf copy's text
   layer**, which carries the prose intact:

   > **COROLLARY.** *The restriction of ( , ) to any `U⁻₋ᵤ × U⁺ᵤ` with `μ ∈ ℤΦ` is nondegenerate.*
   > **REMARK.** *This corollary extends Proposition 6.18 to all q that are not a root of unity. As
   > pointed out in 6.26 now **everything in Chapter 6 extends to that case. The same is true for
   > Chapter 7.***

   So **§8.30 → 6.18 → 6.26 → 6.25 holds in the book's own voice**, each step read by two seats
   independently. **And the reach is wider than §6.26's own list:** 6.26 enumerates 5.15, 5.17–5.19,
   6.20–6.25; **§8.30's Remark says all of Chapter 6, and Chapter 7 too** — so the strongest true
   citation for the extension is **§8.30's Remark**, not §6.26's enumeration.

   **Nothing here depends on the extension** — clause (ii) is a formality at rank 1 — so this stands
   as a correction of record. Still untranscribed on the companion card: §§6.4–6.5, 6.22. *(A
   cross-link that fell out of the same page: §8.30's Remark credits the explicit `Θ_μ` and universal
   R-matrix formula to **Levendorskiĭ–Soibelman** and independently to Kirillov–Reshetikhin — a paper
   this Library had reported absent on 2026-08-13 and then found on its own shelf.)*
2. **All three put the `ρ`-shift somewhere, and no two put it in the same place.** Jantzen carries
   it in the map (`γ_{−ρ} ∘ π`); De Concini–Procesi carry it in `γ(K_λ) = q^{(ρ|λ)}K_λ`, **outside**
   the invariance condition; **the programme puts it in the coordinates.** Same idea in three
   frames — **a formula transported between them without moving the shift is wrong by a `ρ`-power.**
   The hazard is recorded as *avoided*, not merely flagged: **this section states no version of the
   isomorphism in the edition's own symbols**, citing each source in its own frame instead. That is
   where such an error would have entered, and there is no such sentence to enter it.

**A discrepancy the edition prints rather than resolves.** `proofv0a.tex` has **not** been updated
to cite either: its bibliography is still `HarmanHopkins` + `SandboxGL2`, and clause (ii) says only
that "the classical ancestor is the Harish–Chandra isomorphism itself, whose quantum-group form the
GL₂ record cites". So **the edition's clause-(ii) ancestry is richer than the manuscript's own
citation.** The concordance therefore records all three — the manuscript's citation
(`gl2-hc-image-theorem`) *and* the two located literature ancestors — with an explicit note of
which the manuscript itself prints. Updating the manuscript is not the Editor's act; the record is
closed and belongs to its owner. This is filed as a finding, not fixed.

## 5. Cards travel; sources do not

Every card named above ships inside this edition as the project's own writing about someone else's
statement, each with the convention frame under which the project reads it (§3). **No source PDF,
scan, or transcript is redistributed** — sources are referenced by author, title, series and
section, and a reader obtains them as they normally would.

## 6. Findings

**F-A1 — the two clause-(iii) ancestry cards are SINGLE-PASS and NOT REFEREED, as of 2026-08-13.**
`lit-harman-q-polya-qbinomial-basis` and `lit-harman-z-variable-lusztig-cartan-form` both carry
`status_note: "REGISTERED SINGLE-PASS, NOT REFEREED … A second, independent referee pass has NOT
been run"`, `verdict: none on file`, unchanged since 2026-08-09. The referee pass **has been
requested and is outstanding** (REQUEST `20260812T201756Z-hypervisorA-77484-182d`, still unread in
the Librarian's inbox), and the requester's own words are that "its absence is now the kind of
defect the 08-03 audit predicts", precisely because these cards carry the ancestry the edition leads
with outwardly.

The edition's response is **not** to suppress the citation and **not** to launder it:

- both cards are cited, and the concordance's `ancestry` field prints
  `single-pass, not refereed (as of 2026-08-13)` **in the row**, not in a footnote;
- the frames are restated by the edition in current symbols (§3.1), so a reader is never asked to
  transport retired symbols themselves;
- the evidence that *is* on the cards is stated for what it is: read by eye from the printed page,
  with the load-bearing normalisation confirmed on the oracle 49/49 over `0 ≤ n,k ≤ 6`. That is
  materially better than the defective population the audit measured — and it is still not a
  referee pass.

**F-A2 — every card this edition cites is written in retired notation.** The manuscript migrated on
2026-08-10; no card did. This is why §3 exists and why the concordance's frame field is a
restatement rather than a quotation. It is also a standing hazard for the *next* edition, which will
face the same six cards.

**F-A4 — four rows claimed "none located" with no search behind them.** Found by the form, against
this edition's own author, and fixed by running the searches rather than rewording the rows. The resulting searches are §7 below.

**F-A3 — a resolved four-way reconciliation is NOT claimed.** The reconciliation
`T^Lus = N = T_WN = T_HH` remains **open** on the shelf: three frame differences block chaining and
no shelf-wide normalisation is fixed. This manuscript does not chain through it, and **this edition's
ancestry prose must not be read as claiming that the Harman–Hopkins lattice *is* the programme's
Newton lattice.** It is the ancestor of the transported argument, which is a weaker and true claim.

## 7. The edition-level searches of 2026-08-13

Three results carried no ancestry search when the edition was first assembled (finding F-A4). The
searches were run rather than the rows reworded. All queries below are verbatim, all against the
statement, object and transcript shelves through the Library's typed interface, on **2026-08-13**.

### 7.1 Definition 1 — the presented torus with a free invertible parameter

**The answer splits, and the split is the finding.**

**Presentation half — PREDECESSOR LOCATED.** Lusztig, *Introduction to Quantum Groups*, **Proposition
3.2.4** (card `lit-lusztig-triangular-decomposition-toral-freeness`): the associative `ℚ(v)`-algebra
on generators `K_μ` (`μ ∈ Y`) with the lattice relations, *"(This is the group algebra of `Y` over
`ℚ(v)`.)"* — precisely our `K_{0,±}=1`, `K_{m+n,±}=K_{m,±}K_{n,±}`, with `Y` in place of `ℤ`.
**Cite the parenthesis, not only the proposition**: the freeness on `{K_μ}` lives in that
parenthetical remark, so a citation omitting it supports a presentation but not a basis. Frame in
current symbols: Lusztig's `v` is our `v`; one Cartan family; **no `t`, no integral structure** —
his `_𝒜U` is defined only for a simply connected root datum and declared unused in the sequel.

**Family-parameter half — NONE LOCATED.** No predecessor anywhere on the shelf for the second leg
`K_{n,−}` together with an adjoined **free invertible** `t` satisfying `K_{1,+}K_{1,−} = t`. This is
a **positive absence rather than a silent zero-hit**: three independently written cards assert it as
a frame fact — `lit-dcp-generic-harish-chandra-isomorphism` ("no family parameter"),
`lit-dcp-verma-contravariant-shapovalov` ("no family parameter"), and the Losev–Tsymbaliuk–Vu
transcript ("no central group-like `z_a`"). The nearest structural neighbour, **and not a
predecessor**, is Lacabanne's double Cartan, whose second parameter is the *quotient*
`z_i = K_i L_i^{-1}` — a central root-torus variable, not an adjoined free one. Our own predecessor
for this half is ours: transcript `own-habiro-le-even-hybrid-centers-explicit-torus (our internal note — pinned by this edition's manifest, not distributed with it)` §2 and
`objects/gl4.coordinate-split-torus`.

**Queries:** `group algebra of the weight lattice torus Laurent Cartan part K_i invertible` (0) ·
`hybrid family torus` (0) · `K_n^+ K_n^-` (0) · `hybrid torus` (11) · `Cartan part` (30) ·
`split torus` (6) · `z_i = K_{i,+}K_{i,-}` (0) · `group algebra` (10) · `central group-like z_a` (0)
· `family parameter` (9) · `generators and relations` (33). **No acquisition warranted** — the
absence is structural, not a gap in holdings.

### 7.2 The non-degeneracy pin — predecessors located, in three layers

**Classical:** **Pólya 1919**, via the held transcript
`harman-hopkins-quantum-integer-valued-polynomials`, Proposition 1.1 — `ℛ` is freely generated as an
abelian group by the binomial polynomials `binom(x,k)`. **The logical gap is named and not closed
silently:** the source states a *basis*, not a strict inclusion. Strictness follows immediately
(`binom(x,2)` is integer-valued and not in `ℤ[x]`), so the honest phrasing is *"Pólya's basis
theorem, from which the strict containment is immediate"* and never *"Pólya proved the strict
containment"*.

**q-analogue:** Harman–Hopkins §1, Propositions 1.1–1.2 — one variable, additive grid, coefficient
ring `ℤ[q]` or `ℤ[q^{±1}]`, no free parameter.

**Ours, for the witness only:** `even-gaussian-span-not-newton-lattice-refuted` displays the
identical separating element `ν_1(Y̌) = (Y̌−1)/(q−1)` and proves a strict inclusion — **but of a
different pair, by a different mechanism** (it separates the Gaussian-generator span from the Newton
lattice by a finer-versus-coarser grid; this edition's row separates `A_t[Y̌^{±1}]` from `N^ev` by a
non-unit coefficient). A predecessor for the **witness**, not for the **inclusion**, and the edition
says which.

**Queries:** `integer-valued` (47) · `Polya` (2) · `Cahen` (2) · `P(x) integer-valued but not in
Z[x]` (0) · `strictly larger than the Laurent` (0) · `strict inclusion` (2) · `Newton lattice` (31).

**ACQUISITION WANTED, and this is the textbook case:** **Cahen–Chabert, *Integer-Valued
Polynomials*, AMS Surveys 48 (1997)** — the standard reference, **cited by our own held source**,
never on our shelf. Also Pólya 1915 and Gramain 1990. Until they are held, the classical statement is
reachable only *through a quotation inside another paper*, and this edition says so rather than
citing what it does not hold.

### 7.3 The coefficient-field bridge — NONE LOCATED, with the search recorded

**Queries:** `base change` (138) · `faithfully flat` (21) · `extension of scalars` (5) ·
`localization` (66). Every hit unrelated: `faithfully flat` lands in q-Witt-vector material; the
statement-shelf `base change` hits are our own `SP-2026-031`'s convention frame (a
notation-migration base change, **not** an integrality-invariance theorem); `extension of scalars`
returns nothing about integer-valued rings.

**Assessed and REJECTED as a predecessor: Harman–Hopkins §4 Proposition 4.3**
(`ℛ_q = ℛ⁺_q ⊗_{ℤ[q]} ℤ[q,q^{-1}]`). It is **adjacent, not ancestral**, and the edition declines to
cite it, for three reasons that point the opposite way:

1. **4.3 says the object GROWS by a controlled amount and identifies the enlargement; this row says
   it does NOT grow.** "Bigger, and here is exactly how much bigger" is not evidence for "not bigger
   at all", however much both statements wear the word *localization*.
2. **Their localization inverts the DEFORMATION parameter `q`; this row moves the FAMILY parameter
   `t`** — which their setting does not have at all.
3. **Their Lemma 4.2 varies the grid** (`n ∈ ℕ` to `n ∈ ℤ`) at the same time as the coefficients;
   this row holds the grid fixed and moves only the ambient field.

It is the kind of citation that reads well and warrants nothing. **Acquisition:** subsumed by §7.2's
Cahen–Chabert request, whose several-variables and base-change material is the natural home for such
a rigidity statement, rather than filed as a second request.

### 7.4 A defect in the shelf, found on the way and not this edition's to fix

`list_by_goal("center-GL1")` returns **no routed cards at all**: the live routing document
(`corpus/CARD_ROUTING_2026-07-17.md` (pinned by this edition's manifest, not distributed with it)) has no `center-GL1` section, so this goal is served today only
by cards that happen to name it in a `feeds` field. Reported to the Librarian; recorded here because
an edition that depended on that routing would have been depending on nothing.

## 8. The five definitions of the signed goal — searched 2026-08-13

**Why this section exists.** The signed goal `goalv0a.tex` predates criterion 13. A proposed record
act would have declared `\nopredecessor` on all five of its numbered definitions. Manifest §6b
forbids writing such a declaration before the failed search behind it is recorded — *a
`\nopredecessor` is a substantive claim about the literature, not a formatting line.* These are
those searches. **The per-definition verdicts are in `DEFINITION_VERDICTS_2026-08-13.md`.**

**The headline: of the five proposed declarations, at most one would have been true, and even that
one is a half.** Three definitions have located, quotable predecessors. The edition records this
because the near-miss is the finding: the reading that all five were "definitions of the object under
study, hence without predecessors" was **this Editor's own**, offered in good faith, endorsed in good
faith, and refuted by the first search that tested it.

| definition | verdict |
|---|---|
| `def:U` (the presented algebra) | **SPLIT** — cite Lusztig Prop. 3.2.4 for the presentation; `\nopredecessor` honest only for the adjoined free `t` |
| `def:nev` (the even Newton lattice) | **predecessors located** — `\nopredecessor` would be false |
| `def:nu` (the divided classes) | **predecessor located, exactly** — `\nopredecessor` would be false |
| `def:uev` (the integral form) | **predecessor located** for the shape (Habiro–Lê, *published* Thm 8.11(c)) |
| `def:hc` (HC projection, shifted Weyl action) | **cite the theorem's own cards**, plus a degenerate-rank note; the shift *placement* is ours |

### 8.1 `def:nu` — an exact identification, not a resemblance

The one result here that is arithmetic rather than judgement. Our
`ν_r(X) = ∏_{s<r}(X − q^s)/(q^r − q^s)` is **exactly** the Harman–Hopkins `q`-binomial coefficient
polynomial under the node-preserving substitution `X = 1 + (q−1)x` — *not* merely equal up to a unit:

- the denominator `∏_{s<r}(q^r − q^s)` factors as `q^{binom(r,2)} (q−1)^r [r]_q!`;
- each numerator factor `X − q^s` becomes `(q−1)(x − [s]_q)`;
- the two factors of `(q−1)^r` cancel, leaving their polynomial with its `q^{binom(r,2)}[r]_q!`
  denominator on the nose.

Verified symbolically in the fraction field of `ℚ[q][x]` for `r = 0…6`, certificate
`4e97ac26f5351d271b7dbfa2ed9e57997224adf346852df49be0dbbc30afbfb4`. A second check confirms the
multiplicative-grid reading — `ν_r(q^m)` is the one-sided Gaussian binomial for `0 ≤ m ≤ 7`,
`0 ≤ r ≤ 5` — and that values at **negative** nodes remain Laurent (e.g. `ν_2(q^{-2}) =
(q²+q+1)/q⁵`), which is what `def:nev`'s bilateral condition `χ ∈ ℤ` requires. Certificate
`b97ca632baedd6d1e33450b9d3e72a6b08246bc53734c7e46087d2f6224a217c`.

### 8.2 `def:nev` — and the acquisition that blocks a declaration on it

Predecessors: Pólya (quoted as Harman–Hopkins Prop. 1.1), the `q`-deformed additive-grid basis
(`lit-harman-q-polya-qbinomial-basis`), and — the form `def:nev` actually uses, since its grid is
`χ ∈ ℤ` rather than `ℕ` — the **bilateral** statement `lit-harman-bilateral-q-integer-localization`
§4 Lemma 4.2(2). The multiplicative-grid transport is itself carded
(`lit-harman-z-variable-lusztig-cartan-form`), with the two cautions this edition already carries:
the substitution divides by `q − 1`, so it is a change of coordinate rather than an isomorphism of
integral lattices, and the source's letter `z` is our `Y̌`, never our `t`.

**What is missing is the multiplicative-grid ancestor specifically.** Gramain, *Fonctions entières …
prenant des valeurs entières sur une progression géométrique* (LNM 1415, 1990) is precisely "integer
values on a **geometric progression**" — the classical statement over our exact grid — and it exists
on this shelf **only inside two Harman–Hopkins cards' bibliographies**. So does Cahen–Chabert (AMS
Surveys 48) and Ostrowski 1919. Under §6b, *a predecessor that exists but is not held blocks a
declaration exactly as firmly as a located card does.*

**Acquisition of record for this definition: REQUEST `20260813T111346Z-editor-56787-5977`** (both
titles; confirmed by the record owner as the id the repair instrument cites). Detail in §8.5.

**Queries:** `integer-valued` (47) · `Polya` (2) · `ostrowski` (1) · `Cahen` (2) · `Gramain` (2) ·
`geometric progression` (6) · `P(x) integer-valued but not in Z[x]` (0) · `strict inclusion` (2) ·
`Newton lattice` (31). *Recorded because it will bite the next searcher: `ostrowski` returns 1 and
`Ostrowski` returns 0 — the shelf search is smart-case.*

### 8.3 `def:hc` — the row that wants neither a citation nor a declaration

At `GL₁` both stated clauses are **empty**: `HC = id` because there is nothing to project, and `W` is
trivial, so `w(Y_n) = Y_{wn}` is the identity and `(N^ev)^W = N^ev`. What the definition genuinely
fixes is the **coordinate** `Y_n = t^{-n} K_{n,+}^2` — the shift carried *in the coordinate rather
than in the map*. De Concini–Procesi instead carry it in the twist `γ(K_λ) = q^{(ρ|λ)}K_λ`, and
Jantzen's route needs a dictionary the card records as **not written**. Both cards independently
attribute the coordinate placement to this programme. So the honest row cites the theorem's own cards
for the projection-and-invariance pair, records that **the shift-placement convention is ours with no
located predecessor**, and notes that the definition is degenerate at this rank.

### 8.4 One thing owed elsewhere — now DISCHARGED, and the second home is filled

The Librarian flagged — unprompted, twice — that its own `MINING_LOG.md` (held in the Library — pinned by this edition's manifest, not distributed with it) line covering these searches
was **owed and not yet written**, because this Editor set the task read-only. The searches are
recorded here (queries, shelves, date), which is what §6b requires of the edition; but §6b exists so
that a cited search is *findable afterwards*, and one of its two homes was empty.

**WRITTEN 2026-08-14, commit `650200ae` — `corpus/MINING_LOG.md`, entry "2026-08-13 (§6b) — the A0a
edition-level definition searches, journalled late".** It records both query sets with their hit
counts, the verdict that **at most one of the five proposed `\nopredecessor` declarations survives
and that one only as a half**, the acquisition block on `def:nev`, and the `center-GL1` routing gap
found on the way — **and it says openly that it is late and why.** §7 here and that journal now say
the same thing in both homes, which is the whole point of §6b. **Nothing is open against the
Library.** *(It went in about an hour before this seat restated the item, so the restatement crossed
it — recorded because a stale "still owed" is its own small defect.)*

### 8.5 The two acquisitions, and the sweep that confirmed they are real

**Filed 2026-08-13** as REQUEST `20260813T111346Z-editor-56787-5977` to the Librarian. **Both are
now HELD, READ, AND CARDED**, so **no acquisition `LR-` id is owed** — the Librarian ruled (and this
edition accepts) that *the ancestry record cites CARD IDS, not request ids*, because a card is what
resolves under criterion 13:

| source | card |
|---|---|
| Gramain, LNM 1415, Prop. 2.2, p. 124 | `lit-gramain-geometric-progression-integer-valued-basis` |
| Cahen–Chabert, Prop. I.3.1 + Rem. I.3.2, p. 9 | `lit-cahen-chabert-vandermonde-coefficient-descent` |
| Harman–Hopkins q-Pólya basis | `lit-harman-q-polya-qbinomial-basis` *(qualification added 2026-08-13)* |

Both cards were **read at source by the Librarian**, not transcribed from this edition's reports —
which is why the frame reading below is corroborated rather than merely repeated.

**CITE BY ARTICLE, NEVER BY VOLUME** — a trap the Librarian hit and put on the card. LNM 1415 is a
*volume* whose articles number independently, and searching it for "Proposition 2.2" lands **first on
a different article's statement about primes `p^k` dividing a binomial-type coefficient.** The
citation must read *"Gramain, LNM 1415, Prop. 2.2, p. 124"* and never *"LNM 1415 Prop. 2.2"*, or a
reader following this row with a naive search arrives at the wrong statement.

1. **Gramain**, *Fonctions entières … prenant des valeurs entières sur une progression géométrique*,
   LNM 1415 (1990) — the classical statement over a **multiplicative** grid, which is our grid. Every
   ancestor we hold is on the additive grid and reaches ours only through the substitution.
2. **Cahen–Chabert**, *Integer-Valued Polynomials*, AMS Surveys 48 (1997) — the standard reference,
   **cited by our own held source**. **RECEIVED 2026-08-13 13:37**; title page verified as
   **Paul-Jean** Cahen and Jean-Luc Chabert, AMS Surveys and Monographs vol. 48 — i.e. the right
   Cahen, resolving the wrong-author trap below. PDF page offset: printed 1 = PDF 25. Its bearing on
   row A0a-09 is under reading; **it gated no declaration** and was never on the critical path once
   Gramain landed. Its several-variables and base-change material is
   also the natural home for the rigidity statement §7.3 searched for and did not find, so no third
   request was filed.

**Both were swept for locally before being treated as real**, over the estate's whole document store
(~29.5k PDFs), case-insensitively, on 2026-08-13: `gramain` → 0; `progression géométrique` /
`ganzwertige` → 0; `1415` → 0 relevant; `integer valued` → only our own Harman–Hopkins material,
already carded. **Both are genuinely absent**, so the acquisitions stand.

**A trap recorded because it nearly closed the acquisition wrongly.** A surname sweep for `cahen`
returns four confident-looking local hits — **and every one is the wrong Cahen**: Moshé Cahen
(Berezin–Weyl quantization, Kähler manifolds, Dooley–Rice contraction). The integer-valued-polynomials
author is **Paul-Jean** Cahen. A seat in a hurry could mark this "already held" and close the request
on four irrelevant files. This is the same shape as the smart-case trap in §8.2 (`ostrowski` returns
1, `Ostrowski` returns 0): *a query returning something is not a query returning the right thing.*

### 8.6 ACQUISITION FULFILLED — Gramain is held, and it settles `def:nev` by CITE

**LNM 1415 arrived on the shelf 2026-08-13 13:27** as the conference volume
`corpus/literature/pdf/Cinquante Ans de Polynomes - Fifty Years of Polynomials LNM 1415.pdf`
(*Cinquante Ans de Polynômes / Hommage à Alain Durand*, ed. M. Langevin). **Gramain's article is
inside it**, and the volume's own table of contents gives the locus:

> **F. Gramain**, *Fonctions entières d'une ou plusieurs variables complexes prenant des valeurs
> entières sur une progression géométrique*, **printed pp. 123–137**. (PDF offset +9: printed 123 =
> PDF page 132.)

**The predecessor is §2, Proposition 2.2, printed p. 124** — quoted verbatim:

> **PROPOSITION 2.2 :** *Soit `q ≥ 2` un entier naturel. L'ensemble des polynômes `P ∈ ℂ[X]` tels que
> `P(q^k) ∈ ℤ` pour tout `k ∈ ℕ` est le ℤ-module engendré par les polynômes binomiaux de Gauss*
> `G_0 = 1`, `G_n(X) = (X−1)(X−q)⋯(X−q^{n−1}) / ((q−1)(q²−1)⋯(q^n−1)) · q^{n(n−1)/2}`, *pour tous les
> entiers `n ≥ 1`.*

That is **the integer-valued statement on a multiplicative grid**, generated by Gauss binomial
polynomials — the classical ancestor of `def:nev` and of `def:nu` together, over our grid rather than
reached through the additive substitution. Its companion **Proposition 2.1** (same page) is the
classical **additive** Pólya statement on the Newton binomials `N_n(X) = binom(X,n)`, so the volume
carries both halves side by side and *names the passage between them*.

**CORRECTED 2026-08-13 — `G_n = ν_n` EXACTLY.** Gramain's printed exponent is **negative**: he
*divides* by `q^{n(n−1)/2}` where this edition first read him as multiplying. His normalization **is**
ours, not ours up to a unit.

**Settled from the page's own content, independent of the glyph** — which matters, because the minus
is invisible at ordinary rendering resolution and absent from the scan's text layer. Printed p. 125,
inside the proof of Proposition 2.2: ***"On voit que `G_n(q^n) = 1`"***. Our `ν_n(q^n) = 1` holds by
construction, so the exponent **must** be negative; a positive one would give `G_n(q^n) = q^{n(n−1)}`.
The page states the normalization, and the normalization forces the sign. A second reading at 500 dpi
by two other seats found the minus present.

**WITHDRAWN: the claim `G_n = q^{n(n−1)}·ν_n` and its certificate `b058e915…`.** The certificate is
not false — it faithfully certifies that identity **for the formula that was typed into it**, which
carried a dropped minus.

**The correction makes the row stronger, not weaker:** exact coincidence of normalizations rather
than agreement up to a unit.

**Frame, and it is a real difference the row must carry.** Gramain's `q` is a **natural number
`≥ 2`**, his coefficients are **ℤ**, and his `X` is a complex variable; ours is `q` an
**indeterminate** with coefficient ring `A_t = ℤ[v^{±1}, t^{±1}]` and no free parameter on his side
at all. So `q^{n(n−1)}` is **a unit in our ring and not in his** — the two normalisations are
interchangeable for us and not for him. His statement is about a *ℤ-module of complex polynomials*;
ours about an `A_t`-lattice. **Ancestor of the form, not a citable instance of our statement.**

**One caution that makes the citation stronger, not weaker.** Gramain says of both propositions
*"Les deux résultats suivants sont sans doute classiques"*, and his §1 explains why he proves them
anyway: they are *"des résultats classiques sur les polynômes à valeurs entières, résultats qui ne
semblent pas disponibles dans la littérature"* — doubtless classical, **but not available in the
literature**. So Gramain is the *citable* source for the multiplicative-grid statement precisely
because the folklore version has no earlier printed home. He also records the deeper context: the
entire-function analogue on a geometric progression is **Gel'fond 1933**, the *"analogue
multiplicatif du problème additif précédent"* (Pólya 1914).

**CONSEQUENCE FOR THE RECORD ACT.** `\nopredecessor` on `def:nev` is now **definitively false**, and
the §6b block on it is **discharged in the CITE direction**: the row cites **Gramain, LNM 1415,
Proposition 2.2, p. 124**, with the frame above. The same locus strengthens `def:nu`'s ancestry from
a `q`-deformed analogue (Harman–Hopkins) to a *classical* one on our own grid.

## 9. Cahen–Chabert, read 2026-08-13 — one predecessor found, and one error of ours exposed

The second acquisition arrived at 13:37 and was read the same hour. It resolves the edition's one
remaining `none located`, corrects a claim on a card we cite, and confirms Gramain as the source of
record. Copy read as **page images**, not from the scan's text layer, which is noisy (it renders `K`
as `kK`). Offset: printed p. 1 = PDF sheet 25.

### 9.1 Row A0a-09's predecessor — Proposition I.3.1, printed p. 9

**Found in §I.3 "Trivial cases", subsection *Vandermonde* — not in §I.2 Localization**, which is
adjacent only and which the edition had already searched.

> **PROPOSITION I.3.1.** *Let `D` be a domain contained in a field `L` and `f` be a polynomial of
> degree `n` with coefficients in `L`. If `a₀, …, aₙ` are `n+1` elements of `D` such that
> `f(aᵢ) ∈ D`, and if `d = ∏_{i<j}(aⱼ − aᵢ)`, then `df ∈ D[X]`.*

> **Remarks I.3.2.** (i) *… if `E` is an infinite subset of `K`, then a polynomial with coefficients
> in a larger field which maps `E` into `D`, is in fact a polynomial with coefficients in `K`.* …
> (ii) *If `E` is finite, however, it would make sense to consider polynomials with coefficients in a
> larger field `L` mapping `E` into `D` … We should then probably denote by `Int(E, D, L)` …*

That is this row's claim, made in 1997: the evaluation set and target fixed, only the ambient
enlarged, and integrality on an **infinite** evaluation set forcing the coefficients back down. They
even name the enlarged object and record that it is new **only for finite** evaluation sets. Ours is
infinite.

**Why the proposition and not just the remark.** Remark I.3.2(i) lands coefficients in the *quotient
field*; this row needs them in `F_t = ℚ(v)[t^{±1}]`, which is **not** a field. Proposition I.3.1 is
sharper than the remark drawn from it: it lands them in `(1/d)·A_t` with `d` an **explicit** product
of node differences. Every node here is a power of `q`, so `d` lies in `ℤ[q^{±1}]` and **carries no
`t`** — no `t` can enter a denominator, which is exactly the non-field landing the row needs.

**Adjacent and explicitly rejected**, recorded so nobody re-searches them: all of §I.2; §IV.3 Prop.
IV.3.4 / Cor. IV.3.5 (pp. 82–84); §IV.4; Chapter IV Exercise 3 (p. 91). Across the whole book
**exactly three passages vary a field at all**, and only p. 9 varies the *ambient*.

### 9.2 An error of ours, exposed by the reading — and it is the one this file warns about

The brief written for this reading described our base ring as `A_t = ℤ[q^{±1}, t^{±1}]`. **The signed
goal says `A_t = ℤ[v^{±1}, t^{±1}]`** — with `v`. The migration sends the *retired* `q` to the
*current* `v`, so the retired `A_z = ℤ[q^{±1}, z^{±1}]` becomes `ℤ[v^{±1}, t^{±1}]`, and translating
the retired `q` to a current `q` is precisely the **inverted dictionary** this section exists to
prevent. It appeared twice in this file, **including in §3.1's own translation table**, corrected
2026-08-13.

**Bounded, and the spine was never wrong:** `CONCORDANCE.json` and `EMBEDDING_NOTE.md` both carried
`ℤ[v^{±1}, t^{±1}]` correctly throughout. The defect was confined to this file's prose.

**It had one knock-on worth recording.** Under the mis-stated ring, `F_t = ℚ(v)[t^{±1}]` is *not*
contained in `Frac(A_t) = ℚ(q,t)`, and the reading duly reported "a frame problem in your setup".
**That reported problem is an artefact of the bad brief, not a defect in the record or the
concordance**: under the correct `A_t`, `Frac(A_t) = ℚ(v,t) ⊇ ℚ(v)[t^{±1}] = F_t`, and the
containment holds. A false finding about the record was one step from entering it.

### 9.3 A correction owed to a card we cite — Chapter II, Exercise 15, printed p. 46

Our card `lit-harman-q-polya-qbinomial-basis` quotes Harman–Hopkins saying their Proposition 1.2 "is
essentially the same as [CC97, Chapter II, Exercise 15]". Read directly, **it is not the same
statement**, in three ways: Exercise 15 evaluates on the **multiplicative** set `{q^k}` where Prop.
1.2 evaluates on the **additive** `q`-integers; Exercise 15's `q` is **a fixed integer ≥ 2** where
theirs is an indeterminate; Exercise 15 gives a **ℤ**-module basis of `Int(E, ℤ)` where theirs is a
free `ℤ[q]`-module. "Essentially" is a defensible informal remark about family resemblance; a reader
following the citation expecting Proposition 1.2 will not find it.

**For us the mismatch cuts the helpful way** — Exercise 15 is in the *multiplicative* frame, which is
ours.

**JOINTLY VERIFIED 2026-08-13 — both misprints in Exercise 15(ii) STAND**, after a retraction by
this seat that turned out to be over-broad. The sequence is worth keeping, because the near-miss ran
in both directions.

When the Gramain reverse pass showed that a printed minus in this material is invisible at ordinary
rendering resolution, this seat inferred that its reading of Cahen–Chabert's prefactor was probably
the same defect, and **retracted the misprint claims as unsafe**. That inference was wrong. The
Librarian had independently rendered printed p. 46 as a page image at the same time, reached sheet 70
by the same route, and **confirmed both misprints line for line** — re-deriving the prefactor
refutation **symbolically in `q`** rather than on seeds: with the printed sign,
`gₙ(q^n) = 1, q², q⁶, q¹²` for `n = 1…4` (certificate `ebece83d`), against the page's own
`gₙ(q^n) = 1`. This edition's seed-based refutation `eec044c7…` is cited on their card as the
independent prior.

**The two books genuinely differ, and that is the whole point:** Gramain **prints** the minus, so his
formula is correct and `G_n = ν_n`; Cahen–Chabert **dropped** it in transcribing from him, so their
exercise contradicts its own stated normalization two lines below. **The same low-resolution reading
was wrong about Gramain and right about Cahen–Chabert** — which is why neither the resolution
argument nor its negation could settle either book, and why the independent read was needed.

So the finding is **stronger** than first stated: C–C's prefactor error is precisely *a dropped minus
in a transcription from a source that prints it correctly*, and their own citation `[143]` points at
that source. Carded as `lit-cahen-chabert-ex15-erratum-two-misprints`, recording both misprints, the
corrected part (ii), the joint route (sheet 70, offset +24, text layer abandoned), and the three
ancestry rows read off the page — `[137, p. 16]` Gauss for the definition, `[168, I]` Pólya–Szegő for
the integrality, `[143, Prop. 2.2]` Gramain for (iii). The Harman–Hopkins qualification is no longer
carried on this seat's reading alone.

*The superseded retraction, retained so the record shows what was claimed and withdrawn:* (upgraded 2026-08-13 from a delegated reading, per F-A5's lesson that a delegated finding is
evidence rather than a verdict; the Librarian could not isolate the exercise because the scan's OCR
mangles chapter-level exercise numbering — it is legible as an *image*). The numerator prints `(X−1)(X−2)⋯(X−q^{n−1})`;
the second factor must be `(X−q)`, or the stated vanishing fails. The prefactor prints
`q^{n(n−1)/2}` and must be `q^{−n(n−1)/2}`: with the positive exponent `gₙ(q^n) = q^{n(n−1)} ≠ 1`,
**self-contradictory on the page**, with no kernel needed: at `X = q^n` the numerator product
`∏_{s<n}(q^n − q^s)` already equals `q^{n(n−1)/2}∏_{j=1}^{n}(q^j − 1)`, cancelling the printed
denominator exactly, so the printed form gives `gₙ(q^n) = q^{n(n−1)}` while the page states
`gₙ(q^n) = 1` two lines below. Also machine-refuted at seeds `(q,n) = (3,2), (2,3), (5,4)` (identity
sha256 `eec044c7…`); the negative exponent confirms both printed evaluation claims (`c7dd85af…`,
`ed681223…`).

**And the Gramain attribution is on the page in the book's own hand**, verified first-hand: Exercise
15(iii) ends *"…if and only if `f(q^k) ∈ ℤ` for `k = 0,1,…,n`. **[143, Proposition 2.2]**"*.

### 9.4 Gramain confirmed as the source of record

Cahen–Chabert treats the geometric progression **in exactly one place** — Exercise 15 — **states it
without proof**, and attributes it to **`[143, Proposition 2.2]`**, whose bibliography entry (printed
p. 315) is Gramain, LNM 1415, pp. 123–137: *the very proposition this edition already cites*. Gramain
is cited exactly once in the whole book. The only internal pointer to the multiplicative case is one
sentence, Remark I.1.3(i), p. 2: *"For a multiplicative analogous result, see Exercise II.15."*

**So Cahen–Chabert is not a better home for `def:nev` than Gramain** — it is a signpost confirming
Gramain, and its own attribution points at exactly the proposition we hold. Its Exercise 15 is also
stated for `q` a fixed integer with values in `ℤ`, so it never reaches a parameter-carrying
coefficient ring, which our setting requires.

**Searched and absent**, for the record: "geometric progression", "progression", "geometric",
"q-analogue", "Gaussian binomial", "Gramain", "Vandermonde", "subfield", "larger field", "smaller
field", "field extension" across all 352 sheets, the subject index (pp. 319–322) and the bibliography
(pp. 305–318). No index entry exists for "geometric progression" or "Vandermonde"; the sole relevant
index entry is *Gaussian binomial coefficient, 46* — the exercise.

## 10. Redundancy of the ancestry, measured — and the one source that is single-carded

**Measured 2026-08-15**, first by the Librarian over this edition's eleven concordance rows and then
**independently here, with a different denominator and a different answer worth stating precisely.**

**The good half reproduces.** Normalising the concordance's named records to the external works
behind them gives **six works** — Harman–Hopkins, Lusztig, De Concini–Procesi, Jantzen,
Cahen–Chabert, Gramain. Counted **Library-wide** (342 statement cards), five carry two or more cards:
Lusztig 37, De Concini–Procesi 12, Harman–Hopkins 8, Gramain 4, Cahen–Chabert 3.

**The exception, which this seat could not make disappear: JANTZEN, *Lectures on Quantum Groups*
(GSM 6), IS CARRIED BY EXACTLY ONE CARD IN THE WHOLE LIBRARY** —
`lit-jantzen-harish-chandra-even-torus`. One other card names the book in its body
(`lit-v2.jantzen-dilated-linkage-blocks` — a card built from an unpublished collaboration draft, pinned
by this edition's manifest as evidence for this sentence but **not distributed with it**) but not as a
source, and the many other Jantzen mentions
across the shelf are **different Jantzen works** — the sum formula, the filtration, affine walls.

**What that does and does not mean.** *No row of this edition is one card-defect away from being
unsupported*: the only row citing Jantzen, **A0a-02 (clause ii)**, cites it **alongside** De Concini–
Procesi §18.3 (12-carded) and our own in-programme predecessor `gl2-hc-image-theorem`. So the
property that matters for the rows holds. **The stronger reading — every source behind the edition is
multiply carded — does not.**

**And the single-carded source is the one already known to be partial.** That same card records on
its face that §§6.4–6.5, 6.22, **6.26 and 8.30 are not transcribed**, and 6.26/8.30 are where the
later extension of Thm 6.25 lives (§4, rider 1). **Single-carded and self-declared incomplete is the
weakest ancestry point in this edition**, and it is stated here rather than left to be found — it
warrants no repair by this seat, since the row it serves is independently supported, and a second
Jantzen card is the Library's to write if it ever wants one.

**Correction and method limit, same night, and it is against this seat's own count.** The Librarian
re-measured before answering, keyed on the **work** and counting **distinct citing cards**, and
**confirmed the exception**: Jantzen GSM 6 → **1 card**; De Concini–Procesi → 3, Lusztig → 16,
Harman–Hopkins → 7. They **withdrew "zero single points of ancestry"** as a false reassurance, having
computed `blob.count(source) < 2` over a concatenation of all cards — **which counts OCCURRENCES, not
CITERS**: one card naming a source in both its `sources:` field and its body scores 2 and passes.

**This seat's numbers above (Lusztig 37, DCP 12, …) are NOT method-safe and are superseded by
theirs.** They were keyed on a **surname**, which does not distinguish *works*: the shelf's Lusztig
citations include both *Introduction to Quantum Groups* and **Lusztig 1990**, a different paper.
**The conclusion survives on the better measurement, not on this one** — all five still carry ≥ 2
citing cards under the stricter count.

**The lesson is sharper than either error.** This seat applied work-level discrimination — checking
the printed title — to **exactly one** of the six: Jantzen, the case it was already suspicious of.
The other five were passed on a surname. ***A check applied only where you already suspect the
answer is not a check; it is a confirmation of the suspicion you brought.*** Both seats over-counted
from the same instinct in opposite directions — **counting the convenient token rather than the
thing.**
