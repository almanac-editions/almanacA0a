# CAS-oracle cross-check receipts — proofv0a.ledger.json (2026-08-05)

Warm kernel 127.0.0.1:9917 (HybridQuantum+Oscar), via the CAS MCP (casmcp/0.1); refute-first
semantics. Every scalar-arithmetic claim family of the ledger was mirrored on the oracle
independently of Backend A before the battery ran. Certificates (sha256 of the checked
expression, kernel UTC timestamps 2026-08-05T21:44-45Z):

| Ledger claims covered | Oracle check | Certificate sha256 | Verdict |
|---|---|---|---|
| G2 (Gaussian reindexing, Lemma 1(b)) | identity, 4 seeds incl. edge m=r=8 | `0ad2cad23cc5…422c` | CONFIRMED 4/4 |
| G3 (reflection, Lemma 1(c)) | identity, 4 seeds incl. (n,r)=(3,2),(1,5) | `71630bfdc109…2ac3` | CONFIRMED 4/4 |
| G1 + R1-diag + H2 + F2 (vanishing / diagonal / node transport / shift) | batch eval | `eff32217424b…a6c3` | OK (true,true,true,true) |
| control.reflection-exponent-drop, control.offdiagonal-not-one, control.hh-sign-mutation | batch eval, mutations | `c329dd5b2491…31f1` | OK (false,false,false) — all refute |
| control.odd-grid-mutation (denominator obstruction) + L1 (clearing witness, corrected mirror) | batch eval | `0ac9f415395b…26ee` | OK (5-term denominator ⇒ non-integral; witness true) |

Not oracle-mirrored (Backend A only, by instrument scope): R2 (matrix inverse integrality —
needs the membership tester), A1 (product closure — same), H1 (free-variable rational identity
— kernel has no free x), control.pascal-shift-mutation and control.coefficientwise-coarsening
(need ZZ[X]-construction / coefficient extraction). These ran only in the ledger battery.

Incident log (honesty): one earlier batch (`3864c84b…860d`) errored on an empty product at
r=0 (Julia typing, not mathematics; range restricted to r≥1 in the re-run), and my first
ad-hoc mirror of the L1 witness carried a transcription slip (`2*(3+i)` for `2*(n-1+i)`) that
returned false against the CORRECT ledger claim — caught and corrected in `0ac9f415…`; the
certified identity `71630bfd…` had already confirmed the true formula at the same (n,r).
