# The replay, run once from a fresh tree — the run of record

**2026-09-16, on a Linux host (Lean `leanprover/lean4:v4.30.0`).** `./replay.sh` was run on a
tree containing exactly the bytes shipped here, unpacked into an empty directory with no `.lake`,
no cached build and nothing inherited from the project the sources came from.

| | |
|---|---|
| declarations checked | **31** |
| `sorryAx` | **0** |
| axioms outside `[propext, Classical.choice, Quot.sound]` | **0** |
| verdict | **PASS** (exit 0) |
| transcript | `replay_axioms.txt`, sha256 `9bddfbfdf10b6ade265eda7a93ec8db5024834606a84f42f6e408930ebe6934b` |

**This file exists because an untested command is worse than no command.** It was run because a
reviewer of the public download found that the edition claimed a one-command rebuild and shipped no
build files — and the running is what found the defects, not the writing:

1. **The first run built nothing and said so as a success.** `lake build` with no
   `defaultTargets` prints *"Build completed successfully (0 jobs)"* and exits 0. The gap only
   surfaced one step later, as `unknown module prefix 'Sandbox'`. `replay.sh` now asserts that
   the object files exist, because a success line is not a build.
2. **The second run compiled 1,478 targets and failed on two missing object files.** Lake writes an
   object file only for a module that is a *target*; modules that are merely *imported* are
   elaborated and never written. Every module in the closure is now a root.
3. **The third run printed FAIL over a transcript in which all 31 declarations were clean** — Lean
   wraps a long axiom list across lines, and a line-at-a-time check called five of them dirty. The
   verdict now joins each record to its closing bracket before deciding. **That was the dangerous
   one**: it would have told a reader the certification was broken.

None of the three was visible by reading the script. Each needed the run.

**What the replay does not prove.** It rebuilds these proofs against the pinned Mathlib and reports
the axioms; it does not re-derive Mathlib, and `lake exe cache get` fetches prebuilt objects over
the network. On this host that fetch found a warm local cache, so the cold download path is the one
part of the first-run experience these runs did not exercise.
