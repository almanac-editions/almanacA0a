# CITATION VERIFICATION CYCLE — proofv0a.tex (criterion 13, SANDBOX_STANDARD §1.13(b))

Run 2026-08-09 by hypervisorA (Overseer-ordered signature-readiness pass). Document under
verification: `informal/proofv0a.tex`, post-citation-pass edition,
sha256 `9096506dc0cdfd65c3d779274e84c382b0664a884f0872bebb259c20c294114f`
(pre-pass edition sha `1bda5137…` archived at `informal/versions/proofv0a_pre-criterion13_2026-08-09.tex`;
the citation pass added attribution only — no mathematical statement or proof step changed, so
the referee CONFIRM of `REFEREE_REPORT_PROOFv0a.md` carries).

## Step 1 — machine check (manuscript_gate G9/P9)

`python3 harness/manuscript_gate.py --kind proof …/proofv0a.tex`:
**MACHINE VERDICT: PASS (8/8)** with `% criterion-13: adopted` present, hence P9 ENFORCED, not
advisory. All six own-result environments (2 propositions, 1 theorem, 3 lemmas) carry a
citation. Clean rebuild, 0 LaTeX warnings (`proofv0a.log` beside the source).

## Step 2 — every citation resolves to a card

| manuscript site | \cite key | resolving card(s) | card status |
|---|---|---|---|
| Prop. (clause i) | HarmanHopkins | `lit-harman-q-polya-qbinomial-basis` | literature card, single-pass (see caveat C1) |
| Prop. (clause ii) | SandboxGL2 | `gl2-hc-image-theorem` | ours, theorem, FULLY CERTIFIED 2026-07-09 |
| Thm. (clause iii) | HarmanHopkins §§1,4 | `lit-harman-q-polya-qbinomial-basis` + `lit-harman-bilateral-q-integer-localization` | literature cards (C1 applies to the first; the second is the pre-existing 07-16 card) |
| Lem. grid | HarmanHopkins §1 | `lit-harman-q-polya-qbinomial-basis`; companion program card `even-newton-gaussian-grid-values` (ours, theorem) | as above |
| Lem. fwd | HarmanHopkins §1 | `lit-harman-q-polya-qbinomial-basis` | as above |
| Lem. rev | HarmanHopkins §1 | `lit-harman-q-polya-qbinomial-basis` (interpolation proof, printed pp. 3–4) | as above |
| Attribution remark (Lusztig sentence) | HarmanHopkins §4 | `lit-harman-z-variable-lusztig-cartan-form` | **literature-remark** — see caveat C2 |

The Harman–Hopkins transcript itself has been on the shelf, refereed, since 2026-07-16; the
2026-08-09 Librarian pass added the two missing statement cards and struck four stale
"on our shelf, unlinked and untranscribed" sentences from three other records (the only
instance of that stale claim shelf-wide, per the Librarian's sweep).

## Step 3 — every cited card carries its convention frame

All resolving cards carry `conventions_gap`/frame notes. The load-bearing entries:
- their q is our Q = q²; their grid is ADDITIVE (x = [n]_q), ours MULTIPLICATIVE (Y̌ = Q^n)
  via the node-preserving substitution Y̌ = 1 + (Q−1)x; their Gaussian binomial is ONE-SIDED.
- NAME COLLISION, listed first on both new cards: **their z is our Y̌** (the grid coordinate),
  NOT the free invertible parameter z of A_z. The manuscript's "their §4 z-variable" wording
  refers to their symbol; the program's z is a spectator throughout the proof.
- their square roots (K² = z, v² = q in their notation) are exactly the program's unsquared
  variables — the program frame IS the square-root cover their §4 remark constructs.
- `gl2-hc-image-theorem` carries the two-frame trap (unshifted Y̌ vs shifted Y) and the
  eF/Fe-order Casimir translation note.
- Kernel certificates recorded on the new cards: basis normalisation on the grid 49/49
  (n,k ≤ 6); 1 + (Q−1)[n]_Q = Q^n at seeds n = 0,1,2,5,7.

## Step 4 — no-predecessor judgements

NONE USED — every own-result environment carries a positive citation, so there is no
no-predecessor claim to referee. (Step 4 is vacuous on this manuscript.)

## Step 5 — what the search wanted and the Library lacked → acquisition requests

- The quantum Harish–Chandra isomorphism itself (the literature ancestor of clause (ii);
  the in-program predecessor resolves, the classical/quantum source does not):
  **filed** `corpus/requests/LR-20260809T093836Z-hypervisorA-quantum-harish-chandra-source.md`.

## Caveats, recorded so the signature reads them

- **C1.** The two 2026-08-09 cards are **single-pass, NOT refereed**, and say so in their own
  `status_note` (the 2026-08-03 audit found unaudited single-pass cards unreliable in a
  predictable way). This does NOT weaken the manuscript's own correctness — its proofs are
  self-contained, the semiformal ledger re-verifies them (gate PASS 18/18 cold, 2026-08-09),
  and the formal axis is kernel-certified independently. The cards serve ANCESTRY, and the
  ancestry claim they support (clause (iii) = bilateral quantum Pólya transported) is also
  independently pinned by the ledger's dictionary claims. A Librarian referee pass on the two
  cards is desirable hygiene, not a closure blocker; it is on the Librarian's queue.
- **C2.** The Harman–Hopkins §4 Lusztig-Cartan-form connection is **one unproved sentence of
  running text** in the source (hence the `literature-remark` grade). The manuscript already
  phrases it as "remarked there" and rests nothing on it: the transport used by the proof is
  the elementary node-preserving substitution, proved in-manuscript.
- **C3.** The T^Lus = N = T_WN = T_HH four-way reconciliation named elsewhere on the shelf
  remains OPEN (three frame differences block chaining; no normalisation fixed shelf-wide).
  This manuscript does not chain through it and does not need it; recorded here so the
  citation resolution is not read as resolving that.

**Cycle verdict: COMPLETE.** Steps 1–3 and 5 discharged; step 4 vacuous. The one open
follow-up (Librarian referee pass on the two new cards, C1) is filed on the owning seat.

## Addendum 2026-08-10 — notation migration

The Overseer-ordered Sandbox-wide notation migration (former Q,q,z → current q,v,t;
q=v², t=z²; A_z→A_t, K_z→K_t; scope: only SandboxA0a) was applied to the live editions
the same day. The citation pass above is unaffected in substance: all six environments
keep their citations, the resolution table is unchanged, and the HH dictionary
SIMPLIFIES — their printed parameter q now coincides with our q, and their adjoined
square roots are exactly our v and z. Re-runs on the migrated edition (tex sha
7110a472…): manuscript_gate --kind proof PASS 8/8 (criterion-13 enforced); ledger gate
PASS 18/18 claims / 6/6 controls / 14/14 steps against the re-pinned anchor. The 08-09
edition shas quoted above remain correct as history of that run.
