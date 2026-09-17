#!/usr/bin/env python3
"""The §12.2 deposit re-hash gate, executable.

Until 2026-08-14 this was a habit of the Editor's, run as an ad-hoc snippet at each
summon. It caught three defects that way (F-E9, F-E10, F-E11) and the Architect then
made it a rule — so it should be a tool, not a habit. A habit is not re-runnable by
the next seat, and cannot be pointed at in a deposit act.

    verify_edition.py            # measure only; exit 1 if any row drifted
    verify_edition.py --repin    # measure, re-pin drifted rows, derive the aggregates
    verify_edition.py --repin --only SandboxA/sandboxA0a/almanac/edition/
                                 # re-pin ONLY this seat's own rows. USE THIS ONE after
                                 # editing edition faces: a bare --repin also absorbs the
                                 # corpus and substrate drifts owned by other seats.

Rows carrying `"sha256": null` are self-referential BY RULE (§12.3/§12.4): the reader's
edition renders its inventory from this manifest, and the campaign journal is written
after and about it. They are reported, never treated as drift, and they pin only at
deposit — when the writing they record has stopped.

Run under --repin whenever a listed file changes; run bare immediately before deposit,
per §12.2. Notification is the courtesy; measurement is the gate.
"""

import glob
import hashlib
import re
import subprocess
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))
MANIFEST = os.path.join(HERE, "MANIFEST.json")
EDITION = os.path.relpath(HERE, ROOT)      # rows and scans are root-relative


def rows_of(obj, out):
    if isinstance(obj, dict):
        if "path" in obj and "sha256" in obj:
            out.append(obj)
        for v in obj.values():
            rows_of(v, out)
    elif isinstance(obj, list):
        for v in obj:
            rows_of(v, out)
    return out


def slice_of(path, rule):
    """The bytes a row's claim is ABOUT, not the file that happens to contain them.

    RULED BY hypervisorA AS TREE OWNER, 2026-08-31 (REPORT 20260831T175022Z-hypervisorA-88500-6082),
    after this seat's freeze stopped on Sandbox.lean for the second time. Their argument, which is
    the general one: a whole-file sha256 is the wrong instrument for a claim about part of a file,
    and it is wrong IN BOTH DIRECTIONS. It fires on changes that cannot affect the claim - here, an
    import line added for the AN tree, which has nothing to do with GL1 - and it would NOT fire if
    the relevant lines were removed while the file changed size elsewhere. An instrument both over-
    and under-sensitive to its own claim should be replaced, not re-run.

    The rule is recorded in the manifest beside the hash so any reader reproduces the slice.
    """
    pat = re.compile(rule["regex"])
    with open(path, encoding="utf-8") as fh:
        lines = [l.rstrip("\n") for l in fh if pat.match(l.rstrip("\n"))]
    if rule.get("sort", True):
        lines.sort()
    return ("\n".join(lines) + "\n").encode("utf-8")


