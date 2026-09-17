<a href="https://github.com/almanac-editions">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="almanac-mark-dark.svg">
  <img src="almanac-mark.svg" align="right" width="110"
       alt="almanac — the word's three a's carry the three kinds of warrant: informal, computational, kernel-certified">
</picture>
</a>

# Operating instructions for an AI agent

*You are working inside a self-contained almanac: a closed mathematical record in three layers,
with a per-claim account of what warrants each one. This file tells you how to make everything in
it work, and — more importantly — what you are not permitted to conclude.*

**Read this whole file before running anything.** Section 0 binds; the rest is procedure.

---

## 0. The rules that bind before any command

**0.1 — `warrant` is a property of a ROW, never of the almanac.** `CONCORDANCE.json` records, per
result, one of `ink`, `orange`, `blue` — the three warrants, in that order. These are **not
interchangeable and never collapse into "we showed"**. Nine of eleven rows are kernel-certified.
The other two are verified over a **declared bound and over nothing else, and the bound is part of
the claim.** If you summarise this almanac in a way that loses that distinction, you have
misreported it.

**0.2 — A kernel certifies the Lean statement, and nothing else.** It does not establish that the
Lean statement faithfully renders the mathematics. A row may **not** be called kernel-certified on
the strength of a Lean proof when the claim the row makes is about the *code* rather than the
mathematics. See `EMBEDDING_NOTE.md`.

**0.3 — Never repair a discrepancy by changing a statement.** If a proof, a computation and a
manuscript disagree, that is a **finding to report**, not a defect to smooth. Weakening a statement
so that something passes is the one prohibited move.

**0.4 — Do not invent provenance.** If a field cannot be filled from the record — a model id, a
citation, a licence, a budget — leave it unfilled and say why. An unfillable field is a result. A
plausible fabricated one is a defect that survives review because it looks like an answer.

**0.5 — Distinguish "I could not check" from "it passed."** Every verification below has a
distinguishable *could-not-run* outcome. Never report a missing dependency, a skipped step or an
absent file as a pass. Where a check has an exit code, read the exit code **unpiped** — a piped
command reports the exit status of the last process in the pipe, not of your check.

**0.6 — The notation trap, and it will catch you.** The Lean sources predate a notation migration:
Lean `A_z` **is** the manuscripts' `A_t`, and Lean `Q` **is** the manuscripts' `q`. The sources
keep their original bytes deliberately — the signed goal's hash is bound into the closure record.
Every concordance row carries a `convention_frame` field. **Read it before comparing any Lean name to any
manuscript name.** Names that look equal across layers frequently are not.

---

## 1. The layout

```
almanacA0a/
  index.html              interactive reader view; fully offline and self-contained
  FOR_A_HUMAN.md          the human's guide (install instructions live there)
  FOR_AN_AI_AGENT.md      this file
  EDITION.md              front matter, prose
  CONCORDANCE.json        THE JOIN: one row per result across all three layers  <- start here
  MANIFEST.json           artifacts, hashes, gates, cost, reproducibility recipe
  DIST_MANIFEST.json      what was shipped, and whether each file matched its manifest hash
  CHECKSUMS.txt           sha256 of every shipped file
  ANCESTRY.md AUTHORSHIP.md EMBEDDING_NOTE.md   (MEASUREMENT_LOG.md is pinned but not distributed)
  almanac.html almanac.artifact.html almanac.explained.html    static reader views
  render_index.py render_almanac.py render_artifact.py          the renderers
  verify_edition.py       THE IN-TREE VERIFIER — resolves paths against the original
                          project and does NOT run standalone here. Use CHECKSUMS.txt.
  palomar/                Palomar / Mathlib-Initiative disclosure layer
  source/
    informal/             the manuscripts (.tex/.pdf), the evidence ledger, referee reports
    lean/                 the seven certified modules, flat — A READING COPY, not buildable
  replay/                 the SAME proofs plus their whole import closure, with pins and one
                          command: ./replay.sh rebuilds and prints the axioms
    instrument/           the Julia/OSCAR package, with its own test battery
    record/               closure signature, certification log, consistency record, panel
  sources-cited/          the literature cards this edition relies on
```

**Authority order when two files disagree:** `CONCORDANCE.json` (per-row warrants and frames) >
`MANIFEST.json` (artifacts, hashes, gates) > prose (`EDITION.md`, the HTML views). Prose is written
for a reader; the JSON is written for you. **Report any disagreement you find — do not silently
prefer one.**

---

## 2. Verification, in order of cost

### 2.1 Integrity — seconds, no dependencies

```sh
cd almanacA0a
shasum -a 256 -c CHECKSUMS.txt          # Linux: sha256sum -c CHECKSUMS.txt
echo "exit=$?"
```
Exit 0 = every shipped file is byte-identical to assembly.

Then read `DIST_MANIFEST.json` → `build_class` and → `integrity`.

**`build_class` is the first thing to read and the first thing to report.** A distributable is
`PUBLISHABLE` only with **zero** DRIFT rows; any DRIFT makes it a `PREVIEW`, because the zip would
otherwise freeze bytes the underlying record has not frozen. A `PREVIEW` says so on its own face —
a banner at the head of this file, of `FOR_A_HUMAN.md`, and of `index.html` — and its zip is named
`…-PREVIEW.zip`. **Never describe a PREVIEW build as the edition of record**, and never cite it as
one. The rule is ALMANAC_EDITION_MANIFEST §12.7. **Read the drift count from
`DIST_MANIFEST.json` → `integrity`, never from this file** — this page ships with every build and
cannot know which one you are holding. If any row drifts, and you are asked whether the almanac's
hashes all match, the answer is **no, these do not, and here they are**; do not report it as clean.
If none drifts, say so plainly.

