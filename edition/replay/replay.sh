#!/usr/bin/env bash
# ONE COMMAND: rebuild every proof this edition certifies, and print the axioms each one used.
#
#     ./replay.sh
#
# It needs elan (the Lean toolchain manager) and network access on first run. Everything else --
# the Lean version, the Mathlib revision, the sources -- is pinned inside this directory.
#
#     curl https://elan.lean-lang.org/elan-init.sh -sSf | sh     # if you do not have elan
#
# FIRST RUN IS SLOW AND MOSTLY DOWNLOAD: `lake exe cache get` fetches Mathlib's prebuilt objects,
# several GB. Budget 20-60 minutes. Later runs take seconds. Building Mathlib from source instead
# takes HOURS -- if the cache step fails, fix the network rather than letting the build proceed.
set -euo pipefail
cd "$(dirname "$0")"

echo "== toolchain =================================================================="
cat lean-toolchain
lake --version

echo
echo "== fetching the pinned Mathlib (prebuilt; several GB on first run) ============"
lake exe cache get

echo
echo "== building the proofs ========================================================"
lake build

# A SUCCESS LINE IS NOT A BUILD. `lake build` with nothing to do prints "Build completed
# successfully (0 jobs)" and exits 0, so the only honest check is whether the object files exist.
missing=0
for m in Sandbox/A1/GL1/GOALv0a Sandbox/A1/GL1/PresentedU Sandbox/A1/GL1/FamilyField1          Sandbox/A1/GL1/NewtonUnivGrid Sandbox/A1/GL1/NewtonUnivSpan          Sandbox/A1/GL1/NonDegeneracy Sandbox/A1/GL1/KzBridge; do
  [ -f ".lake/build/lib/lean/$m.olean" ] || { echo "MISSING OBJECT: $m.olean"; missing=1; }
done
if [ "$missing" -ne 0 ]; then
  echo
  echo "FAIL: the build reported success and produced no object files. Nothing was compiled,"
  echo "so nothing below would have been checked. This is a defect in the build configuration,"
  echo "not in the proofs."
  exit 1
fi

echo
echo "== axioms: the only thing that certifies anything ============================="
lake env lean Verify.lean 2>&1 | tee replay_axioms.txt

echo
# LEAN WRAPS A LONG AXIOM LIST ACROSS LINES, so a line-at-a-time grep reports a clean declaration
# as dirty. The third fresh-clone test of this tree printed "FAIL: 5 declarations depend on axioms
# outside the triple" over a transcript in which all 31 were exactly the triple -- the five whose
# names are long enough that Lean broke the list after "[propext,". A FALSE FAIL IS THE WORSE
# DIRECTION HERE: it tells a reader the certification is broken. So records are joined until their
# closing bracket, then whitespace-normalised, before anything is decided.
echo "== verdict ===================================================================="
awk '
function flush(  t) {
  if (rec == "") return
  t = rec; gsub(/[ 	]+/, " ", t); n++
  if (t ~ /sorryAx/) { bad++; print "  sorryAx: " t }
  else if (t !~ /\[propext, Classical\.choice, Quot\.sound\]/) { off++; print "  off-triple: " t }
  rec = ""
}
/depends on axioms/ { flush(); rec = $0; next }
rec != "" && rec !~ /\]/ { rec = rec " " $0 }
END {
  flush()
  printf "declarations checked: %d\n", n
  if (n == 0)   { print "FAIL: no axiom lines at all -- the build produced nothing to check."; exit 1 }
  if (bad > 0)  { printf "FAIL: sorryAx appears in %d declaration(s). Nothing here is certified.\n", bad; exit 1 }
  if (off > 0)  { printf "FAIL: %d declaration(s) depend on axioms outside the clean triple.\n", off; exit 1 }
  printf "PASS: all %d declarations depend on exactly [propext, Classical.choice, Quot.sound]\n", n
  print  "      -- no sorryAx, no custom axioms."
}
' replay_axioms.txt
echo "Transcript: replay_axioms.txt"
