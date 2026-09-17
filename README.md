<a href="https://github.com/almanac-editions">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="edition/almanac-mark-dark.svg">
  <img src="edition/almanac-mark.svg" align="right" width="110"
       alt="almanac — the word's three a's carry the three kinds of warrant: informal, computational, kernel-certified">
</picture>
</a>

# almanacA0a — the centre of the even hybrid family quantum GL(1)

**Tamás Hausel** · Institute of Science and Technology Austria

*The pilot edition. A complete record of one small mathematical result, in three layers, with a
per-claim account of what warrants each one.*

**Start here: [open the almanac](https://almanac-editions.github.io/almanacA0a/edition/index.html)** —
or unzip the archive below and open `edition/index.html`, which needs no network at all.

**Whole almanac:
[Download `almanacA0a.zip`](https://github.com/almanac-editions/almanacA0a/raw/main/almanacA0a.zip)** — it unzips to exactly this folder.

---

## What is in here

This is a publication, not a codebase: the file list above is a table of contents, and GitHub's
right-hand column shows the last commit that touched each item rather than what the item is. What
they are:

| | |
|---|---|
| **`edition/`** | the almanac itself — the paper, the proof, the formal sources, the concordance, the pages that read them, and the checksums that certify them |
| **`almanacA0a.zip`** | the whole thing as one download; it unzips to exactly this folder |
| **`README.md`** | this page |
| **`index.html`** | a signpost: opens `edition/index.html`, so the archive's own address works |
| **`AGENTS.md`** | where an AI assistant should start |
| **`CITATION.cff`** | how to cite the edition |
| **`LICENSE`** | MIT, for everything that runs |
| **`LICENSE-CC-BY-4.0`** | CC BY 4.0, for the text, the mathematics and the data |

Inside `edition/`, the three files a reader is most likely to want are **`paper.pdf`** (the
mathematics), **`index.html`** (the almanac, offline) and **`CHECKSUMS.txt`** (proof that every
file is the one that was certified).

## What an almanac is

An almanac is its own kind of publication — a **citable, versioned package a reader downloads**:
the informal proof a mathematician would read, the computational instrument the calculations
actually ran on, and the machine-checked formal development — held together by one file,
`edition/CONCORDANCE.json`, that joins all three layers claim by claim and records **what certifies each
one**.

The concordance — joining the three layers claim by claim — is what turns three parallel
archives into a single edition.

## What each warrant means

Every result carries exactly one warrant — **three different kinds of check**.

| warrant | what it means | how many |
|---|---|---|
| <picture><source media="(prefers-color-scheme: dark)" srcset="edition/w-ink-dark.svg"><img src="edition/w-ink.svg" alt="ink" width="35" height="20" align="top"></picture> | an argument written for a human reader and **refereed** | 1 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="edition/w-orange-dark.svg"><img src="edition/w-orange.svg" alt="orange" width="61" height="20" align="top"></picture> | verified by computation over a **stated bound, which is part of the claim** | **2** |
| <picture><source media="(prefers-color-scheme: dark)" srcset="edition/w-blue-dark.svg"><img src="edition/w-blue.svg" alt="blue" width="44" height="20" align="top"></picture> | a proof kernel checked a proof of *that statement* | **9** |

A kernel certifies **the formal statement**. Whether that statement is faithful to the informal one
can be decided from the warrants above and the convention frame carried on every row.

## Where to go

| to… | read |
|---|---|
| read the mathematics | **[the paper](edition/paper.pdf)**, 8 pp., `edition/paper.pdf` |
| read it at length, without LaTeX | **[the mathematics explained](https://almanac-editions.github.io/almanacA0a/edition/almanac.explained.html)** — for a general reader, `edition/almanac.explained.html` |
| look around | **[the almanac itself](https://almanac-editions.github.io/almanacA0a/edition/index.html)** — interactive, and offline in `edition/index.html` |
| see every statement and its warrant | **[the twelve statements](https://almanac-editions.github.io/almanacA0a/edition/statements.html)** — `edition/statements.html` |
| check any of it independently | **[how to check it yourself](https://almanac-editions.github.io/almanacA0a/edition/FOR_A_HUMAN.html)** — including installing every piece of software from scratch, `edition/FOR_A_HUMAN.md` |
| hand it to an AI assistant | **[`AGENTS.md`](AGENTS.md)** at the root — it routes to `edition/FOR_AN_AI_AGENT.md` |
| **rebuild the proofs yourself** | **[`edition/replay/`](edition/replay/)** — `cd edition/replay && ./replay.sh` rebuilds every certified proof from pinned sources and prints the axioms each one used |
| confirm every file is intact | **[`edition/CHECKSUMS.txt`](edition/CHECKSUMS.txt)** — `cd edition && shasum -a 256 -c CHECKSUMS.txt` |

*Links to pages open the published site; links to files open them here. **Both work offline**: the
same paths exist in the archive, which is why every one of them is written out beside its link.*

## Cite

Tamás Hausel, *almanacA0a — the centre of the even hybrid family quantum GL(1)*, pilot edition of the almanac series, version 0.1.0, 2026. DOI [10.5281/zenodo.22808195](https://doi.org/10.5281/zenodo.22808195) — the deposited edition of record in the EU Open Research Repository; this repository publishes the same bytes.

## Licence

**MIT for everything that runs; CC BY 4.0 for everything written to be read.** Copyright &copy; 2026
Tamás Hausel and the Institute of Science and Technology Austria (ISTA).

| what | licence | file |
|---|---|---|
| the renderers, the verifier, the Lean sources | **MIT** | [`LICENSE`](LICENSE) |
| the paper, the proofs, the guides, the concordance, the statement cards | **CC BY 4.0** | [`LICENSE-CC-BY-4.0`](LICENSE-CC-BY-4.0) |

The split is stated file-by-file in the second file and is meant to be applied mechanically.
**GitHub's sidebar will say &ldquo;MIT&rdquo;** — that is the licence a detector can read from
`LICENSE`, and it is the one that governs the code. **The mathematics is CC BY 4.0**, which asks
only that you credit it.

**A licence is not a warrant.** This says what you may *do* with the material, and nothing about
what is proved or how well — that is the concordance's job, and every claim carries its own warrant.

## Reproducing it

The toolchain is pinned **to exact versions** — a proof that compiles today compiles against
*that* specific Mathlib revision:

- Lean `leanprover/lean4:v4.30.0`
- Mathlib `c5ea00351c28e24afc9f0f84379aa41082b1188f`
- Julia 1.12.6, OSCAR 1.8.0 (`Manifest.toml` is the pin; `Project.toml` states only ranges)

Everything runs entirely on a local machine, **self-contained and service-free.**
A pinned toolchain makes a re-run *possible*, not *identical* — `edition/MANIFEST.json` →
`reproducibility_recipe` says exactly what the pin does and does not promise.

## Citing it

**Citable identifiers arrive only with the frozen edition of record, deliberately.** An identifier
should mean *this is citable*, and this build's own front page directs citation to the edition of
record. `CITATION.cff` and the DOI both ship with the frozen edition, which is what enters the
citable sequence. Editions are versioned, and a later edition supersedes an earlier one
while the earlier stays citable exactly as deposited.
