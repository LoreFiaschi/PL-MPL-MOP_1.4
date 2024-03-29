mutable struct indiv{G, P, Y, C}
    x::G
    pheno::P
    y::Y #Matrix
    CV::Float64
    rank::UInt16
    crowding::C #Vector
    dom_count::UInt16
    dom_list::Vector{UInt16}
    indiv(x::G, pheno::P, y::Y, cv, crowding::C) where {G,P,Y,C} =
        new{G, P, Y, C}(x, pheno, y, cv, zero(UInt16), crowding, zero(UInt16), UInt16[])
end
function create_indiv(x, fdecode, z, fCV)
    pheno = fdecode(x)
    y = z(pheno)
    crowding = zeros(size(y,2))
    indiv(x, pheno, y, fCV(pheno), crowding)
end

struct Max end
struct Min end

function dominates(::Min, a::indiv, b::indiv, gp::Int, τ::T) where T<:Real
    a.CV != b.CV && return a.CV < b.CV
	diff = a.y[:,gp]-b.y[:,gp]
	any(x->x>0, diff) && return false
	any(x->x<0, diff) && return true
	a.crowding[gp] >= b.crowding[gp]+τ && return true
    return false
end

function dominates(::Max, a::indiv, b::indiv, gp::Int, τ::T) where T<:Real
    a.CV != b.CV && return a.CV < b.CV
	diff = a.y[:,gp]-b.y[:,gp]
	any(x->x<0, diff) && return false
	any(x->x>0, diff) && return true
	a.crowding[gp] >= b.crowding[gp]+τ && return true
    return false
end

@inline function better(a::indiv, b::indiv, τ::T) where T<:Real #Comparison operator for tournament selection
	return (a.rank < b.rank || (a.rank == b.rank && a.crowding >= b.crowding .+ τ)) # >= is implicitly element-wise
end

Base.:(==)(a::indiv, b::indiv) = a.x == b.x
Base.hash(a::indiv) = hash(a.x)
Base.show(io::IO, ind::indiv) = print(io, "indiv($(repr_pheno(ind.pheno)) : $(ind.y) | rank : $(ind.rank))")
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
