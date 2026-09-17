# CoW blind-faithfulness panel — goalv0a ↔ GOALv0a (Sandbox/A1/GL1/)

Remediation of the approval-2 caveat "CoW blind-faithfulness pass was NOT run" (signed
2026-07-20 out of order; see APPROVAL_STATE.json caveats_carried and the accountability
note in informal/ACTIVITY.md). Protocol: three-seat panel per sandboxv1R/rescue/ precedent,
hypervisor recused (this seat signed approval-2; it dispatches and transcribes only).
Seats: gpt-5.5/xhigh · gemini-3.1-pro-preview · fable-5 (Fable seat mandatory in CoW
panels — CLAUDE.md subagent-policy carve-out, Overseer 2026-07-21).

Statement of record: informal/goalv0a.tex, sha256 91a50173…5a7e — hash-verified against
goalv0a.lock.json by dispatch.py BEFORE each dispatch (assert, not convention).

## Pass #1 — 2026-07-21 ~14:00Z — NOT FAITHFUL (adjudication: incomplete materials + one split finding)

Materials: goalv0a.tex + the six GL1 modules verbatim (MATERIALS.md, 105,346 chars).
Raw replies: COW1_seat_gpt.out, COW1_seat_fable.out. Gemini seat FAILED (API 503,
transient) — recorded, not substituted.

| seat | verdict |
|---|---|
| gpt-5.5/xhigh | **UNFAITHFUL** — decisive finding F-K1 |
| gemini-3.1-pro | (unavailable, 503) |
| fable-5 | **UNDECIDED** — decisive finding F-ν (materials gap) |

**F-K1 (gpt; fable dissents on disposition).** The certified statements live over
`K1 = Frac(ℤ[q^±,z^±]) = ℚ(q,z)`; the signed goal fixes `K_z = ℚ(q)[z^±1]`. gpt: object
substitution, hence UNFAITHFUL under the mandate's "exactly these rings". fable (finding 2):
a loudly-recorded uniform STRENGTHENING — every clause over the larger ambient implies the
informal clause, and the certified clause (iii) forces the K1-Newton set into
`K_z[Y̌^±]`, so the informal statement is recoverable as a corollary; also notes the informal
Def 3 itself base-changes to `Frac(A_z)` (= K1) for the centre. SPLIT — carried to pass #2
adjudication. Program precedent (v1R panels, K₀ quantification ruled BENIGN by all seats)
is NOT disclosed to the panel; it will be weighed only at adjudication, in the open.

