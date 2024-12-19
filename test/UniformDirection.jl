@testset "rand with UniformDirection{Point2f}" begin
    n_samples = 1000
    points = rand(UniformDirection(Point2f), n_samples)
    angles = map(point -> atan(point[2], point[1]), points)

    @test points isa Vector{Point2f}
    @test all(norm.(points) .≈ 1)
    @test all(-π .<= angles .<= π)
    @test KS_uniformity_test(angles, -π, π)
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
    @test KS_uniformity_test(angles, -π, π)
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
    @test KS_uniformity_test(x, -1, 1)
    @test KS_uniformity_test(y, -1, 1)
    @test KS_uniformity_test(z, -1, 1)
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
    @test KS_uniformity_test(x, -1, 1)
    @test KS_uniformity_test(y, -1, 1)
    @test KS_uniformity_test(z, -1, 1)
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
