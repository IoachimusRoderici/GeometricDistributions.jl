using Test, Random, LinearAlgebra, StaticArrays, GeometryBasics
using StatsBase, HypothesisTests, Distributions
using GeometricDistributions

include("distribution_tests.jl")

@testset "GeometricDistributions.jl" begin
    @testset "UniformDirection"        begin include("UniformDirection.jl")        end
    @testset "UniformInsideUnitSphere" begin include("UniformInsideUnitSphere.jl") end

    include("no_allocations.jl")
end