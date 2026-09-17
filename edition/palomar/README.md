<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../almanac-mark-dark.svg">
  <img src="../almanac-mark.svg" align="right" width="110"
       alt="almanac — the word's three a's carry the three kinds of warrant: informal, computational, kernel-certified">
</picture>

# The Palomar layer

**What this directory is for:** it makes the Lean part of this almanac *registrable* — and, more
importantly, **checkable by a human who trusts neither the authors nor the machines.**

That is the same thing the almanac is for, which is why adopting it was easy. The Lean FRO's
`comparator` and the Mathlib Initiative's `formalization.yaml` exist to shrink the surface a person
must read before trusting a machine-produced proof. This edition's concordance exists to do that
across three layers at once. They are the same instinct at different scopes.

> **Palomar is the floor; the almanac is the edition.** An almanac meets the community's emerging
> minimum standard for a single theorem and then publishes the four layers above it that the
> standard does not reach — the instrument, the evidence, the conventions, and the routes that
> failed. Registering the Lean part does not diminish the edition. It makes the floor it stands on
> checkable by a stranger.

## Files

| file | what it is |
|---|---|
| `formalization.yaml` | the disclosure file, Mathlib Initiative **schema v0.4**. GENERATED — do not hand-edit. |
| `emit_formalization.py` | the generator. Dependency-free; runs on a stock `python3`. |
| `validate_formalization.py` | validates the above against the local schema copy, offline. |
| `schema/` | local copies of the published schema (`v0.3`, `v0.4`, dispatcher), so validation needs no network. |

```sh
python3 palomar/emit_formalization.py              # regenerate
python3 palomar/emit_formalization.py --license MIT  # regenerate with a licence declared
# validation needs two packages a stock python3 lacks:
python3 -m venv .venv && .venv/bin/pip install pyyaml jsonschema
.venv/bin/python palomar/validate_formalization.py   # 0 valid · 1 invalid · 4 could not check
```

## The state of it, measured

**The document is schema-valid in every respect but one, and the one is a decision nobody in this
directory is allowed to make.**

```
INVALID — 1 error(s):
  at project/license: '' should be non-empty
```

`project.license` is **required** by the schema. **No licence is declared anywhere in this
project.** Choosing one is an outward-facing act and belongs to the project's director alone, so
the generator refuses to invent one to make a required field look satisfied. Re-run with
`--license <SPDX-ID>` and it validates — verified by positive control, which is the only reason
this README can claim the licence is the *only* gap.

## Two things this layer got wrong first, kept because the corrections are the useful part

**1. It was built as nine per-result files. `formalization.yaml` is a REPO-ROOT file — one per
project.** Multiple results belong in `status.main_results[]`, which is where this edition's nine
kernel-certified declarations now sit, each with its own measured axiom set. The nine files were
deleted.

**2. It listed the second kernel as BLOCKING for submission. That was wrong, and it understated
what we can claim.** The `nanoda` replay runs on **Palomar's** side, not ours. A submitter does not
need to own a second kernel. Adopting one strengthens *our own* certification and is worth doing on
its own merits — but it is not a precondition for registering anything.

Both errors came from working off a careful prose summary of a schema **nobody had read**. The
first version of this layer said so on its face, in a `schema_conformance` field, and reading the
actual schema then falsified it. *That is the caveat doing its job rather than failing to prevent
the error — an unverified claim that announces itself is recoverable; one that reads as settled is
not.*

## What is NOT built: the Challenge/Solution split

`comparator` needs a pair, and this edition has neither half. The contract, stated precisely:

- **`Challenge.lean`** — imports, then the theorem with its proof left as `sorry`. **This is the
  part a human checks.** It should be as short as it can be, because everything in it is surface a
  person has to read and agree with.
- **`Solution.lean`** — the same statement, actually proved.
- **`config.json`** — `challenge_module`, `solution_module`, `theorem_names`, `permitted_axioms`,
  and optionally `external_kernels` and `definition_names`. *(Not `comparator.json`; an earlier
  note in this project used that name.)*
- Run as `lake env <comparator-binary> <config.json>`. If the human is satisfied the theorem in
  `Challenge.lean` is the one they care about, comparator establishes that the solution proves
  **that** statement and did not quietly weaken it.

`permitted_axioms` is `["propext", "Quot.sound", "Classical.choice"]` — **the rule this project has
enforced since before Palomar existed.** The hardest gate to retrofit is the one we already pass.

**The real question, and it belongs to the owner of the formal record, not here.** Our statement is
about *our own* definitions, not Mathlib's. Comparator's own constraint is that the transitive
import closure of `Challenge.lean` be "controlled by you or trustworthy" — so our definitions may
live in imported files. But the *spirit* is a small human-checkable surface, and every definition a
reader must accept is part of that surface whether it is inlined or imported. **So the question is
not "does it compile" but "how much must a stranger read before the statement means what we say it
means" — and for this programme that includes the convention frame, which is exactly what
`CONCORDANCE.json` was built to carry.** Whether the signed statement can be presented compactly
**without weakening** is a finding to establish, not an assumption.

## Publishability, stated so it can be checked rather than asserted

**The Lean part of every published almanac is a candidate Palomar entry.** Preconditions, with
owners:

| precondition | owner | kind |
|---|---|---|
| a public repository | the director | a decision |
| a declared licence | the director | a decision |
| a `Challenge`/`Solution` split + `config.json` | the owner of the formal record | engineering, not research |
| their research-interest floor and fidelity check | Palomar | their judgement, not ours |

## The hard limits

- **Never write "Palomar-ready."** Nothing here is registered with Palomar or submitted to it.
- Registration is **not** publication, peer review, or a certificate of novelty or importance —
  Palomar says so itself, and those disclaimers travel with any citation of an entry.
- **No language-model fidelity score appears in this layer.** Palomar's own fidelity check is an
  LLM and non-deterministic by their account — the same commit scored 5 then 4. It is not a
  warrant and is never quoted as one. We keep the idea of a stated formal-to-informal fidelity
  claim and keep a human-refereeable informal proof beside the formal one, which is stronger.
- An almanac deliberately publishes **failed routes and negative results**; a registry's
  research-interest floor would exclude exactly those. That is a difference in purpose, not a
  defect in either artifact.
