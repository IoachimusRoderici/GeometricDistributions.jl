module GeometricDistributions

using Random
using LinearAlgebra: normalize, normalize!

"""
    abstract type GeometricDistribution end
    
Abstract type to represent distributions in geometric space.
"""
abstract type GeometricDistribution end

# Fallback to rand! when rand is not defined:
function Random.rand(rng::AbstractRNG, d::Random.SamplerTrivial{<:GeometricDistribution})
    v = similar(Random.eltype(d))
    rand!(rng, v, d)
    convert(T, v)
end


include("UniformDirection.jl")

end
