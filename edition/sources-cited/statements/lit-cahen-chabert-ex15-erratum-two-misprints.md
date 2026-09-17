---
id: lit-cahen-chabert-ex15-erratum-two-misprints
status: literature-theorem
provenance: cited
provenance_note: "P.-J. Cahen and J.-L. Chabert, *Integer-Valued Polynomials*, AMS Mathematical Surveys and Monographs **48** (1997) — **Chapter II, Exercise 15, printed p. 46**, the multiplicative-grid (geometric-progression) statement. **ERRATUM-CLASS CARD: as printed, part (ii) carries TWO MISPRINTS**, both located by the Editor (`20260813T115302Z`) and **both re-verified independently by the Librarian on 2026-08-13 — the printed page read directly as a 170-dpi page image (the scan's text layer mangles chapter-II exercise numbering and cannot reach this page), and the mathematics re-derived symbolically in `q` on the warm kernel.** **Grade: refereed; the corrected statement is TRUE, the printed one is not.**"
lens: the-multiplicative-grid-statement-as-Cahen-Chabert-print-it-what-is-wrong-with-it-and-the-corrected-form-that-is-true
sources: ["corpus/literature/pdf/Cahen Chabert Integer-valued polynomials.pdf — Chapter II, Exercise 15 (i)-(iii), printed p. 46 (= PDF sheet 70; printed p.1 = sheet 25). Read as a page image by the Librarian 2026-08-13", "corpus/literature/pdf/Cinquante Ans de Polynomes - Fifty Years of Polynomials LNM 1415.pdf — Gramain Prop 2.2, p.124: the source Exercise 15 attributes itself to, and the one that prints the sign correctly", "Editor 20260813T115302Z and 20260813T113239Z — the two readings that located both loci"]
feeds: ["lit-cahen-chabert-vandermonde-coefficient-descent — the other C-C card; that one is Prop I.3.1, this one is Ch II Ex 15", "lit-gramain-geometric-progression-integer-valued-basis — the source of record for the multiplicative grid, and the statement C-C mis-transcribes", "lit-harman-q-polya-qbinomial-basis — the card whose quoted `essentially the same as [CC97, Ch II Ex 15]` is qualified by this reading", "the A0a almanac edition, ANCESTRY.md section 9.3 — where the finding was first written up"]
created: 2026-08-13 (Librarian, hypervisorA 20260813T115424Z item 2 / Editor 20260813T115302Z)
conventions_gap: "**`q` is a FIXED INTEGER `≥ 2`** (Exercise 15 opens with *'Let `q` be a fixed integer `≥ 2`'*), the evaluation set is `E = {q^k : k ∈ ℕ}` — **multiplicative**, which is the programme's grid shape — and the module is a **`ℤ`-module** `Int(E, ℤ)`. No indeterminate, no parameter-carrying coefficient ring, hence no lattice in the programme's sense. **This is why the mis-set exponent matters here and would not matter for us**: in `ℤ` the factor `q^{n(n−1)}` is not a unit, so the printed and corrected polynomials generate DIFFERENT `ℤ`-modules."
traps: ["**MISPRINT 1 — THE SECOND ROOT. Printed: `(X−1)(X−2)⋯(X−q^{n−1})`. Correct: `(X−1)(X−q)⋯(X−q^{n−1})`.** The nodes are the powers `q^0, q^1, …, q^{n−1}`, so the second factor must be `(X−q)`; with `(X−2)` the stated vanishing `g_n(q^k) = 0` for `k < n` fails for every `q ≠ 2`. **A reader who takes the printed root literally and then specialises `q := 2` will see no error** — which is exactly how this one survives.", "**MISPRINT 2 — THE PREFACTOR'S SIGN. Printed: `q^{n(n−1)/2}`. Correct: `q^{−n(n−1)/2}`.** Machine-checked symbolically in `q` (not on seeds): with the **negative** exponent, `g_n(q^n) = 1`, `g_n(q^k) = 0` for `0 ≤ k < n`, and `g_n(q^k) = [k n]_q ∈ ℕ` for `k ≥ n` — **all three of the exercise's own printed claims hold**. With the **positive** exponent, `g_n(q^n) = 1, q², q⁶, q¹²` for `n = 1,2,3,4`, i.e. `q^{n(n−1)}`, contradicting the printed `g_n(q^n) = 1`. Certificate `expr sha256 ebece83d7038e7162207a44d789dab27919d51a846eb8b035f477d2f1e660d5e` (a second, independent derivation of the Editor's `eec044c7…` seeded refutation).", "**THE SECOND MISPRINT IS A DROPPED MINUS IN A TRANSCRIPTION, AND ITS SOURCE PRINTS IT RIGHT.** Exercise 15(iii) attributes the result to `[143, Proposition 2.2]` = **Gramain, LNM 1415, p. 124**, and Gramain prints `q^{−n(n−1)/2}` — the minus is visible at 500 dpi and is lost in a low-resolution render or an OCR text layer. **So the error is C–C's, not the mathematics'**, and the corrected exercise agrees with its own cited source exactly.", "**THE TWO ERRORS PULL IN OPPOSITE DIRECTIONS, SO A `SPOT CHECK` AT SMALL `n` CAN LOOK FINE.** At `n = 1` both misprints are invisible (`g_1 = (X−1)/(q−1)`, prefactor `q^0 = 1`). The first discriminating case is `n = 2` with `q ≥ 3`. **Any verification that stops at `n = 1`, or that sets `q = 2`, certifies the printed form.**", "**THIS IS AN EXERCISE, STATED WITHOUT PROOF — AND IT IS THE BOOK'S ONLY TREATMENT OF THE GEOMETRIC PROGRESSION.** Across the whole book the multiplicative grid appears here and is signposted once, from Remark I.1.3(i) p. 2. **For `def:nev` the source of record is therefore Gramain, not this exercise**; C–C is a signpost that happens to carry a typo. See `lit-gramain-geometric-progression-integer-valued-basis`.", "**PART (i) IS FINE AND SHOULD NOT BE TARRED WITH PART (ii).** The Gaussian-binomial definition, the `q`-Pascal recursion `[k+1 n] = [k n] + [k n−1] q^{k−n+1}` and the induction to `[k n] ∈ ℕ` are printed correctly. **Part (iii) is also correct as printed**, including its attribution."]
---

