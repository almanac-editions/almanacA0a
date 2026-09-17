# GL1Newton.jl — the even Newton objects of GL_1, STANDALONE ALMANAC EDITION.
#
# PROVENANCE (almanacA0a pilot, extraction of 2026-08-10, hypervisorA on the Overseer's
# order): the module body below is copied VERBATIM from the development substrate
#   HybridQuantum/src/A1/gl1_newton.jl   (BQ-13 build, 2026-07-20; design of record
#   Sandbox/build/designs/BQ-13_DESIGN.md)
# at Sandbox commit 7ddb2e8f, source sha256
#   2a2fe469d87255a15e0e2332bbd69830876fe2915d5b260e4fef6d8ae7ff6c72.
# Only this provenance header and the package wrapper (Project.toml; the module is now
# top-level instead of nested under HybridQuantum.A1) differ. HybridQuantum remains the
# single development substrate (AD-3: BUILD is its writer); this package is a pinned
# snapshot for the published almanacA0a edition and is NOT independently developed.
#
# NOTATION MIGRATION 2026-08-10 (Overseer-ordered, Sandbox-wide, applied to this package
# on the same order): the former symbols Q, q, z are written q, v, t, with q = v^2 and
# t = z^2; the ring A_z is written A_t = Z[q^{+-1}, t^{+-1}] at this layer. Frame fields
# renamed Q -> q, z -> t accordingly; product index t -> s. The STEM NAMES of the
# three-world contract (nu, grid, az, newton, ...) are IDENTIFIERS, not notation, and are
# unchanged -- `az` keeps its name (it is named for the legacy ring symbol) so the
# certified Lean column stays aligned. DICTIONARY to the legacy worlds: the HybridQuantum
# substrate (src/A1/gl1_newton.jl) and the certified Lean layer (Sandbox/A1/GL1/) still
# write Q, q, z; substrate Q = this q, substrate q = this v, substrate z = this t.
#
# THE THREE-WORLD SAME-NAME CONTRACT (binding; BQ-13 DESIGN §2): one stem per object,
# same names in the human notes (goalv0a/proofv0a .tex), this Julia layer, and the Lean
# layer (Sandbox/A1/GL1/, kernel-certified 2026-07-21, clean axiom triple):
#
#   notes (.tex)            Julia (here)              Lean (Sandbox/A1/GL1)
#   ----------------------  ------------------------  ------------------------
#   K[x], K = QQ(q,t)        GL1Newton.Frame           GL1Newton.Frame
#   nu_r(x)                 GL1Newton.nu(R, r)        GL1Newton.nu r
#   ev_chi(x) = q^chi       GL1Newton.grid(R, chi)    GL1Newton.grid chi
#   nu_r(q^chi)             GL1Newton.nu_grid(...)    GL1Newton.nuGrid r chi
#   c_r                     GL1Newton.expand(R, f)    GL1Newton.expand f
#   c in A_t                GL1Newton.az(c)           GL1Newton.Az c
#   f in N^ev               GL1Newton.newton(R, f)    GL1Newton.Newton f
#   f in span_Az(nu)        GL1Newton.mem_span(R,f)   GL1Newton.memSpan f
#   f in A_t[x]             GL1Newton.laurent(R, f)   GL1Newton.Laurent f
#
module GL1Newton

# NOTE (DESIGN F1): GL1Newton is a NESTED module. It inherits nothing from module A1's
# own `using Oscar: ...` list (A1.jl:3-7). These imports are load-bearing — without them
# `degree`, `evaluate`, `coeff`, ... are UndefVarError inside this module.
using Oscar: QQ, polynomial_ring, fraction_field, evaluate, degree, coeff,
             elem_type, denominator, numerator, coefficients, one, zero, iszero,
             inv, is_integral

# ---------------------------------------------------------------------------
# 0. The base ring
# ---------------------------------------------------------------------------

