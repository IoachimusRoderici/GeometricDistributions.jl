@testset "UniformDirection{Point2f}" begin
    n_samples = 1000
    points = rand(UniformDirection(Point2f), n_samples)
    norms = norm.(points)
    angles = map(point -> atan(point[2], point[1]), points)

    @test points isa Vector{Point2f}
    @test all(norms .≈ 1)
    @test all(-π .<= angles .<= π)
    @test let histogram = fit(Histogram, angles, range(-π, π, 10))
        max, min = extrema(histogram.weights)
        (max - min) / n_samples < 0.1 # All bins should have approximately equal weights.
    end
end

@testset "allocations" begin
    @test @allocations(rand(UniformDirection(Point2f))) == 0
    @test @allocations(rand!(MVector(1,2,3.), UniformDirection())) == 0
end
