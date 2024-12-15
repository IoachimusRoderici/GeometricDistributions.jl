@testset "rand with UniformDirection{Point2f}" begin
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

@testset "rand! with UniformDirection{MVector{2, Float32}}" begin
    n_samples = 1000
    vector = MVector{2, Float32}(undef)
    points = Vector{Point2f}()
    for _ in 1:n_samples
        rand!(vector, UniformDirection())
        push!(points, Point2f(vector))
    end
    
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

@testset "randomizing in-place" begin
    n_samples = 5
    vector = MVector(1,2,3.)

    for _ in 1:n_samples
        prev = copy(vector)
        rand!(vector, UniformDirection())
        @test vector != prev
        @test norm(vector) ≈ 1
    end
end

@testset "no allocations" begin
    mutable3d = MVector(1,2,3.)
    @test @allocations(rand(UniformDirection(Point2f))) == 0
    @test @allocations(rand(UniformDirection(SVector{10, Float16}))) == 0
    @test @allocations(rand!(mutable3d, UniformDirection())) == 0
end
