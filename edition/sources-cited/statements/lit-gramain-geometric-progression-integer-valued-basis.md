---
id: lit-gramain-geometric-progression-integer-valued-basis
status: literature-theorem
provenance: cited
provenance_note: "François Gramain, *Fonctions entières d'une ou plusieurs variables complexes prenant des valeurs entières sur une progression géométrique*, in **Cinquante Ans de Polynômes / Fifty Years of Polynomials**, Lecture Notes in Mathematics **1415**, Springer — **Proposition 2.2**, printed p. 124 (article pp. 123–137). Volume held at `corpus/literature/pdf/Cinquante Ans de Polynomes - Fifty Years of Polynomials LNM 1415.pdf`. **Read at source and verified by the Librarian 2026-08-13**; located on the Editor's `20260813T113239Z`. **Grade: refereed.**"
lens: the-classical-multiplicative-grid-statement-that-is-the-ancestor-of-the-Newton-lattice-and-exactly-how-its-frame-differs-from-ours
sources: ["corpus/literature/pdf/Cinquante Ans de Polynomes - Fifty Years of Polynomials LNM 1415.pdf — Gramain's article, Proposition 2.2 at printed p.124", "Editor 20260813T113239Z — the reading, the frame difference, and the Gel'fond ancestry"]
feeds: ["the A0a edition — `def:nev` cites this; the Editor reports `\\nopredecessor` there is now definitively false", "lit-harman-q-polya-qbinomial-basis — the `q`-deformed analogue; see the qualification banner on that card", "lit-cahen-chabert-vandermonde-coefficient-descent — Cahen–Chabert Ch II Ex 15 is a signpost TO this proposition"]
created: 2026-08-13 (Librarian, on Editor 20260813T113239Z)
conventions_gap: "**`q` IS A NATURAL NUMBER `≥ 2`, NOT AN INDETERMINATE.** Gramain's polynomials live in `ℂ[X]` and integrality means landing in `ℤ`. The programme's setting has `q` an indeterminate over `A_t = ℤ[v^{±},t^{±}]` *(note: the base ring is `ℤ[v^{±},t^{±}]` per the signed goal — the Editor corrected their own record on this same day, see their F-A5)*, and states an `A_t`-**lattice**, not a `ℤ`-module of complex polynomials. **This is an ancestor of the FORM, not a citable instance of our statement.**"
traps: ["**⚠ CORRECTED 2026-08-13, SAME DAY, BY THE LIBRARIAN: GRAMAIN DIVIDES BY `q^{n(n−1)/2}` — HE DOES NOT MULTIPLY. THE EARLIER TRAP ON THIS CARD SAID THE OPPOSITE AND WAS WRONG.** The printed formula (p. 124, read at **500-dpi page image**, where the low-resolution render and the scan's text layer both lose the sign) is `G_n(X) = [(X−1)(X−q)⋯(X−q^{n−1}) / ((q−1)(q²−1)⋯(qⁿ−1))] · q^{**−**n(n−1)/2}` — the exponent carries a **minus**. **So Gramain's normalisation is OURS**, not its inverse: he divides by `q^{binom(n,2)}` exactly as we do. Machine confirmation, symbolic in `q` (not seeded): with the negative exponent `G_n(q^n) = 1`, `G_n(q^k) = 0` for `k < n`, and `G_n(q^k) = [k n]_q` for `k ≥ n`; with a positive exponent `G_n(q^n) = 1, q², q⁶, q¹²` for `n = 1…4`, i.e. `q^{n(n−1)}` — certificate `expr sha256 ebece83d7038e7162207a44d789dab27919d51a846eb8b035f477d2f1e660d5e`. **The inverted reading entered from the Editor's `20260813T113239Z` and was propagated by me into this card and by hypervisorA into their record; all three are being corrected.** *(The positive exponent is what CAHEN–CHABERT prints — see `lit-cahen-chabert-ex15-erratum-two-misprints`: their misprint is exactly a dropped minus in a transcription from this proposition.)*", "**LNM 1415 IS A VOLUME, AND ITS ARTICLES NUMBER INDEPENDENTLY. THE FIRST `Proposition 2.2` IN THE PDF IS NOT GRAMAIN'S.** Searching the volume for `Proposition 2.2` returns, first, a statement about primes `p^k` dividing a binomial-type coefficient — **that belongs to a different article entirely**. Gramain's Proposition 2.2 is inside his own paper (pp. 123–137), whose title is *Fonctions entières … prenant des valeurs entières sur une progression géométrique*. **Cite `Gramain, LNM 1415, Prop 2.2, p.124`, never `LNM 1415 Prop 2.2`.** *(I hit this trap myself before catching it.)*", "~~**HIS NORMALISATION MULTIPLIES WHERE OURS DIVIDES.**~~ **WITHDRAWN 2026-08-13 — THIS TRAP WAS FALSE; SEE THE CORRECTION AT THE HEAD OF THIS LIST.** The factorisation it rests on is right and worth keeping: our denominator `∏_{s<n}(qⁿ − q^s)` factors as `q^{binom(n,2)} ∏_{j=1}^{n}(q^j − 1)`. **What was wrong is the direction**: Gramain also divides, so there is no normalisation difference to transport across. *(Recorded, not deleted, because the false reading is on other seats' records and they need to recognise it.)* **F-A6, and it was paid for here:** the withdrawn reading came with a CAS certificate (`b058e915…`, **withdrawn by its author 2026-08-13**) which measured the difference **faithfully — between two formulas, one of which had been mis-transcribed at reading time.** *A machine certificate certifies its INPUT, not the SOURCE.* Nothing but a page read at sufficient resolution can certify what is printed.", "**THE `UNIT` ARGUMENT IS STILL WORTH KNOWING, EVEN THOUGH THE PREMISE IT WAS INVOKED FOR HAS GONE.** For us `q^{n(n−1)}` is a **unit**, so normalisations differing by that factor are interchangeable in `A_t`; **for Gramain they are not** — his `q` is a fixed integer `≥ 2` and his coefficient ring is `ℤ`. That asymmetry is exactly why **Cahen–Chabert's dropped minus is a genuine error rather than a harmless convention**: in their `ℤ`-setting the two forms generate different modules.", "**HE STATES A `ℤ`-MODULE OF COMPLEX POLYNOMIALS; WE STATE AN `A_t`-LATTICE.** `{P ∈ ℂ[X] : P(q^k) ∈ ℤ for all k ∈ ℕ}` is the `ℤ`-module generated by his `G_n`. There is **no free parameter on his side at all** — no `t`, no `z`. Every structural consequence we draw from the extra parameter is ours to prove.", "**THE `sans doute classiques` REMARK STRENGTHENS THE CITATION RATHER THAN WEAKENING IT.** Gramain calls both propositions *`sans doute classiques`* and says he proves them because they are *`des résultats classiques … qui ne semblent pas disponibles dans la littérature`*. **So he is the citable home for the multiplicative-grid statement precisely because the folklore version has no earlier printed one.** Do not read `classical` as `cite someone earlier` — he is saying the opposite.", "**THE DEEPER ANCESTRY IS GEL'FOND 1933, NOT PÓLYA.** Gramain records that the entire-function analogue on a geometric progression is **Gel'fond 1933**, the *analogue multiplicatif* of **Pólya 1914**. So the additive/multiplicative split runs all the way back: Pólya on the integers, Gel'fond on a geometric progression. **That is the real ancestry line for this family**, and it is why the Harman–Hopkins `q`-deformation sits on the additive side."]
---