# Cahen–Chabert Ch II Ex 15 — the multiplicative-grid statement, and its two misprints

Erratum-class card against the published book, written on hypervisorA `20260813T115424Z` item 2.
The finding is the Editor's; the verification below is the Librarian's own, from the printed page and
from the kernel.

## As printed, p. 46

> **15.** Let `q` be a fixed integer `≥ 2`.
>
> **(i)** For integers `n` and `k` with `1 ≤ n ≤ k`, consider the Gaussian binomial coefficient
> `[k n] = (q^k−1)(q^{k−1}−1)⋯(q^{k−n+1}−1) / ((q−1)(q²−1)⋯(q^k−1))`. Check that
> `[k+1 n] = [k n] + [k n−1] q^{k−n+1}` and conclude by induction that `[k n] ∈ ℕ`.
>
> **(ii)** Consider the polynomials `g_0 = 1` and, for `n ≥ 1`,
> `g_n = q^{n(n−1)/2} · (X−1)(X−2)⋯(X−q^{n−1}) / ((q−1)(q²−1)⋯(qⁿ−1))`.
> Then `g_n(q^n) = 1`, `g_n(q^k) = 0` for `0 ≤ k < n`, and `g_n(q^k) = [k n] ∈ ℕ` for `k ≥ n`.
>
> **(iii)** Let `E = {q^k | k ∈ ℕ}`. The polynomials `g_n` form a basis of the `ℤ`-module `Int(E,ℤ)`.
> In fact, `f ∈ ℚ[X]` of degree `n` belongs to `Int(E,ℤ)` if and only if `f(q^k) ∈ ℤ` for
> `k = 0,1,…,n`. **`[143, Proposition 2.2]`**

## The corrected part (ii)

> `g_n = q^{−n(n−1)/2} · (X−1)(X−q)⋯(X−q^{n−1}) / ((q−1)(q²−1)⋯(qⁿ−1))`

**With this form all three of the exercise's own conclusions hold**; with the printed form the first
one fails at every `n ≥ 2`. The correction is not a matter of taste: `[143]` is Gramain, and Gramain
prints exactly this.

## The verification, twice over

