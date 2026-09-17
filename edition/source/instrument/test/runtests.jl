using GL1Newton
using Oscar
using Test

# ---- Target ----------------------------------------------------------------------
# STANDALONE ALMANAC EDITION of the BQ-13 acceptance battery
# (HybridQuantum/test/a1_gl1_newton.jl at Sandbox commit 7ddb2e8f), in the CURRENT
# Sandbox-wide notation (migration of 2026-08-10, Overseer-ordered): the former
# symbols Q, q, z are written q, v, t, with q = v^2 and t = z^2.
#
# ADAPTATIONS from the HQ battery, exhaustively (everything else is verbatim up to
# the notation dictionary):
#   1. `using HybridQuantum` -> `using GL1Newton` (top-level package).
#   2. The square-root-side bridge no longer rides `parent_a1()`: it uses the
#      package's own v-side module GL1Newton.QFunctions (src/qFunctions.jl, the A0a
#      edition of HybridQuantum/src/QFunctions.jl in current notation; revised
#      2026-08-10 from an inline duplicate to the packaged module).
#   3. The two CROSS-INSTRUMENT tie assertions (agreement with
#      `HybridQuantum.laurent_data_over_z_qq`) are HQ-internal and remain in HQ's
#      battery; the same counts (171 and 78) are asserted here via `az`.
#   4. H3's source path is the package layout (src/GL1Newton.jl).
#
# FRAME: q = v^2; grid unshifted and t-free, ev_chi(x) = q^chi for all chi in Z;
# t a spectator; W = {1} (no reflection, no walls); A_t = Z[q^{+-1}, t^{+-1}] at this
# layer (the goal ring Z[v^{+-1}, t^{+-1}] restricted to the ring this base field sees
# -- the STRONGER condition, the declared BQ-13 DESIGN 1.2 divergence, translated).
# ------------------------------------------------------------------------------------

