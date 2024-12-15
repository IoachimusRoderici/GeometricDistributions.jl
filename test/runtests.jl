using Test, Random, LinearAlgebra, GeometryBasics, StaticArrays, StatsBase
using GeometricDistributions

@testset "GeometricDistributions.jl" begin
    @testset "UniformDirection" begin include("UniformDirection.jl") end
end