### 2.2 The concordance — the check that actually matters

```sh
python3 - <<'EOF'
import json, collections
c = json.load(open("CONCORDANCE.json"))
print("rows:", len(c["rows"]))
print(collections.Counter(r["warrant"] for r in c["rows"]))
for r in c["rows"]:
    ax = r.get("axioms") or []
    clean = set(ax) == {"propext", "Classical.choice", "Quot.sound"}
    print(f'{r["id"]:26s} {r["warrant"]:28s} axioms_clean={clean}')
EOF
```
**Expected:** 11 rows; 0 `ink`, 2 `orange`, 9 `blue`; every blue-warrantified
row clean. A kernel-certified row whose axioms are **not** the clean triple is a serious finding —
report it, do not explain it away.

### 2.3 The Palomar disclosure

```sh
python3 palomar/emit_formalization.py                 # regenerate from the record
python3 -m venv .venv && .venv/bin/pip install pyyaml jsonschema
.venv/bin/python palomar/validate_formalization.py    # 0 valid · 1 invalid · 4 COULD NOT CHECK
```
**Expected today: exit 1, with exactly one error — `project/license` is empty.** No licence is
declared for this material and the generator refuses to invent one. Supplying `--license <SPDX>`
makes it validate; that has been confirmed by positive control. **Exit 4 is not a pass** — it means
the dependencies are absent and nothing was checked.

**Never regenerate this file by hand-editing it.** Every value is read from `CONCORDANCE.json` and
`MANIFEST.json`; a hand edit silently detaches the disclosure from the record it describes.

### 2.4 The instrument — minutes to tens of minutes

```sh
cd source/instrument
julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
```
**Expected: 87/87 pass.** First run installs OSCAR: slow, several GB. `Manifest.toml` is the pin
(Julia 1.12.6, OSCAR 1.8.0); `Project.toml` states only compatible ranges.

### 2.5 The Lean layer — rebuildable in `replay/`, readable in `source/lean/`

**`replay/` rebuilds.** It carries the complete transitive import closure (17 modules, 5,344 lines),
`lakefile.toml`, `lean-toolchain` and `lake-manifest.json`, and `./replay.sh` fetches the pinned
Mathlib, builds, runs `#print axioms` on all 31 certified declarations and ends PASS or FAIL. Run it
if you are checking this edition; a build that succeeds certifies nothing, the axiom lines do.

**`source/lean/` is a flat reading copy** of the seven certified modules and is not buildable — its
`import` lines resolve only inside the tree, so do not "fix" them and do not build there.

> **This paragraph used to tell you the opposite, and it was wrong.** Until 2026-09-16 it said the
> Lean layer rebuilt only in the original development and instructed you **not to report that as a
> defect of the almanac**. An independent reviewer of the public download reported it anyway, and
> was right: the edition was cited as one-command reproducible and shipped no build files. The
> instruction to suppress the finding was worse than the gap it covered, and both are fixed here.

What you can also do:

- read the declarations named in `CONCORDANCE.json`;
- compare each against `source/record/formal/RELEASE_20260721_source_all_clean.log`, the
  certification log from the run of record;
- confirm the pins in `MANIFEST.json` → `reproducibility_recipe`: `leanprover/lean4:v4.30.0`,
  Mathlib `c5ea00351c28e24afc9f0f84379aa41082b1188f`.

To re-certify from scratch you need the full development (`source/record/formal/SOURCE_MANIFEST.json`
identifies it) and, per declaration:
```lean
#print axioms <fully.qualified.name>     -- expect exactly propext, Classical.choice, Quot.sound
```

---

## 3. Regenerating the reader views

```sh
python3 render_almanac.py       # -> almanac.html
python3 render_artifact.py      # -> almanac.artifact.html
python3 render_index.py         # -> index.html   (the interactive view)
```
`render_index.py` **embeds** the concordance and manifest data directly into the HTML. That is
deliberate: a browser opening a `file://` page cannot `fetch()` a sibling JSON file, so an almanac
that loaded its data at runtime would be blank for exactly the least technical reader. If you change
`CONCORDANCE.json`, re-run the renderer or the page will silently show stale numbers.

---

## 4. What you may not claim about this almanac

- **Not peer reviewed.** No external referee has read it. Internal review was by parties
  structurally separated from the authors; that is not journal review.
- **Not registered** with Palomar, and **never describe it as "Palomar-ready"** — that phrase is
  forbidden in this project. `palomar/README.md` lists precisely which preconditions are unmet.
- **No licence is declared.** Do not assume one, and do not infer permission to redistribute.
- **`100%` anywhere means coverage, never closure**, and closure is a human signature.
- **The two `orange` rows are not theorems for all inputs.** Their bound is
  part of their claim. Quoting them without the bound misstates them.
- **Cited sources are referenced, never redistributed.** `sources-cited/` holds *this project's own
  written cards about* other people's results — with the convention frame under which they were
  read — not copies of those works.

---

## 5. If you are asked to extend or repair this almanac

1. **Change the record, then regenerate — never the reverse.** `CONCORDANCE.json` and
   `MANIFEST.json` are upstream of every rendered view and of the Palomar disclosure.
2. **Re-run the generators and the validator, and read their exit codes unpiped.**
3. **Re-assemble** (`assemble_almanac.py` in the source tree) so `CHECKSUMS.txt` and
   `DIST_MANIFEST.json` match what you shipped. A stale checksum file is worse than none: it
   reports a match that was never checked.
4. **Anything you could not fill, or could not check, is recorded with its reason** — in your
   report, and in the edition's own findings register, which lives with the record and does not
   travel in this package. A recorded shortfall is a deliverable. A smoothed-over one is the only
   outcome that damages the record.
