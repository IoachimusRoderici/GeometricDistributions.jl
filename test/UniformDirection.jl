
"""
Return true if the histogram of `values` is approximately horizontal.

`edges` are the edges of the bins for the histogram.
`tolerance` is the maximum aceptable difference between the highest and
lowest bins, relative to the number of samples.
"""
function distribution_seems_uniform(values, edges, tolerance=0.05)
    histogram = fit(Histogram, values, edges)
    min, max = extrema(histogram.weights)
    (max - min) / length(values) < tolerance # All bins should have approximately equal weights.
end

@testset "rand with UniformDirection{Point2f}" begin
    n_samples = 1000
    points = rand(UniformDirection(Point2f), n_samples)
    angles = map(point -> atan(point[2], point[1]), points)

    @test points isa Vector{Point2f}
    @test all(norm.(points) .≈ 1)
    @test all(-π .<= angles .<= π)
    @test distribution_seems_uniform(angles, range(-π, π, 10))
end

@testset "rand! with UniformDirection{MVector{2, Float32}}" begin
    n_samples = 1000
    vector = MVector{2, Float32}(undef)
    points = Vector{Point2f}()
    for _ in 1:n_samples
        rand!(vector, UniformDirection())
        push!(points, Point2f(vector))
    end
    
    angles = map(point -> atan(point[2], point[1]), points)

    @test all(norm.(points) .≈ 1)
    @test all(-π .<= angles .<= π)
    @test distribution_seems_uniform(angles, range(-π, π, 10))
end

@testset "rand with UniformDirection{Point3d}" begin
    n_samples = 1000
    points = rand(UniformDirection(Point3d), n_samples)
    
    x = getindex.(points, 1)
    y = getindex.(points, 2)
    z = getindex.(points, 3)

    @test points isa Vector{Point3d}
    @test all(norm.(points) .≈ 1)

    # Test for uniformity: according to Archimedes theorem, all
    # slices of the same width should have the same amount of points.
    @test distribution_seems_uniform(x, -1:0.2:1)
    @test distribution_seems_uniform(y, -1:0.2:1)
    @test distribution_seems_uniform(z, -1:0.2:1)
end

@testset "rand! with UniformDirection{MVector{3, Float32}}" begin
    n_samples = 1000
    vector = MVector{3, Float32}(undef)
    points = Vector{Point3f}()
    for _ in 1:n_samples
        rand!(vector, UniformDirection())
        push!(points, Point3f(vector))
    end
    
    x = getindex.(points, 1)
    y = getindex.(points, 2)
    z = getindex.(points, 3)

    @test all(norm.(points) .≈ 1)

    # Test for uniformity: according to Archimedes theorem, all
    # slices of the same width should have the same amount of points.
    @test distribution_seems_uniform(x, -1:0.2:1)
    @test distribution_seems_uniform(y, -1:0.2:1)
    @test distribution_seems_uniform(z, -1:0.2:1)
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