"""
    GL1Newton.Frame

The GL_1 even-Newton base ring data: the coefficient field `K = QQ(q,t)` with
transcendental `q, t` and `q = v^2`, the univariate ring `Rx = K[x]` in one toral
coordinate, and the generators `q, t, x`. Everything is commutative.

Frame pins: `ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because
`2rho = 0`; `t` is a spectator and `W = {1}`. Build or fetch the cached instance with
[`frame`](@ref).
"""
struct Frame
    K::Any
    Rx::Any
    q::Any
    t::Any
    x::Any
end

const _GL1_NEWTON_FRAME = Ref{Any}(nothing)

"""
    GL1Newton.frame() -> Frame

Return the cached GL_1 even-Newton frame. Repeated calls return the identical object.

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
`ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because `2rho = 0`;
`t` is a spectator and `W = {1}`.
"""
function frame()
    cached = _GL1_NEWTON_FRAME[]
    cached === nothing || return cached

    Kr, (qv, tv) = polynomial_ring(QQ, [:q, :t])
    K = fraction_field(Kr)
    Rx, x = polynomial_ring(K, :x)
    R = Frame(K, Rx, K(qv), K(tv), x)
    _GL1_NEWTON_FRAME[] = R
    return R
end

# ---------------------------------------------------------------------------
# 1. The divided classes
# ---------------------------------------------------------------------------

"""
    GL1Newton.nu(R::Frame, r::Int) -> elem_type(R.Rx)

The `r`-th even Newton divided class

    nu_r(x) = prod_{s=0}^{r-1} (x - q^s) / prod_{s=0}^{r-1} (q^r - q^s),   nu_0(x) = 1,

the degree-`r` Newton interpolation polynomial for the nodes `q^0, q^1, ..., q^{r-1}`,
normalised at the next node: `nu_r(q^m) = 0` for `0 <= m < r` and `nu_r(q^r) = 1`.

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
the nodes `ev_chi(x) = q^chi` range over every `chi in Z`, unshifted and `t`-free
because `2rho = 0`; `t` is a spectator and `W = {1}`. Throws `ArgumentError` for
`r < 0`.

Definition of record: goalv0a.tex Def 5.
"""
function nu(R::Frame, r::Int)
    r < 0 && throw(ArgumentError("r must be nonnegative"))
    r == 0 && return one(R.Rx)

    num = one(R.Rx)
    den = one(R.K)
    for s in 0:(r - 1)
        num *= R.x - R.q^s
        den *= R.q^r - R.q^s
    end
    return num * inv(den)
end

# ---------------------------------------------------------------------------
# 2. The grid
# ---------------------------------------------------------------------------

"""
    GL1Newton.grid(R::Frame, chi::Integer) -> elem_type(R.K)

The `chi`-th node `ev_chi(x) = q^chi` of the geometric grid; `chi` may be negative, and
the grid is two-sided over all of `Z`.

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
`ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because `2rho = 0`;
`t` is a spectator and `W = {1}`. Thus there is no `v`-shift. The GL_2 shifted convention
`Y_1 = q z_1^{-1} Ycheck_1` does NOT apply here and would introduce a spurious factor
`q`. The correct two-variable analogue is the `:xi_hat` branch of
`gl2_verma_toral_grid_value` (src/A1/gl2_verma.jl:41-47), which likewise returns a bare
`q^lambda` — cited for consistency only; nothing here is defined from it.

Definition of record: goalv0a.tex Def 2.
"""
function grid(R::Frame, chi::Integer)
    return R.q^Int(chi)
end

