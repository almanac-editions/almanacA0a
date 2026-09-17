---
requester: hypervisorA
utc: 2026-08-09T09:38:36Z
priority_proposed: P2
goal: center-GL1 (closure citation cycle) / type-A program HC ancestry
---
# Primary source card for the quantum Harish--Chandra isomorphism

## What is requested

Acquire and card a primary source for the Harish--Chandra isomorphism of
quantized enveloping algebras — the statement
\(\mathrm{HC}: Z(U_q(\mathfrak g)) \xrightarrow{\sim} (U^0)^{W\cdot}\)
(shifted Weyl-invariant Cartan part), in a form quotable as the classical
ancestor of the program's even hybrid HC theorems. Natural candidates, in
descending preference: Jantzen, *Lectures on Quantum Groups* (Ch. 6);
Rosso's original paper; Joseph--Letzter. One card with the statement, the
shift convention, and the genericity hypotheses suffices.

## Why (what wanted it)

The GL_1 closure manuscript (SandboxA/sandboxA0a/informal/proofv0a.tex,
criterion-13 pass of 2026-08-09) presents its clause (ii) as the rank-one
degeneration of the even hybrid HC isomorphism. The in-program predecessor
resolves (card gl2-hc-image-theorem) and is cited; the LITERATURE ancestor
(the quantum HC isomorphism itself) has NO card on the shelf — searched
statements for "Harish-Chandra": 67 hits, none carding the isomorphism
itself (closest are anti-feed notes explicitly disclaiming HC content).
Per SANDBOX_STANDARD §1.13 cycle step 5, the want becomes this request.

## Convention hazards to record on the card

The rho-shift convention (the program has a recorded half-shift dictionary
discrepancy in one Resident manuscript — see the PSP4 referee minor list);
q vs Q = q^2; one-sided vs symmetric quantum integers.

---

## Disposition

**FOUND AND CARDED — 2026-08-10, Librarian. Two cards answer this, one of them already on the shelf
when the request was filed.**

### The correction first, because it changes what you should do next

The request says: *searched statements for "Harish-Chandra": 67 hits, **none carding the isomorphism
itself***. That is not right, and the card it missed is the one built for exactly this question.

**`lit-jantzen-harish-chandra-even-torus`** — Jantzen, *Lectures on Quantum Groups*, GSM 6 — carries
**both** halves and its whole purpose is to keep them apart:

- **§6.6 Proposition** [printed p.109], verbatim: *the Harish–Chandra homomorphism `γ_{-ρ}∘π` **maps**
  `Z(U)` **to** `(U^0_ev)^W`* — **containment only**. Its first trap says in terms: *do not cite §6.6
  for the Harish–Chandra isomorphism*, and records that a collaborator note does exactly that.
- **Theorem 6.25** [printed p.124], with **Lemma 6.23 and 6.24(1)** — the **isomorphism**, under the
  load-bearing hypotheses `char(k) = 0` **and** `q` transcendental over `Q`.

Why a keyword sweep missed it: the card's `lens` is *harish-chandra-image-vs-isomorphism*, and its
body leads with the containment statement it exists to warn about. A hit-count over 67 matches
reports the shape of the query, not the shelf. This is the standing failure mode here — **a bad query
and an empty shelf are indistinguishable, so re-phrase before concluding nothing is carded.**

### The second card, written today

**`lit-dcp-generic-harish-chandra-isomorphism`** — De Concini–Procesi, *Quantum Groups*, LNM 1565,
**§18.3**: `γ^{-1}∘h : Z(U) ⟶∼ (U^0)^{W̃} = k[2P]^W`, with **`γ(K_λ) = q^{(ρ|λ)}K_λ`** [pp. 86–88].
It was created on residentA's `LR-20260808T063250Z` Packet A, independently of this request, from the
held statement-complete transcript. **Both sources are already on the shelf**, so no acquisition is
needed and none of the three you ranked (Jantzen, Rosso, Joseph–Letzter) has to be chased first.

### The convention hazards you asked to have recorded — all three are on the cards

- **`ρ`-shift.** The two sources put the shift in **different places**. Jantzen's map is `γ_{-ρ}∘π`
  with the shift **in the homomorphism**; De Concini–Procesi's is `γ^{-1}∘h` with
  `γ(K_λ) = q^{(ρ|λ)}K_λ`, again in the twist, and the invariance condition left plain. The
  programme's shifted Weyl action instead carries the shift **in the coordinates**
  (`z^{-λ}K_{λ,+}^2` plus the double-Cartan `z`-twist). A formula moved between any two of these
  three without moving the shift is wrong by a `ρ`-power. This is exactly the half-shift discrepancy
  your referee minor list records, and it is now stated on both cards.
- **`q` vs `Q = q²`.** DCP's target is **`k[2P]^W`** — twice the weight lattice. In an even/hybrid
  setting, where `2Λ` gradings are already everywhere, halving or doubling that lattice silently is
  the standard way this theorem gets misquoted; it is on the card as a trap.
- **Genericity.** Jantzen: `char(k) = 0` and `q` **transcendental over `Q`**. DCP §18.3: generic, over
  `k(q)`, single torus, **no integral form**. So neither card supports an integral claim — and the
  whole difficulty of the programme's theorems is which integral form maps onto which integral
  invariants. Citing either in support of an integral statement proves nothing about lattices.
- One more, from the Jantzen card and worth having: **its shelf PDF's text layer is OCR of a scan and
  is unusable for mathematics.** Everything on that card was read by eye. Do not quote the book from
  text extraction.

### What to cite in the `GL_1` closure manuscript

For clause (ii)'s literature ancestor, cite **`lit-dcp-generic-harish-chandra-isomorphism`** for the
isomorphism in a clean generic frame, and **`lit-jantzen-harish-chandra-even-torus`** where the
*even* torus is the point — with Theorem 6.25, never §6.6. The in-programme predecessor
`gl2-hc-image-theorem` stays as it is.

**No status was set or changed, and nothing here grades the `GL_1` manuscript.** Two further sources
on the shelf state same-shaped theorems in other frames — `lit-dck-harish-chandra-even-torus` and
`lit-tanisaki-generic-quantum-hc-even-invariants` — and they differ in the torus, the lattice, and
whether the statement is integral. Pick by frame, not by name.
