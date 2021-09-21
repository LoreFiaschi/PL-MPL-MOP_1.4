mutable struct indiv{G, P, Y}
    x::G
    pheno::P
    y#::Y (commented because we need to rebuild the cost as a function to save it in a file)
    CV::Float64
    fitness::Integer
    indiv(x::G, pheno::P, y::Y, CV) where {G,P,Y} =
        new{G, P, Y}(x, pheno, y, CV, zero(UInt16))
end

function create_indiv(x, fdecode::Function, z::Function, fCV::Function)
    pheno = fdecode(x)
    y = z(pheno)
    indiv(x, pheno, y, fCV(pheno))
end

Base.show(io::IO, ind::indiv) = print(io, "indiv($(repr_pheno(ind.pheno)) : $(ind.y) | rank : $(ind.fitness))")

repr_pheno(x) = repr(x)

function repr_pheno(x::Union{BitVector, Vector{Bool}})
    res = map(x->x ? '1' : '0', x)
    if length(res) <= 40
        return "["*String(res)*"]"
    else
        return "["*String(res[1:15])*"..."*String(res[end-14:end])*"]"
    end
end

function eval!(indiv::indiv, fdecode!::Function, z::Function, fCV::Function)
    fdecode!(indiv.x, indiv.pheno)
    indiv.CV = fCV(indiv.pheno)
    indiv.CV ≈ 0 && (indiv.y = z(indiv.pheno))
    indiv
end

function tournament_selection(P, popSize)
    a, b = rand(1:popSize), rand(1:popSize)
    if P[a].fitness < P[b].fitness      #return the best one
		return P[a]
    elseif P[b].fitness < P[a].fitness
        return P[b]
	end
    return rand(Bool) ? P[a] : P[b]    #choose randomly if they're equal
end
