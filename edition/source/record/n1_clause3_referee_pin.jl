# N1 referee pin — clause (iii) refereed NON-CIRCULARLY by the BQ-13 instrument.
# The two predicates are independent by construction: `newton` = evaluation-integrality
# on the grid ev_chi(x) = Q^chi (goalv0a Def 2); `mem_span` = A_z-membership of the
# Newton COORDINATES (goalv0a clause (iii) RHS). Their agreement on samples + the
# refutation of hostile seeds is evidence FOR clause (iii) that assumes nothing about it.
# Verdict taxonomy: PROVED_BOUNDED / REFUTED. Seed fixed for reproducibility.
using Random, Test
using HybridQuantum
const G = HybridQuantum.A1.GL1Newton
Random.seed!(20260721)

R = G.frame()
Rx = R.Rx; x = gens(Rx)[1]; K = base_ring(Rx)
Qv = R.Q; zv = R.z
W = 8          # grid window per side
NS = 60        # positive samples
fails = String[]

# -- positive lane: random A_z-combinations of the clause-(iii) generators x^u nu_r --
for i in 1:NS
    f = zero(Rx)
    for _ in 1:rand(1:4)
        u = rand(0:5); r = rand(0:4)
        a = Qv^rand(-3:3) * zv^rand(-2:2) * rand(-5:5)    # a in A_z (may be 0)
        f += a * x^u * G.nu(R, r)
    end
    nv = G.newton(R, f; window=W)
    mv = G.mem_span(R, f)
    (nv[1] == true == mv) ||
        push!(fails, "POS sample $i: newton=$(nv) mem_span=$(mv) f=$(f)")
end

# -- hostile lane: seeds that must be REFUTED by BOTH predicates --
hostiles = [
    ("const 1/(Q-1)",            Rx(1//(Qv-1))),
    ("x/(Q-1)",                  x * Rx(1//(Qv-1))),
    ("z-contaminated 1/(z-1)?",  Rx(1//(zv^2+1))),       # denominator in z: not in A_z anywhere
    ("half-integer 1//2",        Rx(K(1//2))),
    ("nu_2 scaled by 1/(Q-1)",   Rx(1//(Qv-1)) * G.nu(R, 2)),
]
for (name, g) in hostiles
    nv = G.newton(R, g; window=W)
    mv = G.mem_span(R, g)
    (nv[1] == false && mv == false) ||
        push!(fails, "HOSTILE '$name': newton=$(nv) mem_span=$(mv) — NOT refuted by both")
end

# -- separator lane: nu_1 in N^ev but NOT in A_z[x] (the strictness pin) --
s = G.nu(R, 1)
G.newton(R, s; window=W)[1] || push!(fails, "SEPARATOR nu_1: newton false")
G.mem_span(R, s)            || push!(fails, "SEPARATOR nu_1: mem_span false")
G.laurent(R, s)            && push!(fails, "SEPARATOR nu_1: laurent TRUE (should be strict)")

if isempty(fails)
    println("VERDICT\tPROVED_BOUNDED\twindow=$(W) positives=$(NS) hostiles=$(length(hostiles)) separator=1 disagreements=0")
else
    println("VERDICT\tREFUTED\t$(length(fails)) failures")
    foreach(println, fails)
end