"""
    GL1Newton.nu_grid(R::Frame, r::Int, chi::Integer) -> elem_type(R.K)

The value `nu_r(q^chi)`.

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
`ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because `2rho = 0`;
`t` is a spectator and `W = {1}`.

Lies in `A_t = Z[q^{+-1}, t^{+-1}]` for every `r >= 0` and every `chi in Z`: although
`nu_r` carries the denominator `prod_{s<r}(q^r - q^s)`, no denominator survives on the
grid. Equals the Gaussian binomial `[chi, r]_Q` for `chi >= r`, and for `chi = -n < 0`

    nu_r(q^{-n}) = (-1)^r q^{-rn-binom(r,2)} [n+r-1, r]_Q.

Bridge to the package's symmetric normalisation (an identity embedding lemmas silently
drop; it needs `v`, not `q`, since `r(m-r)` may be odd):

    nu_r(q^m) == v^{r(m-r)} * sym_q_binom_value(U, m, r)     (m >= r),

stated in `QQ(v)`; this module never sees `v`. See DESIGN §6.1.
"""
function nu_grid(R::Frame, r::Int, chi::Integer)
    return evaluate(nu(R, r), grid(R, chi))
end

# ---------------------------------------------------------------------------
# 3. Coordinates in the Newton basis
# ---------------------------------------------------------------------------

"""
    GL1Newton.expand(R::Frame, f; D=nothing) -> Dict{Int, elem_type(R.K)}

Expand `f in R.Rx` in the Newton basis, `f = sum_r c_r nu_r`, through degree `D`
(default: the degree of `f`). Returns the NONZERO coordinates `c_r in R.K`, keyed by `r`.

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
`ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because `2rho = 0`;
`t` is a spectator and `W = {1}`.

Since `deg nu_r = r`, the expansion exists and is unique; it is computed by the
triangular sweep from the top degree down. A nonzero remainder (i.e. `f` does not have
degree `<= D`) is reported as an `error`.
"""
function expand(R::Frame, f; D::Union{Nothing,Integer}=nothing)
    f = R.Rx(f)
    DD = D === nothing ? degree(f) : Int(D)
    rem = f
    coords = Dict{Int,elem_type(R.K)}()
    for r in DD:-1:0
        lr = coeff(rem, r)
        iszero(lr) && continue
        basis = nu(R, r)
        c = lr * inv(coeff(basis, r))
        coords[r] = c
        rem -= c * basis
    end
    iszero(rem) || error("GL1Newton.expand: nonzero remainder (f not a degree-$DD polynomial?)")
    return coords
end

# ---------------------------------------------------------------------------
# 4. Integrality
# ---------------------------------------------------------------------------

"""
    GL1Newton.az(c) -> Bool

True iff `c in K = QQ(q,t)` lies in `A_t = Z[q^{+-1}, t^{+-1}]`.

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
`ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because `2rho = 0`;
`t` is a spectator and `W = {1}`.

TWO conditions, both required:

 1. the reduced denominator is a single monomial in `q, t` — this is what rejects the
    `(q^i - q^j)` factors that the Newton basis change introduces;
 2. every coefficient of the reduced numerator and denominator is an INTEGER (and the
    denominator's coefficient is a unit) — this is what rejects `1//2`, which condition
    1 alone accepts, because `K` is built over `QQ` and Oscar's fraction normalisation
    moves rational content into the numerator.

Frame note: `goalv0a.tex` writes `A_t = Z[v^{+-1}, t^{+-1}]`; this layer's base field has
no `v`, so the test above is the STRONGER condition `Z[q^{+-1}, t^{+-1}]` (DESIGN §1.2).
This predicate is deliberately STRICTER than the two-variable helper
`_gl2_wbal_laurent_ok` (src/A1/gl2_weyl_balanced_newton.jl:117), which tests condition 1
only; that helper is not edited by this ticket.
"""
function az(c)
    c = frame().K(c)
    n = numerator(c)
    d = denominator(c)
    length(d) <= 1 || return false

    ncoeffs = coefficients(n)
    dcoeffs = collect(coefficients(d))
    all(is_integral(QQ(t)) for t in ncoeffs) || return false
    all(is_integral(QQ(t)) for t in dcoeffs) || return false
    return length(dcoeffs) == 1 && (isone(dcoeffs[1]) || isone(-dcoeffs[1]))
end