**F-ν (both seats, convergent).** The ν_r definition (`newtonPolyK`/`nuNewton`) and
`AzSubring`/`qInt` live in imported modules not supplied, and they sit inside the
STATEMENTS of 4 of the 8 certified declarations — a blind panel cannot certify what it
cannot read. **Dispatcher defect (this seat's), not a Lean defect.** Fix: pass #2
materials add Sandbox/A1/{CenterNewtonZ,CenterNewton,CenterLattice,Verma}.lean verbatim.

**Points both seats independently graded FAITHFUL** (recorded; pass #2 re-audits from
scratch): A_z object identity; Def 1 presentation incl. derived bilateral `K_{n,+}K_{n,-}=z^n`;
∀χ∈ℤ grid, `ev_χ(Y̌)=Q^χ` z-free unshifted; rank-0 degeneracy honesty of clauses (i)/(ii)
with the W-invariance clause present, vacuity a theorem not a definition; clause (iii) as a
genuine iff over all u∈ℤ, r≥0; both non-degeneracy strictness pins genuine.

## Pass #2 — 2026-07-21 ~14:3xZ — LANDED: UNFAITHFUL 2:1, single finding F-K1

Same prompt + re-pass note (materials completion only; nothing in the Lean tree changed
between passes; no pass-1 findings disclosed — blindness preserved). Materials:
MATERIALS_COW2.md (144,143 chars: six GL1 modules + the four imported definition modules).
Raw replies: COW2_seat_{gpt,gemini,fable}.out.

| seat | verdict | on F-K1 |
|---|---|---|
| gpt-5.5/xhigh | **UNFAITHFUL** | object substitution; "the audit asks for the same rings" |
| gemini-3.1-pro | **UNFAITHFUL** | "direct object substitution"; notes docstrings acknowledge it; cites the mandate's "EXACTLY these rings" |
| fable-5 | **FAITHFUL** | recorded (F4), implication-preserving, and for clause (ii) the informal Def 3 itself base-changes to Frac(A_z) = K₁ |

**F-ν RESOLVED 3/3.** With the defining modules supplied, all three seats confirm
`newtonPolyK 1 r = ∏_{t<r}(X−Q^t)/(Q^r−Q^t)`, `Q = q²`, `ν₀ = 1` — Def 5 exact, including
the denominator form. (gpt finding 6, gemini closing note, fable finding 5.)

**Everything except F-K1 is now unanimous FAITHFUL across all seats and both passes:**
A_z realized exactly (the `z₂ := 1` bridge audited and cleared by all three); Def-1
presentation one-for-one with initiality certifying no accidental collapse; ∀χ∈ℤ grid,
bilateral, z-free, unshifted; clause (iii) genuine two-sided equality over all u∈ℤ, r≥0;
rank-0 degeneracy honest (W-clause present, vacuity a theorem; `clause_ii` pins the iso to
BE HC via `∀ t, e t = HC t`, not "∃ some iso"); Def 3 centre taken literally and the
coincidence proved; both strictness pins genuine, and fable notes `(Q−1)⁻¹ ∈ K_z` so
neither separation is an artifact of the enlargement; no content-bearing hidden hypotheses.

## Adjudication (2026-07-21, per the rule fixed in advance above)

**PANEL VERDICT: UNFAITHFUL (2:1) on exactly one finding, F-K1** — the certified
statements' ambient is `K₁ = Frac(A_z) = ℚ(q,z)` where the signed goal fixes
`K_z = ℚ(q)[z^±1]` (Defs 1–2; Def 3 base-changes to Frac(A_z) for the centre, which is
where fable locates the partial legitimacy).

Under the pre-registered rule this seat does NOT waive or re-argue F-K1. It goes to the
human Overseer (approval-1 owner) with these dispositions:

- **(a) Corrigendum wave, literal restatement over `K_z`.** Mathematically total; costly —
  `K_z` is not a field, and the whole Frame/Torus substrate is field-based. Largest option.
- **(b) Bridge wave (recommended).** Define the `K_z`-submodel inside `Frame K₁` (the
  `ℚ(q)`-span of `z^±, Y̌^±`), certify the literal informal clauses as corollaries of the
  existing K₁ theorems (fable's finding-2 route: generators of `nuGenSet` lie in
  `K_z[Y̌^±]`; A_z-span membership is ambient-independent). Preserves the certification,
  closes F-K1 by proof rather than by ruling. Bounded: one module, est. 2–4 obligations.
- **(c) Lock revision chartering `K₁`** — the exact v1R precedent (lock revision R2,
  Overseer-signed, chartered GOALv1R "OVER THE CONCRETE FAMILY FIELD" `K₀ = Frac(𝓜)`;
  `FamilyField.lean:17`). Cheapest; makes the recorded F4 deviation signed rather than
  merely recorded.

**Dispatcher bias note (this seat's, on the record):** both UNFAITHFUL verdicts explicitly
cite the panel mandate's phrase "realizes EXACTLY these rings … no coefficient-ring swap" —
wording this dispatcher wrote. A softer mandate might have split the other way. The
pre-registered rule makes this moot for process (the finding goes up regardless), but the
Overseer should weigh F-K1 knowing the mandate pre-committed the strict reading.

**Status: approval-2 stands signed but now carries a live adverse panel finding; approval-5
(closure) BLOCKED pending Overseer disposition of F-K1.**
*(Superseded by pass #3 below — disposition (b) executed, finding resolved by proof.)*

## Pass #3 — 2026-07-21 ~15:1xZ — F-K1 RESOLVED, 3/3 UNANIMOUS (full panel)

Fix-then-verify round (v1R precedent). Disposition (b) executed first: new module
`Sandbox/A1/GL1/KzBridge.lean` (F-K1 bridge wave, opus agent, new-file-only) constructs the
literal `K_z = ℚ(q)[z^±1]` inside `K₁` (`Fq = Subfield.closure {qK}`,
`KzCoeff = Subring.closure (Fq ∪ {zK, zK⁻¹})`, `KzAmbient = range` of the coefficient-
restricted Laurent map, characterization `mem_KzAmbient_iff` PROVED) and certifies
`Newton_mem_KzAmbient` (the two Newton lattices COINCIDE — enlarging `K_z → K₁` adds no
Newton elements), `clause_iii_Kz`, `clause_i_Kz`, `mem_UevKz_iff_Newton`,
`nuGenSet_subset_KzAmbient`. Materials: MATERIALS_COW3.md (157,512 chars) = pass-2 set +
KzBridge.lean verbatim; F-K1 disclosed (a fix exists to adjudicate); all other pass-2
points not re-litigated unless a NEW problem surfaced. Raw replies: COW3_seat_{gpt,gemini,fable}.out
(gemini landed on retry after repeated 503s; all three seats spoke).

| seat | pass-2 vote | pass-3 verdict |
|---|---|---|
| gpt-5.5/xhigh (F-K1 originator) | UNFAITHFUL | **F-K1: RESOLVED** — "the decisive F-K1 repair: enlarging from K_z to K1 adds no Newton elements"; "No new weakening found." |
| gemini-3.1-pro | UNFAITHFUL | **F-K1: RESOLVED** — "beautifully kills the F-K1 objection by proof" |
| fable-5 | FAITHFUL | **VERDICT: FAITHFUL · F-K1: RESOLVED** |

No seat raised a new finding. Clause (ii) needs no `K_z` form (informal Def 3 base-changes
to `Frac(A_z) = K₁`) — confirmed explicitly by gpt (finding 5).

## TERMINAL PANEL STATE

**goalv0a ↔ GOALv0a (+ KzBridge): FAITHFUL.** Arc: pass-1 NOT FAITHFUL (materials defect +
split F-K1) → pass-2 UNFAITHFUL 2:1 (F-K1 isolated, all else unanimous) → disposition (b)
bridge wave → pass-3 **F-K1 RESOLVED 3/3 unanimous, full panel, originator included**.
Kernel side: KzBridge decls under `release_verify --source` with the 8 original decls
(13 total); idiom gate PASS after two legitimate blocks (5 missing annotations; one false
FQN citation by the dispatcher, corrected to the `to_additive` source decl
`MonoidAlgebra.mapRingHom`). The approval-2 caveat "CoW blind-faithfulness NOT run" is
fully discharged.

## Adjudication rule (fixed in advance of pass-2 verdicts)

- F-ν: resolved iff seats confirm `nuNewton r Y = ∏_{s<r}(Y−Q^s)/(Q^r−Q^s)`, `Q=q²`
  matches Def 5 and the statement-level chain `nu → nuGenSet → clause_iii` is clean.
- F-K1: if pass #2 returns UNFAITHFUL from any seat on this point, the disposition is NOT
  this seat's to waive — options go to the human Overseer (approval-1 owner): (a) corrigendum
  wave restating the four clause statements over K_z literally; (b) a small bridge wave
  certifying the literal K_z statements as corollaries of the K1 theorems (fable's finding-2
  route — preserves the existing certification); (c) an Overseer-signed reading that the
  Frac(A_z) ambient is the intended formal rendering (v1R precedent). This panel record
  binds the seat to not self-adjudicate F-K1.
