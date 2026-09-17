<a href="https://github.com/almanac-editions">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="almanac-mark-dark.svg">
  <img src="almanac-mark.svg" align="right" width="110"
       alt="almanac — the word's three a's carry the three kinds of warrant: informal, computational, kernel-certified">
</picture>
</a>

# Using this almanac by hand

*This is a complete record of one small mathematical result: the informal proof a
mathematician would read, a computer program that computes with the objects, and a machine-checked
formal proof — together with a per-claim account of **what actually warrants each one**.*

**If you only want to look, open `index.html` in any browser.** It is fully self-contained, works
offline, and is the right starting point. This file is for when you want to *check* things
yourself.

---

## Part 0 — What to read first, in order

| # | file | why |
|---|---|---|
| 1 | **`index.html`** | the guided tour. Opens directly in any browser, ready to use. |
| 2 | **`EDITION.md`** | the edition's own front matter, in prose. |
| 3 | **`source/informal/proofv0a.pdf`** | the actual mathematics, typeset. |
| 4 | **`CONCORDANCE.json`** | the heart of it: one row per result, joining all three layers. |

**The single most important idea in this almanac:** the concordance's `warrant` field. It records,
per result, what certifies it — and the values are **not interchangeable**:

- <picture><source media="(prefers-color-scheme: dark)" srcset="w-ink-dark.svg"><img src="w-ink.svg" alt="ink" width="35" height="20" align="top"></picture> — an argument written out for a human reader and **refereed**, pinned to a hashed
  document at a named location. A warrant in its own right, not the absence of one: it is what the
  other two are checked against. None of eleven results, in this edition.
- <picture><source media="(prefers-color-scheme: dark)" srcset="w-orange-dark.svg"><img src="w-orange.svg" alt="orange" width="61" height="20" align="top"></picture> — verified by computation over a stated bound, **and over nothing else**. The bound
  is part of the claim. Two of eleven results.
- <picture><source media="(prefers-color-scheme: dark)" srcset="w-blue-dark.svg"><img src="w-blue.svg" alt="blue" width="44" height="20" align="top"></picture> — a proof assistant's kernel checked a proof of *that statement*, and the axioms it
  used were measured to be exactly the three standard ones. Nine of eleven results.

A green result of one kind is never quietly upgraded into another. That discipline is the point of
the edition.

---

## Part 1 — Checking the files are intact (5 minutes, with tools already on your machine)

Every file's fingerprint is listed in `CHECKSUMS.txt`.

**macOS:**
```sh
cd almanacA0a
shasum -a 256 -c CHECKSUMS.txt
```
**Linux:**
```sh
cd almanacA0a
sha256sum -c CHECKSUMS.txt
```
**Windows (PowerShell):**
```powershell
cd almanacA0a
Get-Content CHECKSUMS.txt | Where-Object { $_ -notmatch '^#' } | ForEach-Object {
  $h,$f = $_ -split '\s+',2
  if ((Get-FileHash $f -Algorithm SHA256).Hash -ieq $h) { "OK   $f" } else { "FAIL $f" }
}
```

Every line should say `OK`. If a line fails, the file has been altered since assembly — the
almanac is still readable, but stop trusting that file until you know why.

> `DIST_MANIFEST.json` additionally records, per file, whether its bytes matched the edition's own
> manifest **at assembly time**, and its `build_class` says whether every file matched.
> **Read that there rather than here.** This page is written once and travels with every build, so
> it cannot know which one you are holding; a number printed here would be true of at most one of
> them. A build with any mismatch says so on its own front page, and one with none says nothing,
> because there is nothing to say.

---

## Part 2 — Installing the software

You need three things, and **you only need the ones you actually want to use**. The checks are
independent: Lean alone suffices for the formal proofs, and Julia alone for the computations.

### 2.1 Python 3 — for the almanac's own scripts (almost certainly already installed)

```sh
python3 --version        # anything 3.8+ is fine
```
- **macOS:** ships with it; or `brew install python`
- **Linux:** `sudo apt install python3` (Debian/Ubuntu) / `sudo dnf install python3` (Fedora)
- **Windows:** install from <https://www.python.org/downloads/> and tick *"Add python.exe to PATH"*

Optional, only for validating the Palomar disclosure file against its published schema:
```sh
python3 -m venv .venv
.venv/bin/pip install pyyaml jsonschema        # Windows: .venv\Scripts\pip install ...
```

### 2.2 Lean 4 — to re-check the formal proofs yourself

Lean is installed through **`elan`**, a version manager. Never install a Lean version directly:
this almanac is pinned to an exact toolchain, and `elan` is what makes the pin work.

**macOS / Linux:**
```sh
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
# then restart your shell, or:
source $HOME/.elan/env
elan --version
```

**Windows (PowerShell):**
```powershell
curl.exe -sSf -o elan-init.ps1 https://raw.githubusercontent.com/leanprover/elan/master/elan-init.ps1
powershell -ExecutionPolicy Bypass -f elan-init.ps1
```

**The exact pins this almanac was certified against:**

| | |
|---|---|
| Lean toolchain | `leanprover/lean4:v4.30.0` |
| Mathlib revision | `c5ea00351c28e24afc9f0f84379aa41082b1188f` |

```sh
elan toolchain install leanprover/lean4:v4.30.0
```