"""
    GL1Newton.newton(R::Frame, f; window=12) -> (Bool, Symbol, Int)

Test the defining evaluation-integrality condition for the even Newton lattice: whether
`f(q^chi)` lies in `A_t` at every grid point with `-window <= chi <= window`.

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
`ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because `2rho = 0`;
`t` is a spectator and `W = {1}`.

The defining quantifier ranges over all integers, so a finite computation returns only a
bounded verdict: `(true, :PROVED_BOUNDED, window)`, or `(false, :REFUTED, chi)` at the first
failing node. It never returns an unbounded Boolean proof. Throws `ArgumentError` if
`window < 0`.

This is deliberately distinct from [`mem_span`](@ref), the Newton-coordinate predicate.
Their equivalence is the theorem `Newton_iff_mem_span`, not a definition. Trap 4 is instead
the strict inclusion `A_t[x] < N^ev`: on `nu(R,1)`, `newton` has a positive bounded verdict,
`mem_span` is true, and [`laurent`](@ref) is false.

Definition of record: goalv0a.tex Def 2. The bounded return contract is ROOT AMENDMENT 2.
"""
function newton(R::Frame, f; window::Int = 12)
    window < 0 && throw(ArgumentError("window must be nonnegative"))
    f = R.Rx(f)
    for chi in -window:window
        az(evaluate(f, grid(R, chi))) || return (false, :REFUTED, chi)
    end
    return (true, :PROVED_BOUNDED, window)
end

"""
    GL1Newton.mem_span(R::Frame, f) -> Bool

Membership in `sum_{r>=0} A_t nu_r`: every Newton coordinate of `f` (see [`expand`](@ref))
lies in `A_t`. This is the RIGHT-hand side of goalv0a clause (iii), NOT the definition of
`N^ev`. Deciding that `newton` and `mem_span` agree IS clause (iii); using this function to
referee that clause would assume what is to be shown. The Lean layer mirrors the separation
exactly: `Newton` is the evaluation predicate and `Newton_iff_mem_span` is a proved theorem
(certified: release_verify --source ALL CLEAN, 2026-07-20).

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
`ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because `2rho = 0`;
`t` is a spectator and `W = {1}`.
"""
function mem_span(R::Frame, f)
    return all(az(c) for c in values(expand(R, f)))
end

"""
    GL1Newton.laurent(R::Frame, f) -> Bool

Membership in `A_t[x]`: every coefficient of `f` in the MONOMIAL basis `1, x, x^2, ...`
lies in `A_t`.

Frame pins: `q = v^2`, `K = QQ(q,t)`, and `Rx = K[x]` has one toral coordinate;
`ev_chi(x) = q^chi` for every `chi in Z`, unshifted and `t`-free because `2rho = 0`;
`t` is a spectator and `W = {1}`.

Distinct from [`newton`](@ref) — the Newton basis change introduces `(q^i - q^j)`
denominators, and `A_t[x]` is strictly smaller than `N^ev`. The smallest witness is
`nu(R, 1) = (x-1)/(q-1)`, which lies in `N^ev` but not in `A_t[x]`.

Index convention (DESIGN F3): in the univariate ring `coeff(f, i)` is the coefficient of
`x^i`, 0-indexed, and `length(f)` is `degree(f)+1`. The loop is therefore `0:degree(f)`.
The two-variable analogue `gl2_element_laurent` uses `1:length(f)` — correct there only
because that ring is MULTIVARIATE and `coeff` is term-indexed. Copying it here skips the
constant term and returns `true` on inputs such as `x - 1//(q-1)`.
"""
function laurent(R::Frame, f)
    f = R.Rx(f)
    iszero(f) && return true
    return all(az(coeff(f, i)) for i in 0:degree(f))
end

# The v-side symmetric quantum arithmetic of the almanac (the A0a edition of the
# substrate's QFunctions.jl, current notation, own provenance header inside).
include("qFunctions.jl")

end # module GL1Newton
