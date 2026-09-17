# replay/ — rebuild every certified proof, and see the axioms it used

    ./replay.sh

One command: it fetches the pinned Mathlib, builds, runs `#print axioms` on all 31
certified declarations, writes `replay_axioms.txt`, and ends **PASS** or **FAIL**. A build that
succeeds certifies nothing; the axiom lines do. Needs `elan` and, on first run, the network for
Mathlib's prebuilt objects (several GB); later runs take seconds.

## What is in here, and why `Sandbox/A1/`

**The directory names are the module names, and the module names are the certified code's own.**
Lean requires `Sandbox/A1/GL1/GOALv0a.lean` to sit at exactly that path to be the module
`Sandbox.A1.GL1.GOALv0a`; renaming the folder would change the certified sources' `import` lines
and namespaces, that is, the bytes the kernel checked.

- **`Sandbox/A1/GL1/`** — the seven modules this edition certifies, the GL₁ development. `A1` is
  the programme's rank-one Lean library, inside which the GL₁ case was built; `GL1` is the case.
  These are the same bytes as `../source/lean/`, which is a flat copy for reading.
- **`Sandbox/A1/*.lean`** — ten modules of the rank-one development that the seven **import**
  (Laurent polynomials, the q-arithmetic, the Verma module, the centre lattice). They are here for
  one reason: without them the build does not close. They are shipped as dependencies, the way
  Mathlib is fetched, not as results of this edition; nothing in this almanac certifies them, and
  the language count of the repository leaves this whole folder out.
- **`lakefile.toml`, `lean-toolchain`, `lake-manifest.json`** — the pins: Lean
  `leanprover/lean4:v4.30.0`, Mathlib `v4.30.0` at commit `c5ea00351c28e24afc9f0f84379aa41082b1188f`, and every other
  package by commit.
- **`Verify.lean`** — generated from the edition's concordance, one `#print axioms` per certified
  declaration, so what is checked cannot drift from what is claimed.
- **`SOURCES.json`** — every module with the sha256 of the record file it was copied from.
- **`run-of-record/`** — the transcript of this tree run once from the published archive, and the
  three defects that run found in the tree's first versions.