@testset "GL_1 even-Newton layer (GL1Newton, standalone, current notation)" begin
    R = GL1Newton.frame()
    K, Rx, q, t, x = R.K, R.Rx, R.q, R.t, R.x

    # Square-root-side bridge (adaptation 2, revised 2026-08-10): the v-side now
    # ships IN the package as GL1Newton.QFunctions (qFunctions.jl), so the bridge
    # uses it directly instead of an inline duplicate.
    F = GL1Newton.QFunctions.frame()
    Kv, v = F.K, F.v
    tov(c) = evaluate(numerator(c), [v^2, one(Kv)]) //
             evaluate(denominator(c), [v^2, one(Kv)])
    sym_binom_v(m::Int, k::Int) = GL1Newton.QFunctions.sym_q_binom_value(F, m, k)

    nu1 = GL1Newton.nu(R, 1)          # (x-1)/(q-1) — the trap-4 witness

    @testset "API shape, cache, edge cases" begin
        @test GL1Newton.frame() === R                       # cached singleton
        @test GL1Newton.nu(R, 0) == one(Rx)
        @test_throws ArgumentError GL1Newton.nu(R, -1)
        @test GL1Newton.expand(R, zero(Rx)) == Dict{Int,elem_type(K)}()
        @test GL1Newton.expand(R, Rx(x^2); D=5) == GL1Newton.expand(R, Rx(x^2))
        @test_throws ErrorException GL1Newton.expand(R, Rx(x^3); D=1)
        @test GL1Newton.grid(R, 0) == one(K)
        # return types are exact, not merely truthy
        @test GL1Newton.grid(R, 3) isa elem_type(K)
        @test GL1Newton.nu_grid(R, 2, 5) isa elem_type(K)
        @test GL1Newton.expand(R, Rx(x^2)) isa Dict{Int,elem_type(K)}
        @test GL1Newton.az(one(K)) isa Bool
        @test GL1Newton.newton(R, Rx(x^2)) == (true, :PROVED_BOUNDED, 12)
        @test GL1Newton.newton(R, Rx(x^2); window=3) == (true, :PROVED_BOUNDED, 3)
        @test_throws ArgumentError GL1Newton.newton(R, Rx(x^2); window=-1)
        @test GL1Newton.mem_span(R, Rx(x^2)) isa Bool
        @test GL1Newton.laurent(R, Rx(x^2)) isa Bool
        # measured Newton coordinates of x^2
        @test GL1Newton.expand(R, Rx(x^2)) == Dict(0 => one(K), 1 => q^2 - 1,
                                                   2 => q^4 - q^3 - q^2 + q)
    end

    @testset "A1 — 171-value integrality sweep (Gate-0 pin P1a / P1a_count)" begin
        vals = [(r, chi, GL1Newton.nu_grid(R, r, chi)) for r in 0:8 for chi in -9:9]
        @test length(vals) == 171
        @test count(GL1Newton.az(vv) for (_, _, vv) in vals) == 171
        # spot value, computed from Def 5
        @test GL1Newton.nu_grid(R, 2, -3) == (q^4 + q^3 + 2*q^2 + q + 1) // q^7
    end

    @testset "A2 — triangularity (Gate-0 pin P2a_zero / P2b_diag)" begin
        @test all(iszero(GL1Newton.nu_grid(R, r, m)) for r in 0:8 for m in 0:(r - 1))
        @test all(isone(GL1Newton.nu_grid(R, r, r)) for r in 0:8)
    end

    @testset "A3 — symmetric-normalisation bridge (Gate-0 pin P1c_gaussian_all)" begin
        # nu_r(q^m) == v^{r(m-r)} * sym_binom_v(m, r)   for m >= r.
        @test all(tov(GL1Newton.nu_grid(R, r, m)) ==
                  v^(r * (m - r)) * sym_binom_v(m, r)
                  for m in 0:8 for r in 0:m)
        # ODD exponent case — a build that silently worked in QQ(q) cannot pass this.
        @test isodd(1 * (2 - 1))
        @test tov(GL1Newton.nu_grid(R, 1, 2)) == v^1 * sym_binom_v(2, 1)
        # spot value
        @test tov(GL1Newton.nu_grid(R, 2, 6)) == v^(2 * 4) * sym_binom_v(6, 2)
    end

    @testset "A4 / H1 — trap-4 witness, bounded evaluation vs span vs Laurent" begin
        # The corrected BR witness: evaluation and span agree; Laurent disagrees.
        @test GL1Newton.newton(R, nu1) == (true, :PROVED_BOUNDED, 12)
        @test GL1Newton.mem_span(R, nu1) == true
        @test GL1Newton.laurent(R, nu1) == false

        # Anti-vacuity: all three predicates are exercised on positive and negative inputs.
        @test GL1Newton.newton(R, Rx(x^2)) == (true, :PROVED_BOUNDED, 12)
        @test GL1Newton.mem_span(R, Rx(x^2)) == true
        @test GL1Newton.laurent(R, Rx(x^2)) == true
        all_false = nu1 * inv(q - 1)
        @test GL1Newton.expand(R, all_false) == Dict(1 => inv(q - 1))
        @test GL1Newton.newton(R, all_false) == (false, :REFUTED, -12)
        @test GL1Newton.mem_span(R, all_false) == false
        @test GL1Newton.laurent(R, all_false) == false

        # A zero-width positive verdict is explicitly bounded, not an unbounded proof.
        @test GL1Newton.newton(R, all_false; window=0) == (true, :PROVED_BOUNDED, 0)
        @test GL1Newton.newton !== GL1Newton.mem_span
        @test GL1Newton.newton !== GL1Newton.laurent
        # A_t[x] is contained in both computed windows and the Newton span; nu1 makes it strict.
        @test all(GL1Newton.newton(R, Rx(x^k)) == (true, :PROVED_BOUNDED, 12) for k in 0:6)
        @test all(GL1Newton.mem_span(R, Rx(x^k)) for k in 0:6)
    end

    @testset "H2 — constant-term control (closes DESIGN defect F3)" begin
        # These two FAIL on the reference implementation (loop `1:length(f)` skips
        # coeff(f,0)). The correct loop is `0:degree(f)`.
        @test GL1Newton.laurent(R, Rx(inv(q - 1))) == false          # constant, not in A_t
        @test GL1Newton.laurent(R, x - inv(q - 1)) == false          # bad constant, good linear
        @test GL1Newton.laurent(R, zero(Rx)) == true
        @test GL1Newton.laurent(R, x + Rx(t^-1)) == true
    end

    @testset "H3 — native, not a wrapper (structural)" begin
        # The GL_2 code is a CONSISTENCY REFERENCE ONLY: the source must contain zero
        # CALLS into it. Prose references in `#` comments and in docstrings are allowed
        # and expected; only executable code is scanned.
        src = read(joinpath(@__DIR__, "..", "src", "GL1Newton.jl"), String)
        code_lines = String[]
        in_doc = false
        for l in split(src, '\n')
            if occursin("\"\"\"", l)
                in_doc = !in_doc
                continue
            end
            in_doc && continue
            startswith(strip(l), "#") && continue
            push!(code_lines, split(l, '#')[1])   # drop trailing comments
        end
        code = lowercase(join(code_lines, '\n'))
        @test !isempty(strip(code))               # the scan is not vacuous
        for forbidden in ("gl2_", "_gl2_", "gl2weylbalancedring", "srho", "wall")
            @test !occursin(forbidden, code)
        end
        # Standalone control: no call into the development substrate either.
        @test !occursin("hybridquantum", code)
    end

    @testset "H4 — frame controls (no spurious q-shift; t is a spectator)" begin
        # trap 2: the grid is UNSHIFTED. A build importing the GL_2 shifted convention
        # returns q^{chi+1} or a t-laden node and fails here.
        @test all(GL1Newton.grid(R, chi) == q^chi for chi in -4:4)
        @test GL1Newton.grid(R, -4) == inv(q^4)
        @test !occursin("t", string(GL1Newton.grid(R, 3)))
        # t is a spectator: nu is t-free and a t-factor changes neither verdict.
        @test all(!occursin("t", string(GL1Newton.nu(R, r))) for r in 0:4)
        @test GL1Newton.newton(R, Rx(t^-1) * nu1) == (true, :PROVED_BOUNDED, 12)
        @test GL1Newton.mem_span(R, Rx(t^-1) * nu1) == true
        @test GL1Newton.laurent(R, Rx(t^-1) * nu1) == false
    end

    @testset "H5 — az tests integrality over Z (closes DESIGN defect F4)" begin
        # The first two FAIL on the reference implementation (`length(denominator)<=1`
        # alone): K is built over QQ, so rational content normalises into the numerator.
        @test GL1Newton.az(1 // 2) == false
        @test GL1Newton.az(K(1) // K(2)) == false
        @test GL1Newton.az(GL1Newton.nu_grid(R, 1, 3) // K(2)) == false
        @test GL1Newton.az(inv(q - 1)) == false          # the (q^i - q^j) case
        @test GL1Newton.az(t^2 // q^3) == true
        @test GL1Newton.az(K(3) * q) == true
        @test GL1Newton.az(one(K)) == true
    end

    @testset "Q1 — qFunctions (v-side symmetric arithmetic, docstring values)" begin
        QF = GL1Newton.QFunctions
        @test QF.frame() === F                              # cached singleton
        @test QF.q_int_sym(F, 0) == zero(Kv)
        @test QF.q_int_sym(F, 1) == one(Kv)
        @test QF.q_int_sym(F, 2) == v + v^-1
        @test QF.q_int_sym(F, 5) == (v^5 - v^-5) / (v - v^-1)
        @test QF.q_int_sym(F, -3) + QF.q_int_sym(F, 3) == zero(Kv)   # antisymmetry
        @test QF.q_fact_sym(F, 0) == one(Kv)
        @test QF.q_fact_sym(F, -2) == one(Kv)                        # defensive
        @test QF.q_fact_sym(F, 5) == QF.q_int_sym(F, 5) * QF.q_fact_sym(F, 4)
        @test QF.q_binom_sym(F, 5, 2) ==
              QF.q_fact_sym(F, 5) / (QF.q_fact_sym(F, 2) * QF.q_fact_sym(F, 3))
        @test QF.q_binom_sym(F, 5, 2) == QF.q_binom_sym(F, 5, 3)     # k <-> n-k
        @test QF.q_binom_sym(F, 5, 6) == zero(Kv)
        @test QF.q_binom_sym(F, 5, -1) == zero(Kv)
        @test QF.sym_q_binom_value(F, 5, 2) == QF.q_binom_sym(F, 5, 2)  # overlap
        @test QF.sym_q_binom_value(F, 0, 1) == zero(Kv)              # numerator zero
        @test QF.sym_q_binom_value(F, -3, 2) ==
              (-1)^2 * QF.sym_q_binom_value(F, 4, 2)                 # reflection
        # v <-> v^-1 symmetry of [5]_v (substitute and compare; univariate, scalar evaluate)
        five = QF.q_int_sym(F, 5)
        @test evaluate(numerator(five), v^-1) // evaluate(denominator(five), v^-1) == five
    end

    @testset "A5 — mutate-and-recompute negative control (Gate-0 control C1)" begin
        # Corrupt ONE numerator node: (x - q^s) -> (x - q^s - 1). Acceptance A1 must FAIL.
        function nu_corrupt(r::Int)
            num = one(Rx); den = one(K)
            for s in 0:(r - 1)
                num *= (x - q^s - 1)
                den *= (q^r - q^s)
            end
            return num * inv(den)
        end
        c1(r, chi) = evaluate(nu_corrupt(r), GL1Newton.grid(R, chi))

        # A1 recomputed under the corruption: FAILS.
        @test !all(GL1Newton.az(c1(r, chi)) for r in 0:8 for chi in -9:9)
        # The count is the control, not a verdict string: gate0.json C1 records 78.
        @test count(!GL1Newton.az(c1(r, m)) for r in 1:6 for m in -6:6) == 78
        # named witness
        @test GL1Newton.az(c1(2, 2)) == false
        @test c1(2, 2) == (q^4 - q^3 - 3*q^2 + 2*q + 2) // (q^4 - q^3 - q^2 + q)
    end
end
