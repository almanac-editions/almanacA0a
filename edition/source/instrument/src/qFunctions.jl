# qFunctions.jl — symmetric quantum arithmetic, STANDALONE ALMANAC EDITION (v-side).
#
# PROVENANCE (almanacA0a pilot, 2026-08-10, hypervisorA on the Overseer's order): the
# four functions below are the A0a edition of the development substrate
#   HybridQuantum/src/QFunctions.jl   (at Sandbox commit 7ddb2e8f, source sha256
#   prefix fe86380d408330ac), rewritten in the CURRENT Sandbox-wide notation and
# decoupled from the HybridQuantum parent objects. HybridQuantum is NOT edited (AD-3).
#
# NOTATION (current, Sandbox-wide; q = v^2, t = z^2): the symmetric bracket family
# lives on the SQUARE-ROOT side — in the substrate these functions are written in its
# q, which is the current v. So here
#
#     [n]_v = (v^n - v^{-n}) / (v - v^{-1}),
#
# and every docstring below is in v. FUNCTION STEMS ARE IDENTIFIERS, NOT NOTATION
# (same rule as GL1Newton.az): the names q_int_sym, q_fact_sym, q_binom_sym,
# sym_q_binom_value are kept verbatim so the substrate correspondence — and the
# intern's CAS->Lean shallow-embedding job, which STARTS with this family — stays
# name-stable. DICTIONARY: substrate U.q = this v; substrate U.Qq = this F.K.
#
# DECOUPLING: the substrate signatures take a family parent U exposing U.Qq/U.q.
# Here the first argument is the module's own cached v-frame (`frame()`), exposing
# `.K` (the field QQ(v)) and `.v` (its generator). No other change.
#
# THE SEAM to GL1Newton (BQ-13 DESIGN §6.1, the bridge embedding lemmas silently
# drop; it needs v, not q, because r(m-r) may be odd):
#
#     nu_r(q^m) == v^{r(m-r)} * sym_q_binom_value(F, m, r)      (m >= r),
#
# stated in QQ(v) under q |-> v^2, t |-> 1. This identity is the acceptance test
# joining the QFunctions embedding (first) to the GL1Newton embedding (second).

module QFunctions

using Oscar: QQ, polynomial_ring, fraction_field, one, zero

"""
    QFunctions.VFrame

The v-side base data: the field `K = QQ(v)` with its generator `v` (the square root
of the quantum parameter, `q = v^2`). Build or fetch the cached instance with
[`frame`](@ref).
"""
struct VFrame
    K::Any
    v::Any
end

const _V_FRAME = Ref{Any}(nothing)

"""
    QFunctions.frame() -> VFrame

Return the cached v-side frame. Repeated calls return the identical object.
"""
function frame()
    cached = _V_FRAME[]
    cached === nothing || return cached
    Kr, vv = polynomial_ring(QQ, :v)
    K = fraction_field(Kr)
    F = VFrame(K, K(vv))
    _V_FRAME[] = F
    return F
end

"""
    q_int_sym(F::VFrame, n::Int) -> elem_type(F.K)

The symmetric quantum integer ``[n]_v = (v^n - v^{-n})/(v - v^{-1})``.

Antisymmetric in `n` (``[0]_v = 0``, ``[-n]_v = -[n]_v``). For ``n \\ge 0`` it is a
Laurent polynomial in `v` with nonnegative integer coefficients, symmetric under
``v \\mapsto v^{-1}``; ``[1]_v = 1``, ``[2]_v = v + v^{-1}``.
"""
function q_int_sym(F::VFrame, n::Int)
    v = F.v
    return (v^n - v^(-n)) / (v - v^(-1))
end

"""
    q_fact_sym(F::VFrame, n::Int) -> elem_type(F.K)

The symmetric quantum factorial ``[n]_v! = \\prod_{k=1}^{n} [k]_v`` for ``n \\ge 0``,
with ``[0]_v! = 1``; for ``n \\le 0`` the defensive value `1` is returned (negative
arguments are not mathematically meaningful). Satisfies ``[n]_v! = [n]_v [n-1]_v!``.
"""
function q_fact_sym(F::VFrame, n::Int)
    n <= 0 && return one(F.K)
    prodv = one(F.K)
    for i in 1:n
        prodv *= q_int_sym(F, i)
    end
    return prodv
end

"""
    q_binom_sym(F::VFrame, n::Int, k::Int) -> elem_type(F.K)

The symmetric quantum binomial ``\\binom{n}{k}_v = [n]_v!/([k]_v!\\,[n-k]_v!)`` for
``0 \\le k \\le n``; `zero(F.K)` outside that range. Symmetric under
``v \\mapsto v^{-1}`` and under ``k \\mapsto n-k``, with nonnegative integer
coefficients. For unrestricted (including negative) top argument use
[`sym_q_binom_value`](@ref).
"""
function q_binom_sym(F::VFrame, n::Int, k::Int)
    (k < 0 || k > n) && return zero(F.K)
    return q_fact_sym(F, n) / (q_fact_sym(F, k) * q_fact_sym(F, n - k))
end

"""
    sym_q_binom_value(F::VFrame, m::Int, k::Int) -> elem_type(F.K)

The symmetric quantum binomial VALUE
``\\prod_{r=1}^{k} (v^{m+1-r} - v^{-(m+1-r)})/(v^r - v^{-r})
 = \\prod_{r=1}^{k} [m+1-r]_v/[r]_v``,
with the empty product `1` at ``k = 0`` and `zero(F.K)` for ``k < 0``.

Unlike [`q_binom_sym`](@ref) the top `m` is unrestricted: boundary zeros arise by
numerator vanishing (``[0]_v`` factors), not a range guard, and the classical
reflection ``\\binom{-m}{k} = (-1)^k \\binom{m+k-1}{k}`` lifts:
``sym\\_q\\_binom\\_value(F,-m,k) = (-1)^k\\,sym\\_q\\_binom\\_value(F,m+k-1,k)``.
On the overlap ``0 \\le k \\le m`` it agrees with [`q_binom_sym`](@ref).
"""
function sym_q_binom_value(F::VFrame, m::Int, k::Int)
    v = F.v
    k < 0 && return zero(F.K)
    k == 0 && return one(F.K)
    prodv = one(F.K)
    for r in 1:k
        prodv *= (v^(m + 1 - r) - v^(-m - 1 + r)) / (v^r - v^(-r))
    end
    return prodv
end

end # module QFunctions
