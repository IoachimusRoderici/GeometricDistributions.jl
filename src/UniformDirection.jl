export UniformDirection

"""
    UniformDirection{T} <: GeometricDistribution

Uniform distribution of directions, or equivalently, uniform
distribution of points on the surface of the unit sphere.

`T` is the type used to represent points or vectors.
"""
struct UniformDirection{T} <: GeometricDistribution end

UniformDirection(::Type{T}) where T = UniformDirection{T}()
UniformDirection() = UniformDirection(Missing)

Random.eltype(::Type{UniformDirection{T}}) where T = T

function Random.rand(rng::AbstractRNG, ::Random.SamplerTrivial{UniformDirection{T}, T}) where T
    v = randn(rng, T)
    while iszero(v)
        v = randn(rng, T)
    end
    normalize(v)
end

function Random.rand!(rng::AbstractRNG, v::AbstractArray, ::Random.SamplerTrivial{UniformDirection{T}, T}) where T
    randn!(rng, v)
    while iszero(v)
        randn!(rng, v)
    end
    normalize!(v)
end