@testset "rand with UniformInsideUnitSphere{Point2f}" begin
    n_samples = 1000
    points = rand(UniformInsideUnitSphere(Point2f), n_samples)
    angles = map(point -> atan(point[2], point[1]), points)

    @test points isa Vector{Point2f}
    @test all(norm.(points) .<= 1)
    @test all(-π .<= angles .<= π)
    @test KS_uniformity_test(angles, -π, π)
end

@testset "rand! with UniformInsideUnitSphere{MVector{2, Float32}}" begin
    n_samples = 1000
    vector = MVector{2, Float32}(undef)
    points = Vector{Point2f}()
    for _ in 1:n_samples
        rand!(vector, UniformInsideUnitSphere())
        push!(points, Point2f(vector))
    end
    
    angles = map(point -> atan(point[2], point[1]), points)

    @test all(norm.(points) .<= 1)
    @test all(-π .<= angles .<= π)
    @test KS_uniformity_test(angles, -π, π)
end

struct RadiusDistribution <: ContinuousUnivariateDistribution end
Distributions.cdf(d::RadiusDistribution, x::Real) = 0<=x<=1 ? x^3 : zero(x)

@testset "rand with UniformInsideUnitSphere{Point3d}" begin
    n_samples = 1000
    points = rand(UniformInsideUnitSphere(Point3d), n_samples)
    
    radiuses = norm.(points)
    angles_x = map(point -> atan(point[3], point[2]), points)
    angles_y = map(point -> atan(point[3], point[1]), points)
    angles_z = map(point -> atan(point[1], point[2]), points)

    @test points isa Vector{Point3d}
    @test all(radiuses .<= 1)

    @test KS_uniformity_test(angles_x, -π, π)
    @test KS_uniformity_test(angles_y, -π, π)
    @test KS_uniformity_test(angles_z, -π, π)

    @test KS_distribution_test(radiuses, RadiusDistribution())
end

@testset "rand! with UniformInsideUnitSphere{MVector{3, Float32}}" begin
    n_samples = 1000
    vector = MVector{3, Float32}(undef)
    points = Vector{Point3f}()
    for _ in 1:n_samples
        rand!(vector, UniformInsideUnitSphere())
        push!(points, Point3f(vector))
    end

    radiuses = norm.(points)
    angles_x = map(point -> atan(point[3], point[2]), points)
    angles_y = map(point -> atan(point[3], point[1]), points)
    angles_z = map(point -> atan(point[1], point[2]), points)

    @test all(norm.(points) .<= 1)

    @test KS_uniformity_test(angles_x, -π, π)
    @test KS_uniformity_test(angles_y, -π, π)
    @test KS_uniformity_test(angles_z, -π, π)

    @test KS_distribution_test(radiuses, RadiusDistribution())
end

@testset "randomizing in-place" begin
    n_samples = 5
    vector = MVector(1,2,3.)

    for _ in 1:n_samples
        prev = copy(vector)
        rand!(vector, UniformInsideUnitSphere())
        @test vector != prev
        @test norm(vector) <= 1
    end
end