def blob_at(path, commit, expect_sha=None):
    """The bytes of a file AS OF a named commit, not as they sit on disk.

    THE LIBRARIAN'S DISTINCTION, 2026-09-01 (20260901T112750Z-librarianCM-71933-bb5d), and it is a
    correction of their own answer one hour old: a statement CARD can be SETTLED - it reaches a
    state and stays there until a finding moves it. An APPEND-ONLY JOURNAL is never settled, only
    CURRENT; every mining wave appends, and they ran one an hour after telling me the row was
    settled. Measured here: 5404 -> 5460 -> 5542 -> 5559 -> 5637 lines, strictly monotone.

    So a hash-on-disk pin of a journal goes stale by design and its drift is NOT a signal - which
    would train this seat to absorb the Librarian's rows routinely, defeating the --only guard.
    Pinning at a named commit cites a fixed historical state no later wave can move. Drift on the
    three statement CARDS stays a signal and is still treated as one.
    """
    out = subprocess.run(["git", "--no-optional-locks", "show", f"{commit}:{path}"],
                         cwd=ROOT, capture_output=True)
    if not out.returncode:
        return out.stdout

    # THE HISTORY CAN BE REPLACED UNDER THIS EDITION, AND ON 2026-09-11 IT WAS. The estate swapped
    # HQ's history for a fresh orphan commit (Overseer's commission, HQ_PUSH_DESIGN_2026-09-11);
    # pre-swap history survives only as a bundle. The Architect's §14 survey caught what that does
    # here: `git show` exits 128, this function raised, and NOT ONE of the 75 rows reported - the
    # edition could be neither verified nor rebuilt, and --repin could not write.
    #
    # THREE ROUTES, IN DESCENDING STRENGTH, AND THE PAGE SAYS WHICH ONE IT USED.
    #   1. the live history           - independent of the manifest
    #   2. a clone of the bundle      - independent of the manifest;  set ALMANAC_HISTORY_BUNDLE
    #   3. a tracked byte-copy here   - NOT independent: it is checked against the manifest's own
    #                                   sha256, so it can prove the bytes are the ones the manifest
    #                                   names, and cannot prove the manifest was ever right.
    # Route 3 is a fallback for REBUILDING, not evidence for verifying, and saying so is the point.
    bundle = os.environ.get("ALMANAC_HISTORY_BUNDLE")
    if bundle and os.path.isdir(bundle):
        out = subprocess.run(["git", "--no-optional-locks", "show", f"{commit}:{path}"],
                             cwd=bundle, capture_output=True)
        if not out.returncode:
            print(f"  blob_at: {path}@{commit[:12]} read from the history bundle at {bundle}")
            return out.stdout

    copy = os.path.join(HERE, "pinned", path.replace("/", "__") + f".at-{commit[:12]}")
    if os.path.exists(copy):
        with open(copy, "rb") as fh:
            payload = fh.read()
        got = hashlib.sha256(payload).hexdigest()
        if expect_sha is None:
            raise SystemExit(f"verify_edition: {path} is pinned at {commit[:12]}, the history no "
                             f"longer resolves it, and the tracked copy cannot be accepted without "
                             f"the sha256 the manifest records for it.")
        if got != expect_sha:
            raise SystemExit(f"verify_edition: the tracked copy of {path}@{commit[:12]} does NOT "
                             f"match the manifest: {got[:12]} vs {expect_sha[:12]}. A byte-copy "
                             f"that disagrees with the row it stands in for is worse than none.")
        print(f"  blob_at: {path}@{commit[:12]} read from the tracked copy "
              f"(history unavailable; checked against the manifest, not independent of it)")
        return payload

    raise SystemExit(f"verify_edition: {path} is pinned at commit {commit[:12]}, which does not "
                     f"resolve, and no tracked copy stands in for it. A pinned commit that cannot "
                     f"be read is a broken anchor, not a passing row.\n{out.stderr.decode()[:300]}")


