module GeometricDistributions

using Random
using LinearAlgebra: normalize, normalize!

"""
    abstract type GeometricDistribution end
    
Abstract type to represent distributions in geometric space.
"""
abstract type GeometricDistribution end

include("UniformDirection.jl")

end
