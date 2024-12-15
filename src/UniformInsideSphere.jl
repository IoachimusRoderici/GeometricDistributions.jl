export UniformInsideUnitSphere
# TODO: add UniformInsideSphere

"""
    UniformInsideUnitSphere{T} <: GeometricDistribution

Uniform distribution of points inside the unit sphere.

`T` is the type used to represent points.
"""
struct UniformInsideUnitSphere{T} <: GeometricDistribution end

UniformInsideUnitSphere(::Type{T}) where T = UniformInsideUnitSphere{T}()
UniformInsideUnitSphere() = UniformInsideUnitSphere(Missing)

Random.eltype(::Type{UniformInsideUnitSphere{T}}) where T = T

"""
Return a radius ∈ [0, 1) with the cdf for uniform distribution
in the volume of a unit n-sphere: cdf(r) = r^(1/n)

TODO: multiply by radius != 1 for non-unit spheres.
"""
sample_radius_inside_unit_sphere(rng, ::Type{T}) where T = convert(eltype(T), rand(rng)^inv(length(T)))

function Random.rand(rng::AbstractRNG, ::Random.SamplerTrivial{UniformInsideUnitSphere{T}, T}) where T
    # from https://math.stackexchange.com/a/87238
    return ( rand(rng, UniformDirection{T}()) * sample_radius_inside_unit_sphere(rng, T) )::T
end

function Random.rand!(rng::AbstractRNG, v::AbstractArray{<:Number}, ::Random.SamplerTrivial{<:UniformInsideUnitSphere})
    # from https://math.stackexchange.com/a/87238
    rand!(rng, v, UniformDirection())
    v .*= sample_radius_inside_unit_sphere(rng, typeof(v))
    return v
end