# Gramain, LNM 1415 Prop 2.2 — integer-valued polynomials on a geometric progression

Located by the Editor (`20260813T113239Z`), read and verified at source. **This is the classical
multiplicative-grid ancestor**, and per the Editor it makes the `\nopredecessor` marking on the
edition's `def:nev` definitively false.

## The statement

> **Proposition 2.2** (Gramain, p. 124). For a natural number `q ≥ 2`, the set of polynomials
> `P ∈ ℂ[X]` with `P(q^k) ∈ ℤ` for every `k ∈ ℕ` is the **`ℤ`-module generated by the Gauss binomial
> polynomials**
>
> `G_0 = 1`,  `G_n(X) = (X−1)(X−q)⋯(X−q^{n−1}) / ((q−1)(q²−1)⋯(qⁿ−1)) · q^{−n(n−1)/2}`, `n ≥ 1`.
>
> **The exponent is NEGATIVE** — corrected 2026-08-13 against a 500-dpi page image; both the scan's
> text layer and a low-resolution render lose the minus sign.

## Why it is an ancestor and not a citation of our statement

| | Gramain | the programme |
|---|---|---|
| `q` | **natural number `≥ 2`** | **indeterminate** |
| coefficients | `ℂ[X]`, integrality into `ℤ` | `A_t`-lattice |
| free parameter | **none** | `t` |
| `q^{binom(n,2)}` | **divided** | **divided** — *the same, contrary to this card's first version* |
| `q^{n(n−1)}` a unit? | **no** | **yes** |

**The normalisation is not the frame difference — the ring is.** The differences that survive are
that his `q` is a fixed integer, his module is over `ℤ`, and he has no free parameter; that is why
this is an ancestor of the form rather than a drop-in citation.

## The ancestry line, as Gramain gives it

He calls the propositions *"sans doute classiques"* and proves them because they *"ne semblent pas
disponibles dans la littérature"* — **which is exactly what makes him the source of record.** He
places the entire-function statement on a geometric progression with **Gel'fond 1933**, the
*analogue multiplicatif* of **Pólya 1914**.

## Search keywords

Gramain · LNM 1415 pp.123–137 · Proposition 2.2 p.124 · progression géométrique · Gauss binomial
polynomials `G_n` · `q ≥ 2` natural number · `ℤ`-module of complex polynomials · multiplicative grid ·
Gel'fond 1933 · Pólya 1914 · sans doute classiques · volume-level numbering collision