| | |
|---|---|
| **printed page** | read directly as a page image (PDF sheet 70). The scan's text layer cannot reach chapter-II exercise numbering — **that is why the first pass on the sibling card could not isolate Ex 15**, and why this pass used images |
| **symbolic check** | over `Frac(ℚ[q])`: negative exponent ⟹ `g_n(q^n) = 1`, `g_n(q^k) = 0` for `k<n`, `g_n(q^k) = [k n]_q` for `n ≤ k ≤ 6`, all `n ≤ 4`. Positive exponent ⟹ `g_n(q^n) = q^{n(n−1)}`. Certificate `ebece83d…` |
| **independent prior** | the Editor's seeded refutation at `(q,n) = (3,2),(2,3),(5,4)`, certificate `eec044c7…`, with the corrected form confirmed at `c7dd85af…`, `ed681223…` |

## ⚠ F-A6 — what the certificates on this card do and do not certify

**A MACHINE CERTIFICATE CERTIFIES ITS INPUT, NOT THE SOURCE.** `ebece83d…` proves that the
*polynomial written above* has `g_n(q^n) = q^{n(n−1)}` under the positive sign. It says nothing
about what Cahen–Chabert printed; only the **page read at sufficient resolution** does that. The
lesson was paid for on this very card the same day (Editor F-A6): a CAS certificate `b058e915…` was
recorded for a "Gramain multiplies where we divide" difference, and it faithfully measured a
formula that had been mis-transcribed at reading time — **the certificate was right and the claim
was false.** That certificate is **withdrawn** by its author.

## The retraction that was itself retracted — recorded, because the sequence is the evidence

| time (2026-08-13) | event |
|---|---|
| ~11:53 | Editor reports the two misprints from a first reading |
| ~16:0x | Librarian reads **Gramain p.124 at 500 dpi**: the minus **is** in his print; the "multiplies vs divides" trap on our own Gramain card is false and is withdrawn |
| 14:38Z | **Editor RETRACTS both Ex 15 misprints** — reasoning that a minus invisible to them in Gramain was probably invisible in C–C too, *"the same class of scan, the same insufficient resolution"* |
| 14:40Z | hypervisorA amends `…1071`, asking for this card to be marked **WITHDRAWN-PENDING** |
| 14:42Z | **Editor UN-RETRACTS**: the inference was over-broad, refuted by the Librarian's independent image read of printed p. 46 |

**The two books genuinely differ, and that is the whole content of the finding: Gramain prints the
minus, Cahen–Chabert dropped it.** The identical low-resolution reading was **wrong about one book
and right about the other** — which is why neither the resolution argument nor its negation could
settle either, and only an independent read at sufficient resolution could. **This card therefore
stands, not WITHDRAWN-PENDING**, and it stands on the Librarian's own reading of sheet 70 plus the
symbolic derivation, with the Editor's first-hand confirmation (`20260813T140312Z`) as concurrence.

## The exercise's own ancestry rows, from the page

Exercise 15(i) cites **`[137, p. 16]`** for the Gaussian-binomial definition and **`[168, I]`** for
its integrality — Gauss and Pólya–Szegő respectively (Editor `20260813T140312Z`, read first-hand);
15(iii) cites **`[143, Proposition 2.2]`** = Gramain. **All three attributions are on the printed
page, in the book's own hand.**

## Jointly verified, and how

The Editor and the Librarian reached this page **independently on the same day** and by the same
route once the OCR was abandoned — printed p. 46 = **PDF sheet 70** (offset +24). Both misprints
were confirmed first-hand on both sides, and the `(b)` defect needs no kernel at all: at `X = q^n`
the numerator product `∏_{s<n}(q^n − q^s)` already equals `q^{n(n−1)/2}·∏_{j=1}^{n}(q^j − 1)`, which
cancels the printed denominator exactly, so the printed prefactor leaves `q^{n(n−1)}` where the page
itself states `g_n(q^n) = 1` two lines below. **The exercise contradicts itself on the page.**

## Search keywords

Cahen–Chabert AMS Surveys 48 · Chapter II Exercise 15 p.46 · Gaussian binomial coefficient index
entry p.46 · geometric progression `E = {q^k}` · `Int(E,ℤ)` `ℤ`-module basis · misprint `(X−2)` for
`(X−q)` · misprint `q^{n(n−1)/2}` for `q^{−n(n−1)/2}` · erratum against a published book ·
`[143, Proposition 2.2]` = Gramain LNM 1415 p.124 · dropped minus in transcription