def sha_of(path, rule=None, commit=None, expect_sha=None):
    if commit:
        return hashlib.sha256(blob_at(path, commit, expect_sha)).hexdigest()
    if rule:
        return hashlib.sha256(slice_of(path, rule)).hexdigest()
    with open(path, "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


# Writers that have DECLARED an atomic write for the artifacts they own. Rows outside
# these prefixes are protected by this gate's stability check and by nothing else — see
# the coverage line printed on every run. Add a prefix here only when that writer has
# actually adopted one, and say where.
ATOMIC_WRITERS = {
    "corpus/": "the Librarian — corpus/tools/atomic_write.py, commit 47b2008b, 2026-08-14",
    "SandboxA/sandboxA0a/almanac/edition/": "the Editor — this file, 2026-08-14",
}


def stable_sha_of(path, rule=None, commit=None, expect_sha=None):
    """Hash, and confirm the file is not being written underneath us.

    F-E13, the symmetric half. This gate cold re-hashes files owned by OTHER seats,
    which amend them on their own tick. A torn read differs from the committed bytes,
    and --repin would then record the hash of a file state that never existed as an
    artifact — silently, since drift is exactly what --repin exists to absorb. Read
    twice around a stat; if the two disagree, refuse to pin and say so. Cheap, and it
    fails toward asking rather than toward recording a fiction.

    THIS CHECK IS LOAD-BEARING WITH A NAMED SCOPE — it is NOT a fallback awaiting
    obsolescence, and a later seat should not delete it as redundant. Measured
    2026-08-14 (the Librarian's count, independently confirmed here): of 58 rows,
    exactly HALF belong to writers with a declared atomic write — the two seats who
    happened to be in the conversation that produced this — and the other half belong
    to seats not party to it at all. The run-time coverage line below re-derives that
    split rather than restating this number, because the number will move and a typed
    one goes stale (§12.5). Its honest limit stands: it catches ACTIVE rewriting, not
    every possible torn read, so it is a floor under writers who have no atomic write
    and never a licence to skip one.
    """
    first = sha_of(path, rule, commit, expect_sha)
    before = os.stat(path)
    second = sha_of(path, rule, commit, expect_sha)
    after = os.stat(path)
    stable = (first == second
              and (before.st_mtime_ns, before.st_size) == (after.st_mtime_ns, after.st_size))
    return first, stable


def main():
    repin = "--repin" in sys.argv[1:]
    # --only PREFIX: re-pin ONLY rows under PREFIX.
    # WHY THIS EXISTS (2026-08-30): a bare --repin absorbs EVERY drifted row, including rows
    # owned by other seats. This edition's four standing drifts are corpus and substrate files
    # belonging to the Librarian and the tree owner. Absorbing them would erase a disclosure the
    # §12.7 build-class gate reads, flip the distributable from PREVIEW to PUBLISHABLE, ship
    # CITATION.cff and remove the banner — on the strength of bytes this seat neither wrote nor
    # verified. The Shadow's recorded duty is to re-pin EDITION rows after its own edits, and the
    # tool had no way to say so.
    # --rows-settled-by WHO: the ONLY way to re-pin a row outside this seat's surface.
    # WHY THIS IS ENFORCED HERE AND NOT IN THE CALLER (2026-08-30): freeze_edition.py asks for an
    # authority before absorbing foreign rows, but a bare `verify_edition.py --repin` walks straight
    # past it — re-pinning all four corpus rows, producing zero drift, flipping the build to
    # PUBLISHABLE, and writing NO attribution. THE RESULTING MANIFEST IS BYTE-INDISTINGUISHABLE FROM
    # ONE WHOSE ROWS NEVER DRIFTED, so the tree owner's acceptance gate cannot tell the two apart by
    # reading it. A rule that is only enforced in one caller is a rule that fails silently in every
    # other. The guard belongs where the act happens.
    settled_by = None
    if "--rows-settled-by" in sys.argv[1:]:
        i = sys.argv.index("--rows-settled-by")
        if i + 1 >= len(sys.argv):
            print("--rows-settled-by needs an authority, e.g. \"librarianCM, mail <id>\"")
            sys.exit(4)
        settled_by = sys.argv[i + 1]
    only = None
    if "--only" in sys.argv[1:]:
        i = sys.argv.index("--only")
        if i + 1 >= len(sys.argv):
            print("--only needs a path prefix, e.g. --only SandboxA/sandboxA0a/almanac/edition/")
            sys.exit(4)
        only = sys.argv[i + 1]
    os.chdir(ROOT)                      # every row's path is root-relative
    text = open(MANIFEST).read()
    rows = rows_of(json.loads(text), [])

    missing, drifted, selfref, unstable = [], [], [], []
    total = 0
    for r in rows:
        if not os.path.exists(r["path"]):
            missing.append(r["path"])
            continue
        total += os.path.getsize(r["path"])
        if r["sha256"] is None:
            selfref.append(r["path"])
            continue
        actual, stable = stable_sha_of(r["path"], r.get("slice_rule"), r.get("at_commit"), r.get("sha256"))
        if not stable:
            unstable.append(r["path"])
            continue
        if actual != r["sha256"]:
            drifted.append((r["path"], r["sha256"], actual))

    for p in selfref:
        print(f"self-referential (pins at the deposit gate): {p}")
    for p in missing:
        print(f"MISSING: {p}")
    for p in unstable:
        print(f"BEING WRITTEN — refusing to pin, re-run when its owner is done: {p}")
    for p, was, now in drifted:
        print(f"DRIFT: {p}\n   recorded {was[:16]}\n   actual   {now[:16]}")

    MINE = "SandboxA/sandboxA0a/almanac/edition/"
    held = []
    if repin:
        foreign = [d for d in drifted if not d[0].startswith(MINE)]
        if foreign and not settled_by:
            print("\nREFUSING to re-pin rows outside this seat's surface without a named authority:")
            for p_, _, _ in foreign:
                print(f"    {p_}")
            print("\nThese belong to other seats. Re-pinning them silently would convert their bytes")
            print("into this edition's anchors with nobody having read them, and would leave a manifest")
            print("indistinguishable from one whose rows never moved. Pass")
            print('    --rows-settled-by "<who>, <mail id>"')
            print("and the attribution is recorded beside the re-pin. Rows on this seat's own surface")
            print("are re-pinned as usual; only the foreign ones are held back.")
            held = [d[0] for d in foreign]
            drifted = [d for d in drifted if d[0].startswith(MINE)]
        in_scope = [d for d in drifted if only is None or d[0].startswith(only)]
        out_of_scope = [d for d in drifted if only is not None and not d[0].startswith(only)]
        for p_, _, _ in out_of_scope:
            print(f"NOT RE-PINNED (outside --only {only}, and not this seat's to absorb): {p_}")
        for _, was, now in in_scope:
            text = text.replace(was, now)
        drifted = in_scope
        # §12.5: aggregates are DERIVED at measurement time, never typed. The line this
        # replaces read "~1.0 MB across 50 artifacts" while the set had grown to 55.
        # Patched as an encoded string rather than by re-dumping the whole manifest, so
        # the diff stays readable and nothing else in the file is reflowed.
        old = json.loads(text).get("contents_policy", {}).get("size")
        if old is not None:
            new = (f"DERIVED by verify_edition.py, {len(rows)} rows measured: "
                   f"{round(total / 1024 / 1024, 1)} MB; no third-party PDF is included. "
                   f"Never type this number — §12.5.")
            # The file mixes \u-escaped and literal non-ASCII, so try both encodings
            # rather than assuming one — a silent no-op here would leave a typed
            # aggregate in place while reporting that it had been derived.
            for enc in (json.dumps(old, ensure_ascii=False), json.dumps(old)):
                if enc in text:
                    text = text.replace(enc, json.dumps(new, ensure_ascii=False))
                    break
            else:
                raise SystemExit("verify_edition: could not locate the size field to "
                                 "derive it; refusing to report success")
        # F-E13: the manifest has readers other than its author — the Librarian read it
        # back at 12:36Z mid-write and got invalid JSON, and sat on it rather than raise
        # a false alarm. A truncated read of an integrity record is indistinguishable
        # from a corrupt one. Validate, then swap atomically: no reader ever sees a
        # partial file, and a bug here cannot leave a half-written manifest on disk.
        json.loads(text)
        tmp = MANIFEST + ".tmp"
        with open(tmp, "w") as fh:
            fh.write(text)
        os.replace(tmp, MANIFEST)
        print(f"\nre-pinned {len(drifted)} row(s); aggregates derived. "
              f"Re-render and re-publish (§12.6(1)): a repair whose published surface "
              f"still shows the defect is an unfinished repair.")
        if unstable:
            print(f"{len(unstable)} row(s) NOT pinned — being written. The set is "
                  f"incomplete until they are re-run.")

    ok = len(rows) - len(drifted) - len(missing) - len(selfref) - len(unstable)
    print(f"\n{len(rows)} rows: {ok} resolve, {len(drifted)} drift, "
          f"{len(missing)} missing, {len(selfref)} self-referential by rule, "
          f"{len(unstable)} being written")

    # A pinned hash that exists only in somebody's working tree cites bytes no other
    # seat can obtain. Checked by hand on 2026-08-14 for the MINING_LOG drift — the
    # on-disk sha equalled the blob in the commit its owner named — and made routine
    # here. Reported, never fatal: this seat's own rows are legitimately uncommitted
    # between an edit and its commit. AT DEPOSIT the count must be zero, or the
    # deposited edition references states that cannot be recovered from the record.
    uncommitted = []
    try:
        import subprocess
        out = subprocess.run(["git", "status", "--porcelain", "--"] + [r["path"] for r in rows],
                             capture_output=True, text=True, timeout=60)
        if out.returncode == 0:
            uncommitted = [ln[3:].strip() for ln in out.stdout.splitlines() if ln.strip()]
    except Exception as exc:                       # git absent or slow: say so, do not guess
        print(f"(uncommitted-rows check skipped: {exc})")
    if uncommitted:
        print(f"{len(uncommitted)} row(s) pin bytes that are NOT COMMITTED — fine while "
              f"working, MUST be zero at deposit:")
        for p in uncommitted[:10]:
            print(f"  uncommitted: {p}")

    # UNTRACKED IS NOT A KIND OF UNCOMMITTED, AND THE CHECK ABOVE CANNOT SEE IT (2026-09-11).
    # `git status --porcelain` says NOTHING about an ignored, untracked path, so a row whose file
    # git has been told to ignore reports perfectly clean — and "0 uncommitted" is exactly what the
    # deposit gate reads. Today's publication withhold added /corpus/literature/transcribed/ to the
    # main .gitignore to stop those files travelling OUTWARD, and untracked 484 transcripts, 455
    # PDFs and 1,184 arXiv sources as a side effect. The Librarian found it because their own commit
    # was refused; this instrument reported zero throughout, on the purest case of the condition it
    # exists to catch. F-E15, which this seat enforced against them on 09-07: a pin must reference
    # bytes anyone can obtain. Untracked bytes are obtainable from ONE working tree, by one person,
    # until that tree is lost. Counted separately from `uncommitted`, because uncommitted is
    # transient by nature and untracked is not, and carried into the exit code.
    untracked = []
    try:
        import subprocess
        paths = [r["path"] for r in rows]
        known = subprocess.run(["git", "ls-files", "--"] + paths,
                               capture_output=True, text=True, timeout=60)
        if known.returncode == 0:
            seen = set(known.stdout.split("\n"))
            untracked = [p for p in paths if p not in seen]
    except Exception as exc:
        print(f"(untracked-rows check skipped: {exc})")
    # AND THE SPLIT THAT DECIDES WHETHER IT MATTERS (corrected within the hour, by the Librarian
    # correcting themselves: F-E15 says a pin must reference bytes anyone can OBTAIN, and it does
    # NOT say "reachable in a git repository"). A SHIPPED row's bytes travel inside the edition, so
    # the bundle obtains them without depending on anybody's commit act — which is a STRONGER
    # answer than git-reachability, not a weaker one, and is the whole content of ACM-45 §9b. An
    # UNSHIPPED row's bytes travel nowhere: untracked there means obtainable from one working tree
    # by one person, and that is the failure F-E15 names. Reporting both as one number said the
    # edition was broken when it was not.
    ships_map = {r["path"]: r.get("ships", True) for r in rows}
    untracked_shipped   = [p for p in untracked if ships_map.get(p, True)]
    untracked_unshipped = [p for p in untracked if not ships_map.get(p, True)]
    if untracked_shipped:
        print(f"\n{len(untracked_shipped)} row(s) are NOT TRACKED BY GIT but SHIP in the bundle — "
              f"F-E15 is satisfied by the bundle, not by git, and the direction of that is worth "
              f"saying out loud: FOR THESE FILES THIS EDITION IS NOW THE ONLY VERSIONED COPY "
              f"ANYWHERE. An outward publication is a poor place for the estate's only history.")
        for p in untracked_shipped[:12]:
            print(f"  untracked, shipped: {p}")
    if untracked_unshipped:
        print(f"\n{len(untracked_unshipped)} row(s) pin bytes that are NEITHER TRACKED NOR SHIPPED "
              f"— obtainable from this working tree and nowhere else (F-E15). A withhold that "
              f"ignores a path to stop it travelling outward also untracks it; "
              f"harness/publication_ignore_hq.gitignore withholds WITHOUT untracking.")
        for p in untracked_unshipped[:12]:
            print(f"  untracked, unshipped: {p}")

    # §12.4, checked instead of remembered. The clause — the checkable set is closed
    # under citation — was ruled at 12:35Z and this edition violated it five times by
    # 14:40Z, three of them found only when a neighbour's unrelated finding prompted a
    # sweep. A clause names the class; something has to look. Heuristic by nature: it
    # scans shipped files for corpus ids, resolves them anywhere under corpus/, and
    # reports any that resolve but are not rows. Over-reports prose fragments (they
    # resolve nowhere and are listed separately); never silently under-reports a real
    # citation. ACTIVITY.md and STATE.md are excluded — journal and resume header,
    # which discuss ids rather than cite them as evidence.
    cited_not_row = []
    try:
        import re
        index = {}
        for dp, _, fns in os.walk("corpus"):
            for fn in fns:
                index.setdefault(os.path.splitext(fn)[0], []).append(os.path.join(dp, fn))
        rowpaths = {r["path"] for r in rows}
        shipped = [p for p in glob.glob(EDITION + "/*.md") + glob.glob(EDITION + "/*.json")
                   + glob.glob(EDITION + "/gaps/*.md")
                   if os.path.basename(p) not in ("ACTIVITY.md", "STATE.md")]
        # TWO scans, because the first one inherited its author's categories. The id
        # scan below thinks in cards — it was written by a seat that thinks in cards,
        # and it found three violations while missing four more that were sitting in
        # plain sight as ordinary repo paths (the typed ACCEPTANCE among them). The
        # Librarian named the rule from their own two-shelf sweep and it landed here
        # within the hour: A CHECK INHERITS THE CATEGORIES OF WHOEVER WROTE IT. Widen
        # the scan, and when adding a category ask what the new one still cannot see.
        seen = {}
        for f in shipped:
            text = open(f).read()
            for m in re.finditer(r"\b((?:lit|own|even|gl2|gl3|gl4)[-.][a-z0-9.-]{8,})\b", text):
                cid = m.group(1).rstrip(".-")
                if not cid.endswith(".md"):     # a full path is handled by the path scan
                    seen.setdefault(cid, set()).add(os.path.basename(f))
            for m in re.finditer(r"\b((?:Sandbox|SandboxA|corpus|engine|harness|blueprint)"
                                 r"[A-Za-z0-9_./-]*\.[A-Za-z0-9]{1,6})\b", text):
                seen.setdefault(m.group(1), set()).add(os.path.basename(f))
        # Named as PROCEDURE, not cited as documents whose content warrants a claim.
        # Excluded WITH the reason, per §12.4's converse; the artefact that warrants
        # the computation claims is the release log, which is a row.
        PROCEDURAL = {"engine/job_gate.py", "engine/release_verify.sh"}
        for cid, where in sorted(seen.items()):
            if cid in PROCEDURAL or cid in rowpaths:
                continue
            hits = index.get(cid, []) or ([cid] if os.path.exists(cid) else [])
            if hits and not any(h in rowpaths for h in hits):
                cited_not_row.append((cid, hits[0], sorted(where)))
    except Exception as exc:
        print(f"(citation audit skipped: {exc})")
    if cited_not_row:
        print(f"{len(cited_not_row)} corpus artifact(s) CITED AS EVIDENCE BUT NOT A ROW "
              f"(§12.4 — the checkable set is closed under citation):")
        for cid, path, where in cited_not_row:
            print(f"  {cid}\n     resolves to {path}\n     cited in {where}")

    # Derived, never typed (§12.5): who protects these bytes besides this check.
    covered = [r for r in rows
               if any(r["path"].startswith(p) for p in ATOMIC_WRITERS)]
    bare = len(rows) - len(covered)
    print(f"atomic-write coverage: {len(covered)}/{len(rows)} rows have an owner with a "
          f"declared atomic write; {bare} rely on the stability check above and nothing "
          f"else. That is why it is load-bearing, not a fallback.")
    for prefix, who in sorted(ATOMIC_WRITERS.items()):
        print(f"  covered: {prefix}  ({who})")
    # `unstable` is non-zero in BOTH modes: bare it is an unmeasured row, and under
    # --repin it is a row deliberately left unpinned. Either way the set is not fully
    # measured, and a deposit must not proceed on it.
    # A REFUSAL MUST REACH THE VERDICT LINE, OR IT IS NOT A REFUSAL (2026-09-11).
    # `--repin --only <a foreign path>` printed eight lines explaining that it would not absorb
    # another seat's row, dropped that row from `drifted` so the rest of the run would not trip
    # over it, and then ended "VERDICT: CLEAN (0 drift)". Both halves were true of their own
    # scope and the last line was the one a reader believes. The assemble step caught the drift
    # independently, which is the only reason this was found rather than published. Held rows now
    # carry through to the verdict and the exit code, exactly like an unmeasured one.
    code = 1 if (drifted and not repin) or missing or unstable or held or untracked_unshipped else 0

    # READ THIS LINE, NOT THE EXIT CODE, IF YOU PIPE THIS. `verify_edition.py | grep`
    # reports GREP's status, not this gate's — paid for on 2026-08-15, when a DRIFT
    # line printed beside `exit=0`; the Librarian had made the identical mistake hours
    # earlier while testing the very tool they had written to prevent confident wrong
    # claims, and fixed it the same way (corpus/tools/absence_check.py, 3b57fcfa).
    # A TOOL THAT REPORTS CORRECTLY CAN STILL BE READ WRONGLY, AND THE READING IS PART
    # OF THE INSTRUMENT. The verdict survives a pipe; the exit code does not.
    verdict = ("DRIFT" if drifted and not repin else
               "MISSING" if missing else
               "UNTRACKED" if untracked_unshipped and not (drifted or held) else
               "BEING_WRITTEN" if unstable else
               "HELD" if held and not drifted else
               "REPINNED_WITH_HELD" if drifted and held else
               "REPINNED" if drifted and repin else
               "CLEAN")
    detail = (f"{len(rows)} rows, {len(drifted)} drift, {len(missing)} missing, "
              f"{len(unstable)} being written, {len(cited_not_row)} cited-not-row, "
              f"{len(uncommitted)} uncommitted"
              + (f", {len(held)} HELD (another seat's, needs --rows-settled-by)" if held else "")
              + (f", {len(untracked_shipped)} untracked-but-shipped" if untracked_shipped else "")
              + (f", {len(untracked_unshipped)} UNTRACKED-AND-UNSHIPPED" if untracked_unshipped else ""))
    print(f"VERDICT: {verdict} ({detail})")
    return code


if __name__ == "__main__":
    sys.exit(main())
