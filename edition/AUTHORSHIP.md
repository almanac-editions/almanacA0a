<a href="https://github.com/almanac-editions">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="almanac-mark-dark.svg">
  <img src="almanac-mark.svg" align="right" width="110"
       alt="almanac — the word's three a's carry the three kinds of warrant: informal, computational, kernel-certified">
</picture>
</a>

# Authorship

*almanacA0a — the centre of the even hybrid family quantum GL₁.*
Form fixed by the edition manifest §8; scheme settled 2026-08-05.

## Author

**Tamás Hausel** — who directed this sandbox throughout its life.

The scheme is deliberate on this point: authorship follows *direction over the whole life of the
work*. The goal statement was fixed and signed before any proving budget
was spent, every approval gate was a human act, and the closure signature is a human act; the
assembly and checking between those acts was done by machine.

## Released by

Every push of this edition to its public repositories was performed by Tamás Hausel from his own
account; the editing seat assembles and never releases. The commits of the published history carry
his identity, and responsibility for everything the edition contains is his.

## Issued by

**Project Sandbox.**

## General editor

This edition was assembled by the Almanac Editor. For the series as designed, the Almanac Editor is
a funded human post serving as general editor across editions. **For this pilot edition the post was
discharged by a software agent**, and the edition says so on its face. What that cost, and what a
human would have had to do instead, is measured in `MEASUREMENT_LOG.md` (held in the record, not distributed; the figures are in `MANIFEST.json`).

## Contributors

The work was produced by software agents operating under the Project Sandbox Rule — a written
operating standard that fixes the statement before the proof, requires a computer-algebra oracle to
confirm a statement (including against adversarial inputs) before proving effort is spent, and
accepts a result as certified only on the verdict of a proof kernel. Agents hold defined roles with
single-writer boundaries; no agent approves its own work, and the seat that produces an edition is
never the seat that accepts it.

Contributing roles for this edition: the type-A programme hypervisor (record owner and accepting
counterparty), the sandbox Resident (mathematics), the Librarian (literature and cards), the
Architect (the form this edition is built to), and the Almanac Editor (assembly and measurement).

## The certifier

Formal results are certified by the **Lean 4 proof kernel** (toolchain `leanprover/lean4:v4.30.0`,
Mathlib revision `c5ea00351c28e24afc9f0f84379aa41082b1188f`). A result counts as kernel-certified
only when its axiom base is exactly the three standard axioms of Lean's kernel — propositional extensionality (`propext`), the axiom of choice (`Classical.choice`) and quotient soundness (`Quot.sound`) — the base every Mathlib proof shares; a certificate is clean when these three are all it needs — with no
`sorryAx` and no custom axiom. **Per-result warrants are in `CONCORDANCE.json` and they are not
uniform**: the certifier certifies the Lean statement and nothing else. What the computational
layer does and does not establish is in `EMBEDDING_NOTE.md`, and it is not a certificate.

## Sources

Cited literature appears per result in the concordance's `ancestry` field and in `ANCESTRY.md`.
Cards — this project's own written statements *about* other people's results, carrying the
convention frame under which they are read — travel inside the edition. **Sources themselves are
referenced and never redistributed.**

---

*A reader of this edition meets the people and the institution; role names used in the estate's
own internal governance stay within the estate. The one internal-facing exception is the
contributor list above, which names roles rather than seats because a reader is entitled to know
which functions were machine-held.*