**Be warned about size and time.** A Mathlib-dependent Lean project downloads several gigabytes of
prebuilt artifacts, and building from source instead can take **hours**. Always fetch the cache
first (`lake exe cache get`) rather than compiling Mathlib yourself.

**One command rebuilds every proof and prints the axioms each one used:**

```sh
cd almanacA0a/edition/replay
./replay.sh
```

It fetches the pinned Mathlib, builds the proofs, runs `#print axioms` on all 31 certified
declarations, writes the transcript to `replay_axioms.txt`, and ends in `PASS` or `FAIL`. **A build
that succeeds is not a proof that anything is certified** — the axiom lines are, which is why the
script fails on any `sorryAx` or any axiom outside `[propext, Classical.choice, Quot.sound]` even
when the build is clean.

`replay/` carries the **complete transitive closure** — 17 modules, 5,344 lines, including the
rank-1 modules the seven certified ones import — together with `lakefile.toml`, `lean-toolchain`
and `lake-manifest.json`, so every revision is pinned and nothing is fetched from this project.
`replay/SOURCES.json` lists each module with the sha256 of the record file it was copied from.

> **`source/lean/` is the reading copy** — the same seven certified modules, flat and without
> directories, for opening one at a time. It is not buildable and is not meant to be: use
> `replay/` to rebuild, `source/lean/` to read.
> `source/record/formal/RELEASE_20260721_source_all_clean.log` is the certification log from the
> original run of record, for comparison against what your own replay prints.

### 2.3 Julia + OSCAR — to run the computational instrument

**Install Julia** via `juliaup`:

**macOS / Linux:**
```sh
curl -fsSL https://install.julialang.org | sh
# restart your shell, then:
julia --version
```
**Windows:**
```powershell
winget install julia -s msstore
```

**The pins:**

| | pinned | minimum |
|---|---|---|
| Julia | 1.12.6 | 1.10 |
| OSCAR | 1.8.0 | 1.7 |

**Run the instrument's own test battery** (this is the honest check — the outcome is a plain
pass or fail):
```sh
cd almanacA0a/edition/source/instrument
julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
```
Expected: **87 of 87 tests pass.** The first run installs OSCAR and its dependencies and is slow —
budget **20–40 minutes and several GB**. Later runs take seconds.

> `Manifest.toml` is the real pin — it records exact resolved versions. `Project.toml` only states
> compatible ranges. If you want the exact environment that was certified, keep `Manifest.toml`.

---

## Part 3 — Checking the mathematics yourself

### 3.1 Read the statement, then decide whether it is the statement you care about

This is the step no software can do for you, and it is the one that matters most. Open
`source/informal/goalv0a.pdf` — the signed goal — and `source/informal/proofv0a.pdf` — the proof.

**A crucial warning about notation.** The Lean files were written before a notation change and use
**older symbols** than the manuscripts:

| in the Lean sources | means, in the manuscripts |
|---|---|
| `A_z` | `A_t` |
| `Q` | `q` |

The sources keep their original bytes **deliberately**, because the signed goal's fingerprint is
part of the closure record and survives only while every byte stays put. To bridge the notations,
every concordance row carries the **convention frame** telling you how to read it. If you skip
that field you will misread the Lean.

### 3.2 Check the axioms of a formal result

Each certified row in `CONCORDANCE.json` names a Lean declaration and records the axioms measured
for it. Inside a working copy of the full Lean development:

```lean
#print axioms HybridQuantumLean.A1.GL1Newton.clause_i
```

**What you should see:** exactly `[propext, Classical.choice, Quot.sound]` — the three standard axioms of Lean's kernel — propositional extensionality (`propext`), the axiom of choice (`Classical.choice`) and quotient soundness (`Quot.sound`) — the base every Mathlib proof shares; a certificate is clean when these three are all it needs.

**What must never appear:** `sorryAx` (an admitted gap) or `Lean.ofReduceBool` (a proof by
compiled evaluation). Either one means the result is *not* certified, whatever else is green.

### 3.3 Understand exactly what a certificate covers

**A kernel certifies the Lean statement, and nothing else.** It does not tell you the Lean
statement faithfully expresses the mathematics — that is a human judgement, and it is precisely
what the concordance and the convention frames are there to let you make. `EMBEDDING_NOTE.md` sets
out what the computational layer does and does not establish; it is deliberately **not** a
certificate.

---

## Part 4 — If something goes wrong

| symptom | what it means |
|---|---|
| `shasum: CHECKSUMS.txt: no such file` | you are not in the `almanacA0a` directory |
| a `FAIL` line from the checksum check | that file changed after assembly — investigate before trusting it |
| `lake: command not found` | `elan` is installed but your shell was not restarted |
| Julia test run takes forever the first time | expected — OSCAR is large. Subsequent runs are fast. |
| a Lean `import` cannot be found | you are building in `source/lean/`, which is the flat reading copy — rebuild in `replay/` instead (see 2.2) |
| `replay.sh` fails at `lake exe cache get` | a network problem, and do not let the build continue past it: without the cache, Mathlib compiles from source and takes hours |
| `verify_edition.py` errors on missing paths | expected: it is the *in-tree* verifier and resolves paths against the original project. Inside the almanac use `CHECKSUMS.txt` instead. |
| the browser shows a blank `index.html` | your browser is blocking local files; try a different browser, or `python3 -m http.server` in this directory and visit `localhost:8000` |
